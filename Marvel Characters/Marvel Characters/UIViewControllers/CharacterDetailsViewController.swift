//
//  CharacterDetailsViewController.swift
//  Marvel Characters
//
//  Created by Hugo on 5/27/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CharacterDetailsViewController: UIViewController {
    
    @IBOutlet weak var largeImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var parentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var parentView: UIView!
    
    let disposeBag = DisposeBag()
    weak var delegate: CharacterProviderDelegate?
    weak var delegateBar : BlurredNavigationBarAlphaChangerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView
            .rx_contentOffset
            .map { (contentOffset) -> CGFloat in
                let offset = contentOffset.y
                let imageHeight = self.largeImage.bounds.height
                let normalisedOffset = min(max(offset, 0), imageHeight)
                let percent = normalisedOffset / imageHeight
                
                let shortenedValue = String(format: "%.2f", percent)
                return CGFloat(Float(shortenedValue)!)
            }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: 0)
            .driveNext { [weak self] (alpha) in
                self?.delegateBar?.navigationBarAlpha = alpha
            }
            .addDisposableTo(disposeBag)
        
        
        fillData()
    }
   
    func fillData() {
        guard let character = delegate?.character else { return }
        
        self.largeImage.image = delegate?.characterImage
        
        parentView.translatesAutoresizingMaskIntoConstraints = false
        
        let _ = [
            createContainer("NAME", data: character.name,type: .Text),
            createContainer("DESCRIPTION", data: character.description,type: .Text),
            
            createContainer("COMICS", data: character.comics?.items,type: .CrossReference),
            createContainer("SERIES", data: character.series?.items,type: .CrossReference),
            createContainer("STORIES", data: character.stories?.items,type: .CrossReference),
            createContainer("EVENTS", data: character.events?.items,type: .CrossReference),
            
            createContainer("RELATED LINKS",data: character.urls,type: .Link)
            ]
            .flatMap { $0 }
            .reduce(largeImage) { (lastView, container) -> UIView in
                layoutContainer(container.0, containerType: container.1, below: lastView, onParent: self.parentView)
                return container.0
        }
        parentView.setNeedsUpdateConstraints()
        print(parentViewHeight.constant)
    }
    
//    (largeImage, combine: { (lastAdded,  in {
//    retu
//    }

    
    enum ItemContainer: CGFloat {
        case Text = 250
        case CrossReference = 400
        case Link =  300
    }
    
    func layoutContainer(containerView: UIView? , containerType: ItemContainer, below lastAddedView: UIView, onParent parent: UIView) {
        guard let view = containerView else { return }
        
        parent.addSubview(view)
        //parentView.bringSubviewToFront(view)
        
        let _ = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: lastAddedView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 180).active
        
        let _ = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: lastAddedView, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0).active
        
        let _ = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: lastAddedView, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0).active
        
        let _ = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: containerType.rawValue).active
        
        
        parentViewHeight.constant = parentViewHeight.constant + containerType.rawValue
        
    }
    
    func createContainer(sectionName: String, data: AnyObject?, type: ItemContainer) -> (UIView, ItemContainer)? {
        guard let data = data else { return nil }
        let view : UIView
        switch type {
        case .Text:
            guard let data = data as? String where !data.isEmpty else { return nil }
            
            guard let container = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CharacterDetailContainer") as? CharacterDetailContainer else { return nil }
            
            container.text = data
            container.nameForSection = sectionName
            view = container.view
            
        case .CrossReference:
            
            guard let data = data as? [CrossReferenceItem] where !data.isEmpty else { return nil }
            
            guard let container = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CharacterCrossReferenceContainer") as? CharacterCrossReferenceContainer else { return nil}
            
            container.elements = data
            view = container.view
            
        case .Link:
            guard let data = data as? [LinkURL] where !data.isEmpty else { return nil }
            
            guard let container = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CharacterRelatedLinksContainer") as? CharacterRelatedLinksContainer else { return nil}
            
            container.characterLinks = data
            view = container.view
            
            
        }
        return (view, type)
    }
}