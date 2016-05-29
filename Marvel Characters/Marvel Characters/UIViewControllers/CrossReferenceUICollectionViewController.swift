//
//  RelatedSeriesUICollectionViewController.swift
//  Marvel Characters
//
//  Created by Hugo Alonso on 5/29/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//
import UIKit

import RxSwift
import RxCocoa

protocol CrossReferencePresenterProtocol : class {
    var elements: [CrossReferenceItem]? { get set }
}

class CrossReferenceUICollectionViewController: UICollectionViewController, CrossReferencePresenterProtocol {
    
    var dataSource = Variable<[CrossReferenceItem]>([])
    var disposeBag = DisposeBag()
    
    var elements: [CrossReferenceItem]? = [] {
        didSet {
            dataSource.value = elements != nil ? elements! : []
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.asDriver()
            .drive(self.collectionView!.rx_itemsWithCellIdentifier("relatedPublicationCell", cellType: RelatedPublicationCell.self)) { (_, crossReference, cell) in
                
                if let nameLabel = cell.nameLabel {
                    nameLabel.text = crossReference.name
                }
                
                if let image = cell.image {
                    guard let url = crossReference.resourceURI, let nsurl = NSURL(string: url)/*, let modified = character.modified*/ else { return }
                    ImageSource.downloadImageAndSetIn(image, imageURL: nsurl, withUniqueKey: "")
                    
                }
                
            }
            .addDisposableTo(disposeBag)
        /*
        self.collectionView!.rx_itemSelected
            .asDriver()
            .map { self.elements?[$0.row].image }
            .driveNext {link in
                guard let url = link, let nsurl = NSURL(string: url) else { return }
                UIApplication.sharedApplication().openURL(nsurl)
                
            }.addDisposableTo(disposeBag)
        */
    }
    /*
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        return []
    }*/
}