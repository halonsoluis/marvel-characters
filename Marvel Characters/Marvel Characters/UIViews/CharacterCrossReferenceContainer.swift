//
//  CharacteCrossReferenceContainer.swift
//  Marvel Characters
//
//  Created by Hugo Alonso on 5/29/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

protocol CrossReferencePresenterProtocol : class {
    var elements: [CrossReferenceItem]? { get set }
}

class CharacterCrossReferenceContainer: GenericBlockCharacterDetail, CrossReferencePresenterProtocol, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var elements: [CrossReferenceItem]? = []
    var dataSource = Variable<[CrossReferenceItem]>([])
    
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.dataSource = self
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return elements?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("selected \(indexPath.row)")
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier("RelatedPublicationCell", forIndexPath: indexPath) as? RelatedPublicationCell,
            let crossReference = elements?[indexPath.row]
            else
        {
            return UICollectionViewCell()
        }
        
        if let nameLabel = cell.nameLabel {
            nameLabel.text = crossReference.name
        }
        
        if let image = cell.image {
            guard let url = crossReference.resourceURI, let nsurl = NSURL(string: url)/*, let modified = character.modified*/ else { return cell}
            ImageSource.downloadImageAndSetIn(image, imageURL: nsurl, withUniqueKey: "")
            
        }
        return cell
    }
}