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
    @IBOutlet weak var footerView: UIView!
    
    
    let disposeBag = DisposeBag()
    
    let dataSource = Variable<[MarvelCharacter]>([])
    
    /// Value of current page
    var currentPage = Variable<Int>(0)
    
    var chs : NetworkService?
    var rx_characters: Driver<Result<[MarvelCharacter],RequestError>>?
    

    let errorValidation = { (result: Result<[MarvelCharacter],RequestError>) -> Driver<[MarvelCharacter]> in
        switch result {
        case .Success(let character):
            return Driver.just(character)
        case .Failure(_):
            return Driver.empty()
        }
    }
    var loadingMore = false {
        didSet {
            footerView.hidden = !loadingMore
        }
    }
    var readyToLoadMore = true
    
    var currentPageObservable : Observable<Int>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentPageObservable = currentPage
            .asObservable()
            .distinctUntilChanged()
            .filter { $0 >= 0 }
        
        createCharacterService()
        rx_characters = chs?.getData(Routes.ListCharacters)
        appendSubscribers()
        setupPagination()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.backgroundColor = UIColor.blackColor()
        navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: UIBarMetrics.Default)
        navigationController?.navigationBar.shadowImage = nil
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        navigationController?.delegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let nav = navigationController?.delegate as? CharacterListViewController where nav == self {
            navigationController?.delegate = nil
        }
    }
    
    func createCharacterService() {
        chs = NetworkService(pageObservable: currentPageObservable)
    }
    
    func setupPagination() {
        
        tableView.rx_contentOffset
            .debounce(0.1, scheduler: MainScheduler.instance)
            //  .throttle(0.05, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter { [weak self] (offset)  in
                guard let `self` = self else {return false }
                
                guard
                    self.readyToLoadMore &&
                        offset.y > UIScreen.mainScreen().bounds.height
                    else {return false}
                self.readyToLoadMore = false
                return true
            }
            .observeOn(MainScheduler.instance)
            .bindNext { [weak self] (offset) in
                guard let `self` = self else { return }
                
                print("offset = \(offset)")
                let bounds = self.tableView.bounds
                let size = self.tableView.contentSize
                let inset = self.tableView.contentInset
                let y = offset.y + bounds.size.height - inset.bottom
                let h = size.height
                let reload_distance : CGFloat = UIScreen.mainScreen().bounds.height * 2
                if y > (h - reload_distance) {
                    self.loadingMore = true
                    
                    self.currentPage.value = self.currentPage.value + 1
                    print("load page = \(self.currentPage.value)")
                } else {
                    self.readyToLoadMore = true
                }
            }
            .addDisposableTo(disposeBag)
    }
    
    func appendSubscribers() {
        dataSource.asDriver()
            .drive(tableView.rx_itemsWithCellIdentifier("CharacterCell", cellType: CharacterCell.self)) { (_, character, cell) in
                
                if let nameLabel = cell.nameLabel as? UIButton {
                    nameLabel.setTitle(character.name, forState: UIControlState.Normal)
                } else if let nameLabel = cell.nameLabel as? UILabel {
                    nameLabel.text = character.name
                }
                
                cell.nameLabel.sizeToFit()
                cell.bannerImage.image = nil
                
                cell.setEditing(false, animated: false)
                
                
                guard let url = character.thumbnail?.url(), let nsurl = NSURL(string: url), let modified = character.modified else { return }
                ImageSource.downloadImageAndSetIn(cell.bannerImage, imageURL: nsurl, withUniqueKey: modified)
            }
            .addDisposableTo(disposeBag)
        
        rx_characters?
            .flatMapLatest(errorValidation)
            .driveNext { (newPage) in
                self.dataSource.value.appendContentsOf(newPage)
                if newPage.count < APIHandler.itemsPerPage { self.loadingMore = false }
                self.readyToLoadMore = true
            }
            .addDisposableTo(disposeBag)
        
    }
    
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        
        
        if let characterDetails = segue.destinationViewController as? CharacterProviderDelegate {
            
            guard
                let indexPath = tableView.indexPathForSelectedRow,
                let cell = tableView.cellForRowAtIndexPath(indexPath) as? CharacterCell
                else { return }
            
            let character = dataSource.value[indexPath.row]
            
            characterDetails.character = character
            characterDetails.characterImage = cell.bannerImage?.image
        }
        
        
    }
}

extension CharacterListViewController: UINavigationControllerDelegate {
  
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if self == fromVC && toVC is BlurredImageContainerViewController {
            return RepositionImageZoomingTransition()
        }
       return nil
    }
}

extension CharacterListViewController: RepositionImageZoomingTransitionProtocol {
    
    func getImageView() -> UIImageView? {
        guard
            let indexPath = tableView.indexPathForSelectedRow,
            let cell = tableView.cellForRowAtIndexPath(indexPath) as? CharacterCell
        else { return nil }
        return cell.bannerImage
    }
    
    func doBeforeTransition() {
        
        getCell()?.hidden = true
        navigationController?.navigationBar.alpha = 0
        
    }
    
    func getEnclosingView() -> UIView {
        return getCell()!
    }
    
    private func getCell() -> UITableViewCell? {
        guard
            let indexPath = tableView.indexPathForSelectedRow,
            let cell = tableView.cellForRowAtIndexPath(indexPath) as? CharacterCell
            else { return nil}
        return cell
    }
    
    func doAfterTransition(){
        view.alpha = 1
        getCell()?.hidden = false
        navigationController?.navigationBar.alpha = 1
        
    }
    
    func doWhileTransitioningStepOne() {
        view.alpha = 0
        
    }
    func doWhileTransitioningStepTwo(){
        
    }
    func doWhileTransitioningStepThree(){
        navigationController?.navigationBar.alpha = 1
    }
    
    func getViewOfController() -> UIView {
        return self.view
    }
    func getViewController() -> UIViewController {
        return self
    }
    
}