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
                    self.loadingMore = false
                    return false
                }
                return true
            }
            .distinctUntilChanged()
            .doOnNext { (_) in
                self.dataSource.value.removeAll()
                self.currentPage.value = 0
                self.footerView.hidden = false
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
        
        loadingMore = false
       
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}