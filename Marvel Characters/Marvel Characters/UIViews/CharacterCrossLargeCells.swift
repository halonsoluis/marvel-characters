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

class CharacterCrossLargeCells: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!

    weak var dataSource: BehaviorRelay<[CrossReference]>!
    let disposeBag = DisposeBag()

    /// Value of current page
    weak var currentPage: BehaviorRelay<Int>!

    var totalItems: Int = 0
    var chs: NetworkService!
    var rxCrossreference: Driver<Result<[CrossReference], RequestError>>!

    let errorValidation = { (result: Result<[CrossReference], RequestError>) -> Driver<[CrossReference]> in
        switch result {
        case .success(let item):
            return Driver.just(item)
        case .failure:
            return Driver.empty()
        }
    }

    var currentCoverIndex = 0
    var loadingMore = false
    var readyToLoadMore = true

    @IBAction func closeButtonTapped(_ sender: AnyObject) {
        //   navigationController?.popViewControllerAnimated(true)
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //  self.collectionView.dataSource = self
        appendSubscribers()
        setupPagination()

        _ = collectionView.rx.dataSource.setForwardToDelegate(self, retainDelegate: false)
        _ = collectionView.rx.dataSource.forwardToDelegate()

        collectionView.reloadData()

        collectionView.rx.contentOffset
            .asDriver()
            .throttle(.milliseconds(500))
            .distinctUntilChanged()
            .drive(onNext: { offset in
                var displacement = self.collectionView.contentSize.width / CGFloat(self.dataSource.value.count)
                displacement = displacement == 0 ? 1 : displacement
                let value  = offset.x / displacement
                self.scrollToPage(Int(round(value)), animated: true)
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)

    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let layout = UICollectionViewFlowLayout()

        layout.itemSize.width = self.collectionView.bounds.width
        layout.itemSize.height =  self.collectionView.bounds.height

        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
           collectionView.collectionViewLayout = layout
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollToPage(currentCoverIndex, animated: false)
    }

    func scrollToPage(_ page: Int, animated: Bool) {
        self.collectionView.scrollToItem(at: IndexPath(row: page, section: 0),
                                         at: UICollectionView.ScrollPosition.centeredHorizontally,
                                         animated: animated)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func appendSubscribers() {
        dataSource.asDriver()
            .drive(onNext: { _ in
                self.collectionView.reloadData()
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)

        rxCrossreference?
            .flatMapLatest(errorValidation)
            .drive(onNext: { (newPage) in
                if newPage.count < APIHandler.itemsPerPage { self.loadingMore = false }
                self.readyToLoadMore = true
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)

    }

    func setupPagination() {

        collectionView.rx.contentOffset
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
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
            .bind { [weak self] (offset) in
                guard let `self` = self else { return }

                print("offset = \(offset)")
                let bounds = self.collectionView.bounds
                let size = self.collectionView.contentSize
                let inset = self.collectionView.contentInset
                let x = offset.x + bounds.size.width - inset.right
                let reloadDistance: CGFloat = UIScreen.main.bounds.width * 2
                if x > (size.width - reloadDistance) {
                    self.loadingMore = true

                    self.currentPage.accept(self.currentPage.value + 1)
                    print("load page = \(self.currentPage.value)")
                } else {
                    self.readyToLoadMore = true
                }

                let displacement = self.collectionView.contentSize.width / CGFloat(self.dataSource.value.count)
                let value  = self.collectionView.contentOffset.x / displacement
                self.scrollToPage(Int(round(value)), animated: true)
            }
            .disposed(by: disposeBag)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "RelatedPublicationLargeCell",
            for: indexPath) as? RelatedPublicationLargeCell else { return UICollectionViewCell()}

        let crossReference = dataSource.value[indexPath.row]

        if let nameLabel = cell.nameLabel {
            nameLabel.text = crossReference.title
        }

        if let totalLabel = cell.total {
            totalLabel.text = "\(indexPath.row + 1)/\(totalItems)"
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

}
