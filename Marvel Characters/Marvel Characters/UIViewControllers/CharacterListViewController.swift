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
    
    var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let chs = CharacterService()
        
        let errorValidation = { (result: Result<[Character],RequestError>) -> Driver<[Character]> in
            switch result {
            case .Success(let character):
                return Driver.just(character)
            case .Failure(_):
                return Driver.empty()
            }
        }
        let charactersForCurrentPage = chs.getCharacters(currentPage)
        
        charactersForCurrentPage
            .flatMapLatest(errorValidation)
            .drive(tableView.rx_itemsWithCellIdentifier("CharacterCell", cellType: CharacterCell.self)) { (_, character, cell) in
                
                cell.nameLabel.setTitle(character.name, forState: UIControlState.Normal)
                cell.nameLabel.sizeToFit()
                cell.bannerImage.image = nil
                
                guard let url = character.thumbnail?.url(), let nsurl = NSURL(string: url), let modified = character.modified else { return }
                ImageSource.downloadImageAndSetIn(cell.bannerImage, imageURL: nsurl, withUniqueKey: modified)
            }
            .addDisposableTo(disposeBag)
        
        charactersForCurrentPage
            .flatMapLatest(errorValidation)
            .drive(dataSource)
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

