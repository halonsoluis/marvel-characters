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
            .distinctUntilChanged()
            .filter {
                if $0.isEmpty {
                    self.dataSource.value.removeAll()
                    self.loadingMore = false
                    return false
                }
                return true
            }
            .doOnNext { (_) in
                self.dataSource.value.removeAll()
                self.currentPage.value = 0
                self.footerView.hidden = false
        }
    }
    
    override func createCharacterService() {
        chs = NetworkService(withNameObservable: rx_characterName, pageObservable: currentPageObservable)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                
                var frame = strongSelf.view.frame
                
                UIView.animateWithDuration(0.5, delay: 0.2, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                    strongSelf.tableView.contentInset = contentInsets
                    strongSelf.tableView.scrollIndicatorInsets = contentInsets
                    
                    frame.size.height -= keyboardFrame.height
                    strongSelf.view.frame = frame
                }, completion: nil)
                
            }
            .addDisposableTo(disposeBag)
        
        NSNotificationCenter.defaultCenter()
            .rx_notification(UIKeyboardWillHideNotification, object: nil)
            .observeOn(MainScheduler.instance)
            .subscribeNext { [weak self] notification in
                
                guard let info = notification.userInfo else { return }
                guard let strongSelf = self else { return }
                
                let tableViewInset = strongSelf.tableView.contentInset
                let contentInsets = UIEdgeInsetsMake(tableViewInset.top, 0.0, 0, 0.0);
                
                var frame = strongSelf.view.frame
                
                UIView.animateWithDuration(0.5, delay: 0.2, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                    strongSelf.tableView.contentInset = contentInsets
                    strongSelf.tableView.scrollIndicatorInsets = contentInsets
                    
                    frame.size.height = UIScreen.mainScreen().bounds.height
                    strongSelf.view.frame = frame
                    }, completion: nil)
                
            }
            .addDisposableTo(disposeBag)
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}