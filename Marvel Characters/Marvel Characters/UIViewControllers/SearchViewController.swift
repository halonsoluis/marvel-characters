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
        setLayoutForKeyboard()
        searchBar.becomeFirstResponder()
        
        searchBar
            .rx_cancelButtonClicked
            .asDriver()
            .driveNext { [weak self] (_) in
                self?.navigationController?.popViewControllerAnimated(true)
            }.addDisposableTo(disposeBag)
        
        loadingMore = false
        
    }
    
    private func setLayoutForKeyboard() {
        
        NSNotificationCenter.defaultCenter()
            .rx_notification(UIKeyboardWillShowNotification, object: nil)
            .observeOn(MainScheduler.instance)
            .subscribeNext { [weak self] notification in
                
                guard let info = notification.userInfo else { return }
                guard let strongSelf = self else { return }
                
                let keyboardFrame: CGRect = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
                let tableViewInset = strongSelf.tableView.contentInset
                let contentInsets = UIEdgeInsetsMake(tableViewInset.top, 0.0, keyboardFrame.height, 0.0);
                strongSelf.tableView.contentInset = contentInsets
                strongSelf.tableView.scrollIndicatorInsets = contentInsets
                
                var frame = strongSelf.view.frame
                frame.size.height -= keyboardFrame.height
                strongSelf.view.frame = frame
            }
            .addDisposableTo(disposeBag)
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}