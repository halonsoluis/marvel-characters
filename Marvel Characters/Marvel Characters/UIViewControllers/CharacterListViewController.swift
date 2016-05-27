//
//  CharacterListViewController.swift
//  Marvel Characters
//
//  Created by Hugo on 5/25/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Result

class CharacterListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerView: UIView!
   
    
    let disposeBag = DisposeBag()
    
    let dataSource = Variable<[Character]>([])
    
    /// Value of current page
    var currentPage = Variable<Int>(0)
    
    var chs : CharacterService!
    
    let errorValidation = { (result: Result<[Character],RequestError>) -> Driver<[Character]> in
        switch result {
        case .Success(let character):
            return Driver.just(character)
        case .Failure(_):
            return Driver.empty()
        }
    }
    var loadingMore = false {
        didSet {
            footerView.hidden = !loadingMore
        }
    }
    var currentPageObservable : Observable<Int>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentPageObservable = currentPage
            .asObservable()
            .distinctUntilChanged()
            .filter { $0 >= 0 }
        
        
        createCharacterService()
        appendSubscribers()
        setupPagination()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func createCharacterService() {
        chs = CharacterService(pageObservable: currentPageObservable)
    }
    
    func setupPagination() {
        
        tableView.rx_contentOffset
            .debounce(0.1, scheduler: MainScheduler.instance)
          //  .throttle(0.05, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .skipWhile { [weak self] (offset) -> Bool in
                guard let `self` = self else {return true }
                
                guard
                    !self.loadingMore &&
                    offset.y > UIScreen.mainScreen().bounds.height
                    else {return true}
                self.loadingMore = true
                
                return false
            }
            .observeOn(MainScheduler.instance)
            .bindNext { [weak self] (offset) in
                guard let `self` = self else { return }
               
                print("offset = \(offset)")
                let bounds = self.tableView.bounds
                let size = self.tableView.contentSize
                let inset = self.tableView.contentInset
                let y = offset.y + bounds.size.height - inset.bottom
                let h = size.height
                let reload_distance : CGFloat = UIScreen.mainScreen().bounds.height * 2
                if y > (h - reload_distance) {
                    
                    self.currentPage.value = self.currentPage.value + 1
                    print("load page = \(self.currentPage.value)")
                }
            }
            .addDisposableTo(disposeBag)
        
      //  tableView.tableFooterView = footerView
    }
    
    func appendSubscribers() {
        dataSource.asDriver()
            .drive(tableView.rx_itemsWithCellIdentifier("CharacterCell", cellType: CharacterCell.self)) { (_, character, cell) in
                
                if let nameLabel = cell.nameLabel as? UIButton {
                    nameLabel.setTitle(character.name, forState: UIControlState.Normal)
                } else if let nameLabel = cell.nameLabel as? UILabel {
                    nameLabel.text = character.name
                }
                
                cell.nameLabel.sizeToFit()
                cell.bannerImage.image = nil
                
                guard let url = character.thumbnail?.url(), let nsurl = NSURL(string: url), let modified = character.modified else { return }
                ImageSource.downloadImageAndSetIn(cell.bannerImage, imageURL: nsurl, withUniqueKey: modified)
            }
            .addDisposableTo(disposeBag)
        
        chs.rx_characters
            .flatMapLatest(errorValidation)
            .driveNext { (newPage) in
                    self.dataSource.value.appendContentsOf(newPage)
                    if newPage.count < APIHandler.itemsPerPage { self.loadingMore = false }
            }
            .addDisposableTo(disposeBag)
    }
    
    /*
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     let characterDetails = segue.destinationViewController as! CharacterDetailsViewController
     
     guard
     let indexPath = tableView.indexPathForSelectedRow,
     let character = dataSource.value[indexPath.row]
     else { return }
     
     characterDetails.character = character
     }*/
}

