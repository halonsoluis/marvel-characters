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
    
    @IBOutlet weak var nameContainer: UIView!
    @IBOutlet weak var descriptionContainer: UIView!
    @IBOutlet weak var comicsContainer: UIView!
    @IBOutlet weak var seriesContainer: UIView!
    @IBOutlet weak var storiesContainer: UIView!
    @IBOutlet weak var eventsContainer: UIView!
    @IBOutlet weak var linksContainer: UIView!
    
    
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
        
        let height = fillData()
     //   parentViewHeight.constant = largeImage.bounds.height + height
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier else { return }
        
        if let detail = segue.destinationViewController as? CharacterDetailContainer {
            
            switch identifier {
            case "name":
                detail.text = delegate?.character?.name
                detail.nameForSection = "NAME"
            case "description":
                detail.text = delegate?.character?.description
                detail.nameForSection = "DESCRIPTION"
            default: break
            }
            return
        }
        
        
        if let relatedLinks = segue.destinationViewController as? CharacterRelatedLinksContainer where identifier == "links" {
            relatedLinks.nameForSection = "RELATED LINKS" ;
            relatedLinks.characterLinks = delegate?.character?.urls
            return
        }
        
        
        guard let related = segue.destinationViewController as? CharacterCrossReferenceContainer else { return }
        
        
        switch identifier {
        case "comics":   related.nameForSection = "COMICS" ; related.elements = delegate?.character?.comics?.items
        case "series":  related.nameForSection = "SERIES" ; related.elements = delegate?.character?.series?.items
        case "stories":  related.nameForSection = "STORIES" ; related.elements = delegate?.character?.stories?.items
        case "events":  related.nameForSection = "EVENTS" ; related.elements = delegate?.character?.events?.items
        default: break
        }
    }
    
    func fillData() -> CGFloat {
        
        guard let character = delegate?.character else { return 0 }
        
        self.largeImage.image = delegate?.characterImage
        var height = largeImage.bounds.height
        if let items = character.name where items.isEmpty { nameContainer.removeFromSuperview() } else { height += 120}
        if let items = character.description where items.isEmpty { descriptionContainer.removeFromSuperview() } else { height += 180}
        
        if let items = character.comics?.items where items.isEmpty { comicsContainer.removeFromSuperview() } else { height += 280}
        if let items = character.series?.items where items.isEmpty { seriesContainer.removeFromSuperview() } else { height += 280}
        if let items = character.events?.items where items.isEmpty { eventsContainer.removeFromSuperview() } else { height += 280}
        if let items = character.stories?.items where items.isEmpty { storiesContainer.removeFromSuperview() } else { height += 280}
        
        if let items = character.urls where items.isEmpty { linksContainer.removeFromSuperview() } else { height += 230}
       
        return height
    }
    //
    //    func fillData() {
    //        guard let character = delegate?.character else { return }
    //
    //        self.largeImage.image = delegate?.characterImage
    //
    //        parentView.translatesAutoresizingMaskIntoConstraints = false
    //
    //        let _ = [
    //            createContainer("NAME", data: character.name,type: .Text),
    //            createContainer("DESCRIPTION", data: character.description,type: .Text),
    //
    //            createContainer("COMICS", data: character.comics?.items,type: .CrossReference),
    //            createContainer("SERIES", data: character.series?.items,type: .CrossReference),
    //            createContainer("STORIES", data: character.stories?.items,type: .CrossReference),
    //            createContainer("EVENTS", data: character.events?.items,type: .CrossReference),
    //
    //            createContainer("RELATED LINKS",data: character.urls,type: .Link)
    //            ]
    //            .flatMap { $0 }
    //            .reduce(largeImage) { (lastView, container) -> UIView in
    //                layoutContainer(container.0, containerType: container.1, below: lastView, onParent: self.parentView)
    //                return container.0
    //        }
    //        parentView.setNeedsUpdateConstraints()
    //        parentView.setNeedsLayout()
    //        print(parentViewHeight.constant)
    //    }
    //
    ////    enum ItemContainer: CGFloat {
    ////        case Text = 150
    ////        case CrossReference = 350
    ////        case Link =  250
    ////    }
    ////
    ////    func layoutContainer(containerView: UIView? , containerType: ItemContainer, below lastAddedView: UIView, onParent parent: UIView) {
    ////        guard let view = containerView else { return }
    ////
    ////        parent.addSubview(view)
    ////        parent.bringSubviewToFront(view)
    ////        view.translatesAutoresizingMaskIntoConstraints = false
    ////
    ////
    ////        self.view.addConstraints([
    ////            NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: lastAddedView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0),
    ////
    ////            NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: parent, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0),
    ////
    ////            NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: parent, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0),
    ////
    ////            NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: containerType.rawValue)
    ////            ])
    ////
    ////
    ////        parentViewHeight.constant = parentViewHeight.constant + containerType.rawValue
    ////        view.setNeedsDisplay()
    ////
    ////    }
    ////
    ////    func createContainer(sectionName: String, data: AnyObject?, type: ItemContainer) -> (UIView, ItemContainer)? {
    ////        guard let data = data else { return nil }
    ////        let view : UIView
    ////        switch type {
    ////        case .Text:
    ////            guard let data = data as? String where !data.isEmpty else { return nil }
    ////
    ////            guard let container = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CharacterDetailContainer") as? CharacterDetailContainer else { return nil }
    ////
    ////            container.text = data
    ////            container.nameForSection = sectionName
    ////            view = container.view
    ////        case .CrossReference:
    ////
    ////            guard let data = data as? [CrossReferenceItem] where !data.isEmpty else { return nil }
    ////
    ////            guard let container = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CharacterCrossReferenceContainer") as? CharacterCrossReferenceContainer else { return nil}
    ////
    ////            container.elements = data
    ////            container.nameForSection = sectionName
    ////            view = container.view
    ////        case .Link:
    ////            guard let data = data as? [LinkURL] where !data.isEmpty else { return nil }
    ////
    ////            guard let container = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CharacterRelatedLinksContainer") as? CharacterRelatedLinksContainer else { return nil}
    ////
    ////            container.characterLinks = data
    ////            container.nameForSection = sectionName
    ////            view = container.view
    ////        }
    ////
    ////
    ////        return (view, type)
    ////    }
}