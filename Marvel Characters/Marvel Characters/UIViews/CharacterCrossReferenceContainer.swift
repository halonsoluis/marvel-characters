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
import Result



class CharacterCrossReferenceContainer: GenericBlockCharacterDetail, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataSource = Variable<[CrossReference]>([])
    var route: Routes!
    var total: Int!
    var crossReferencNetworService: NetworkService!
    let disposeBag = DisposeBag()
    
    /// Value of current page
    var currentPage = Variable<Int>(0)
   
    var chs : NetworkService!
    var rx_crossreference: Driver<Result<[CrossReference],RequestError>>!
    
    let errorValidation = { (result: Result<[CrossReference],RequestError>) -> Driver<[CrossReference]> in
        switch result {
        case .success(let item):
            return Driver.just(item)
        case .failure(_):
            return Driver.empty()
        }
    }
    
    var loadingMore = false
    var readyToLoadMore = true
    
    var currentPageObservable : Observable<Int>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  self.collectionView.dataSource = self
       
        currentPageObservable = currentPage
            .asObservable()
            .distinctUntilChanged()
            .filter { $0 >= 0 }
        
        
        createCharacterService()
        
        rx_crossreference = chs.getData(route)
        appendSubscribers()
        setupPagination()
        
        
        collectionView.rx.dataSource.setForwardToDelegate(self, retainDelegate: false)
        collectionView.rx.dataSource.forwardToDelegate()
        
        collectionView.reloadData()
    }
    
    func createCharacterService() {
        chs = NetworkService(pageObservable: currentPageObservable)
    }
    
    func appendSubscribers() {
//        dataSource.asDriver()
//            .drive(collectionView.rx_itemsWithCellIdentifier("RelatedPublicationCell", cellType: RelatedPublicationCell.self)) { (_, crossReference, cell) in
//                
//                if let nameLabel = cell.nameLabel {
//                    nameLabel.text = crossReference.title
//                }
//                
//                if let image = cell.image {
//                    guard let url = crossReference.resourceURI, let nsurl = NSURL(string: url), let modified = crossReference.modified else { return }
//                    ImageSource.downloadImageAndSetIn(image, imageURL: nsurl, withUniqueKey: modified)
//                    
//                }
//                return
//            }
//            .addDisposableTo(disposeBag)
        
        dataSource.asDriver()
            .drive(onNext: { _ in
                self.collectionView.reloadData()
            }, onCompleted: nil, onDisposed: nil)
        .addDisposableTo(disposeBag)
        
        rx_crossreference?
            .flatMapLatest(errorValidation)
            .drive(onNext: { (newPage) in
                self.dataSource.value.append(contentsOf: newPage)
                if newPage.count < APIHandler.itemsPerPage { self.loadingMore = false }
                self.readyToLoadMore = true
            }, onCompleted: nil, onDisposed: nil)
           .addDisposableTo(disposeBag)
        
    }
    
    func setupPagination() {
        
        collectionView.rx.contentOffset
            .debounce(0.1, scheduler: MainScheduler.instance)
            //  .throttle(0.05, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter { [weak self] (offset)  in
                guard let `self` = self else {return false }
                
                guard
                    self.readyToLoadMore &&
                        offset.x > UIScreen.main.bounds.width
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
                let reload_distance : CGFloat = UIScreen.main.bounds.width * 2
                if x > (w - reload_distance) {
                    self.loadingMore = true
                    
                    self.currentPage.value = self.currentPage.value + 1
                    print("load page = \(self.currentPage.value)")
                } else {
                    self.readyToLoadMore = true
                }
            }
            .addDisposableTo(disposeBag)
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RelatedPublicationCell", for: indexPath) as? RelatedPublicationCell
        else  { return UICollectionViewCell()}
       
        let crossReference = dataSource.value[indexPath.row]
       
        if let nameLabel = cell.nameLabel {
            nameLabel.text = crossReference.title
        }
        
        if let image = cell.image {
            cell.image.image = nil
            guard let url = crossReference.thumbnail?.url(), let nsurl = URL(string: url), let modified = crossReference.modified else { return cell}
            ImageSource.downloadImageAndSetIn(image, imageURL: nsurl, withUniqueKey: modified)
        }
        return cell
    }



    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected \(indexPath.row)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let largeImages = segue.destination as? CharacterCrossLargeCells {
            largeImages.rx_crossreference = self.rx_crossreference
            largeImages.dataSource = self.dataSource
            largeImages.currentPage = currentPage
            largeImages.totalItems = total
            largeImages.currentCoverIndex = self.collectionView.indexPathsForSelectedItems![0].row
        }
    }
    
}
