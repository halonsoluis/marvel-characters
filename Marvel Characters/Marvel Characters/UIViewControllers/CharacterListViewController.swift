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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentPageObservable = currentPage.asObservable()
        
        let chs = CharacterService(pageObservable: currentPageObservable)
        
        let errorValidation = { (result: Result<[Character],RequestError>) -> Driver<[Character]> in
            switch result {
            case .Success(let character):
                return Driver.just(character)
            case .Failure(_):
                return Driver.empty()
            }
        }
        
        chs.rx_characters
            .flatMapLatest(errorValidation)
            .drive(tableView.rx_itemsWithCellIdentifier("CharacterCell", cellType: CharacterCell.self)) { (_, character, cell) in
                
                cell.nameLabel.setTitle(character.name, forState: UIControlState.Normal)
                cell.nameLabel.sizeToFit()
                cell.bannerImage.image = nil
                
                guard let url = character.thumbnail?.url(), let nsurl = NSURL(string: url), let modified = character.modified else { return }
                ImageSource.downloadImageAndSetIn(cell.bannerImage, imageURL: nsurl, withUniqueKey: modified)
            }
            .addDisposableTo(disposeBag)
        
        chs.rx_characters
            .flatMapLatest(errorValidation)
            .drive(dataSource)
            .addDisposableTo(disposeBag)
        
        Observable.of(0,1,2,3)
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

