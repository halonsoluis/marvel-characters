//
//  SearchViewController.swift
//  Marvel Characters
//
//  Created by Hugo Alonso on 5/27/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Result

class SearchViewController: CharacterListViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var rx_characterName: Observable<String> {
        return searchBar
            .rx_text
            .throttle(0.5, scheduler: MainScheduler.instance)
            .filter {
                if $0.isEmpty {
                    self.dataSource.value.removeAll()
                    return false
                }
                return true
            }
            .distinctUntilChanged()
            .doOnNext { (_) in
                
                self.dataSource.value.removeAll()
                self.currentPage.value = 0
        }
    }
    
    override func createCharacterService() {
        chs = CharacterService(withNameObservable: rx_characterName, pageObservable: currentPageObservable)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        searchBar.becomeFirstResponder()
        
        searchBar
            .rx_cancelButtonClicked
            .asDriver()
            .driveNext { [weak self] (_) in
                self?.navigationController?.popViewControllerAnimated(true)
            }.addDisposableTo(disposeBag)
        /*
         searchBar
         .rx_searchButtonClicked
         .asDriver()
         .driveNext { [weak self] (_) in
         self?.searchBar.endEditing(true)
         }.addDisposableTo(disposeBag)*/
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}