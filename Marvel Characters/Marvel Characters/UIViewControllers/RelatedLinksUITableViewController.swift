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
    
    var dataSource = BehaviorRelay<[LinkURL]>(value: [])
    var disposeBag = DisposeBag()
    
    var characterLinks: [LinkURL]? = [] {
        didSet {
            dataSource.accept(characterLinks != nil ? characterLinks! : [])
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.asDriver()
            .drive(self.tableView.rx.items(cellIdentifier:"relatedLinksCell", cellType: RelatedLinksCell.self)) { (_, link, cell) in
                
                if let nameLabel = cell.nameLabel {
                    nameLabel.text = link.type.capitalized
                }
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .asDriver()
            .map { self.characterLinks?[$0.row].url }
            .drive(onNext: {link in
                guard let url = link, let nsurl = NSURL(string: url) as URL? else { return }
                UIApplication.shared.open(nsurl, options: [:], completionHandler: nil)
            }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return []
    }
}
