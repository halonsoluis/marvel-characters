//
//  CharacterCrossLargeCells.swift
//  Marvel Characters
//
//  Created by Hugo on 5/31/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Result

class CharacterCrossLargeCells: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var dataSource : Variable<[CrossReference]>!
    let disposeBag = DisposeBag()
    
    /// Value of current page
    weak var currentPage : Variable<Int>!
    
    var totalItems : Int!
    var chs : NetworkService!
    var rx_crossreference: Driver<Result<[CrossReference],RequestError>>!
    
    let errorValidation = { (result: Result<[CrossReference],RequestError>) -> Driver<[CrossReference]> in
        switch result {
        case .Success(let item):
            return Driver.just(item)
        case .Failure(_):
            return Driver.empty()
        }
    }
    
    
    var currentCoverIndex = 0
    var loadingMore = false
    var readyToLoadMore = true
    
    @IBAction func closeButtonTapped(sender: AnyObject) {
        //   navigationController?.popViewControllerAnimated(true)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //  self.collectionView.dataSource = self
        appendSubscribers()
        setupPagination()
        
        collectionView.rx_dataSource.setForwardToDelegate(self, retainDelegate: false)
        collectionView.rx_dataSource.forwardToDelegate()
        
        collectionView.reloadData()
        /*
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 200, height: 50)
        collectionView.collectionViewLayout = layout
        */
        /*
         
         let layout = UICollectionViewFlowLayout()
         
         let screenSize = UIScreen.mainScreen().bounds
         let screenRatio = screenSize.width / screenSize.height
         
         layout.itemSize.width = self.collectionView.bounds.width - 80
         layout.itemSize.height = self.collectionView.scrobounds.height - 60
         
         /* layout.minimumInteritemSpacing = 20*/
         layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
         
         collectionView.collectionViewLayout = layout*/
        //
        //
        //collectionView.delegate = self
        
        collectionView.rx_contentOffset
            .asDriver()
            .throttle(0.5)
            .distinctUntilChanged()
            .driveNext { offset in
                let displacement = self.collectionView.contentSize.width / CGFloat(self.dataSource.value.count)
                let value  = offset.x / displacement
             /*   let moveDown = value - floor(value)
                let moveUp = ceil(value) - value
                
                if moveUp*/
                self.scrollToPage(Int(round(value)), animated: true)
            }.addDisposableTo(disposeBag)
        
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollToPage(currentCoverIndex, animated: false)
    }
    
    func scrollToPage(page: Int, animated: Bool) {
        self.collectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: page, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: animated)
    }
    
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func appendSubscribers() {
        dataSource.asDriver()
            .driveNext { _ in
                self.collectionView.reloadData()
            }.addDisposableTo(disposeBag)
        
        rx_crossreference?
            .flatMapLatest(errorValidation)
            .driveNext { (newPage) in
                if newPage.count < APIHandler.itemsPerPage { self.loadingMore = false }
                self.readyToLoadMore = true
            }
            .addDisposableTo(disposeBag)
        
    }
    
    func setupPagination() {
        
        
        
        collectionView.rx_contentOffset
            .debounce(0.1, scheduler: MainScheduler.instance)
            //  .throttle(0.05, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter { [weak self] (offset)  in
                guard let `self` = self else {return false }
                
                guard
                    self.readyToLoadMore &&
                        offset.x > UIScreen.mainScreen().bounds.width
                    else {return false}
                self.readyToLoadMore = false
                return true
            }
            .observeOn(MainScheduler.instance)
            .bindNext { [weak self] (offset) in
                guard let `self` = self else { return }
                
                print("offset = \(offset)")
                let bounds = self.collectionView.bounds
                let size = self.collectionView.contentSize
                let inset = self.collectionView.contentInset
                let x = offset.x + bounds.size.width - inset.right
                let w = size.width
                let reload_distance : CGFloat = UIScreen.mainScreen().bounds.width * 2
                if x > (w - reload_distance) {
                    self.loadingMore = true
                    
                    self.currentPage.value = self.currentPage.value + 1
                    print("load page = \(self.currentPage.value)")
                } else {
                    self.readyToLoadMore = true
                }
                
                let displacement = self.collectionView.contentSize.width / CGFloat(self.dataSource.value.count)
                let value  = self.collectionView.contentOffset.x / displacement
                self.scrollToPage(Int(round(value)), animated: true)
                
            }
            .addDisposableTo(disposeBag)
    }
    
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier("RelatedPublicationLargeCell", forIndexPath: indexPath) as? RelatedPublicationLargeCell
            else  { return UICollectionViewCell()}
        
        let crossReference = dataSource.value[indexPath.row]
        
        if let nameLabel = cell.nameLabel {
            nameLabel.text = crossReference.title
        }
        
        if let totalLabel = cell.total {
            totalLabel.text = "\(indexPath.row + 1)/\(totalItems)"
        }
        
        if let image = cell.image {
            cell.image.image = nil
            guard let url = crossReference.thumbnail?.url(), let nsurl = NSURL(string: url), let modified = crossReference.modified else { return cell}
            ImageSource.downloadImageAndSetIn(image, imageURL: nsurl, withUniqueKey: modified)
        }
        return cell
    }
    
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.value.count
    }
    
}