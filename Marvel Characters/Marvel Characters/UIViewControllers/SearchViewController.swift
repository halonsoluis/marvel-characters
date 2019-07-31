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

class SearchViewController: CharacterListViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    func buildCharacterNameObservable() -> Observable<String> {
        return searchBar.rx.text.orEmpty
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMap{ text -> Observable<String> in
                
                if text.isEmpty{
                    return .just("")
                }
                
                return .just(text)
            }.filter {
                if $0.isEmpty {
                    self.dataSource.accept([])
                    self.loadingMore = false
                    return false
                }
                return true
            }.do(onNext: { (_) in
                self.dataSource.accept([])
                self.currentPage.accept(0)
                self.footerView.isHidden = false
            }, onError: nil, onCompleted: nil, onSubscribe: nil, onDispose: nil)
    }
    
    override func createCharacterService() {
        chs = NetworkService(withNameObservable: buildCharacterNameObservable(), pageObservable: currentPageObservable)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayoutForKeyboard()
        searchBar.becomeFirstResponder()
        
        searchBar
            .rx.cancelButtonClicked
            .asDriver()
            .drive(onNext: { [weak self] (_) in
                _ = self?.navigationController?.popViewController(animated: true)
                }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        loadingMore = false
        
        tableView.accessibilityIdentifier = "SearchCharacterList"
   
    }
    
    fileprivate func setLayoutForKeyboard() {
        
        NotificationCenter.default
            .rx.notification(UIResponder.keyboardWillShowNotification, object: nil)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] notification in
                
                guard let info = notification.userInfo else { return }
                guard let strongSelf = self else { return }
                
                let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
                let tableViewInset = strongSelf.tableView.contentInset
                let contentInsets = UIEdgeInsets.init(top: tableViewInset.top, left: 0.0, bottom: keyboardFrame.height, right: 0.0);
                
                var frame = strongSelf.view.frame
                
                UIView.animate(withDuration: 0.5, delay: 0.2, options: UIView.AnimationOptions.curveEaseIn, animations: {
                    strongSelf.tableView.contentInset = contentInsets
                    strongSelf.tableView.scrollIndicatorInsets = contentInsets
                    
                    frame.size.height -= keyboardFrame.height
                    strongSelf.view.frame = frame
                }, completion: nil)
                
                }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        
        NotificationCenter.default
            .rx.notification(UIResponder.keyboardWillHideNotification, object: nil)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] notification in
                
                guard let strongSelf = self else { return }
                
                let tableViewInset = strongSelf.tableView.contentInset
                let contentInsets = UIEdgeInsets.init(top: tableViewInset.top, left: 0.0, bottom: 0, right: 0.0);
                
                var frame = strongSelf.view.frame
                
                UIView.animate(withDuration: 0.5, delay: 0.2, options: UIView.AnimationOptions.curveEaseIn, animations: {
                    strongSelf.tableView.contentInset = contentInsets
                    strongSelf.tableView.scrollIndicatorInsets = contentInsets
                    
                    frame.size.height = UIScreen.main.bounds.height
                    strongSelf.view.frame = frame
                }, completion: nil)
                
                }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
    }
    
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}
