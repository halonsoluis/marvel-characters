//
//  RelatedLinksUITableViewController.swift
//  Marvel Characters
//
//  Created by Hugo Alonso on 5/29/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

protocol LinksPresenterProtocol : class {
    var characterLinks: [LinkURL]? { get set }
}

class RelatedLinksUITableViewController: UITableViewController, LinksPresenterProtocol {
    
    var dataSource = Variable<[LinkURL]>([])
    var disposeBag = DisposeBag()
    
    var characterLinks: [LinkURL]? = [] {
        didSet {
            dataSource.value = characterLinks != nil ? characterLinks! : []
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.asDriver()
            .drive(self.tableView.rx_itemsWithCellIdentifier("relatedLinksCell", cellType: RelatedLinksCell.self)) { (_, link, cell) in
                
                if let nameLabel = cell.nameLabel {
                    nameLabel.text = link.type.capitalizedString
                }
            }
            .addDisposableTo(disposeBag)
        
        tableView.rx_itemSelected
            .asDriver()
            .map { self.characterLinks?[$0.row].url }
            .driveNext {link in
                guard let url = link, let nsurl = NSURL(string: url) else { return }
                UIApplication.sharedApplication().openURL(nsurl)
                
            }.addDisposableTo(disposeBag)
        
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        return []
    }
}