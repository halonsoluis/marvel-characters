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
    
    var currentPageObservable : Observable<Int>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentPageObservable = currentPage
            .asObservable()
            .distinctUntilChanged()
            .filter { $0 >= 0 }
        
        createCharacterService()
        appendSubscribers()
    //    appendTestSuscriber()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func createCharacterService() {
        chs = CharacterService(pageObservable: currentPageObservable)
    }
    
    func appendSubscribers() {
        chs.rx_characters
            .flatMapLatest(errorValidation)
            .drive(tableView.rx_itemsWithCellIdentifier("CharacterCell", cellType: CharacterCell.self)) { (_, character, cell) in
                
                if let nameLabel = cell.nameLabel as? UIButton {
                    nameLabel.setTitle(character.name, forState: UIControlState.Normal)
                  
                    print("intrinsic label \(nameLabel.titleLabel?.intrinsicContentSize().width)")
                    print("intrinsic button\(nameLabel.intrinsicContentSize().width)")
                    print("intrinsic button frame\(nameLabel.frame.width)")
                    
                    nameLabel.sizeToFit()
                    print("size to Fit")
                    
                    print("intrinsic label \(nameLabel.titleLabel?.intrinsicContentSize().width)")
                    print("intrinsic button\(nameLabel.intrinsicContentSize().width)")
                    print("intrinsic button frame\(nameLabel.frame.width)")
                    
                    
                } else if let nameLabel = cell.nameLabel as? UILabel {
                    nameLabel.text = character.name
                     cell.nameLabel.sizeToFit()
                }
               
                
               // cell.nameLabel.updateConstraints()
                cell.bannerImage.image = nil
                
                guard let url = character.thumbnail?.url(), let nsurl = NSURL(string: url), let modified = character.modified else { return }
                ImageSource.downloadImageAndSetIn(cell.bannerImage, imageURL: nsurl, withUniqueKey: modified)
            }
            .addDisposableTo(disposeBag)
        
        chs.rx_characters
            .flatMapLatest(errorValidation)
            .drive(dataSource)
            .addDisposableTo(disposeBag)
    }
    
    
    func appendTestSuscriber(){
        Observable.of(0,1,2, 2, 1, 4, 3)
            .buffer(timeSpan: RxTimeInterval(3500), count: 1, scheduler: MainScheduler.asyncInstance)
            .filter { $0.first != nil }
            .map { $0.first! }
            .doOnNext() { print("emits \($0)") }
            .bindTo(currentPage)
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

