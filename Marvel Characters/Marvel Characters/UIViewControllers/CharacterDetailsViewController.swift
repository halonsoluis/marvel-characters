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
    
    @IBOutlet weak var largeImageHeight: NSLayoutConstraint!
    @IBOutlet weak var parentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var descriptionContainerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var nameContainer: UIView!
    @IBOutlet weak var descriptionContainer: UIView!
    @IBOutlet weak var comicsContainer: UIView!
    @IBOutlet weak var seriesContainer: UIView!
    @IBOutlet weak var storiesContainer: UIView!
    @IBOutlet weak var eventsContainer: UIView!
    @IBOutlet weak var linksContainer: UIView!
    
    weak var descriptionTextContainer : CharacterDetailContainer?
    
    let disposeBag = DisposeBag()
    weak var delegate: CharacterProviderDelegate?
    weak var delegateBar : BlurredNavigationBarAlphaChangerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Stretchy Code
        
        // Make sure the contentMode is set to scale proportionally
        largeImage.contentMode = UIViewContentMode.ScaleAspectFill
        // Clip the parts of the image that are not in frame
        largeImage.clipsToBounds = true
        // Set the autoresizingMask to always be the same height as the header
        largeImage.autoresizingMask = UIViewAutoresizing.FlexibleTopMargin
        
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
        
        scrollView
            .rx_contentOffset
            .asDriver()
            .filter { $0.y < 0 }
            .distinctUntilChanged()
            .driveNext { [weak self] (offset) in
                let progress:CGFloat = fabs(offset.y ) / 250
                self?.largeImage.transform = CGAffineTransformMakeScale(1 + progress, 1 + progress)
                self?.largeImage.frame.origin.y = offset.y * CGFloat(self!.factor)
                //          self?.largeImageHeight.constant = self!.largeImageHeight.constant * (1 + progress)
            }
            .addDisposableTo(disposeBag)
        
        
        
        let _ = fillData()
    }
    var factor : CGFloat = 1
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard
            let identifier = segue.identifier,
            let character = delegate?.character,
            let id = character.id
            else { return }
        
        if let detail = segue.destinationViewController as? CharacterDetailContainer {
            
            switch identifier {
            case "name":
                detail.text = character.name
                detail.nameForSection = "NAME"
            case "description":
                detail.text = character.description
                detail.nameForSection = "DESCRIPTION"
                descriptionTextContainer = detail
            default: break
            }
            return
        }
        
        
        if let relatedLinks = segue.destinationViewController as? CharacterRelatedLinksContainer where identifier == "links" {
            relatedLinks.nameForSection = "RELATED LINKS" ;
            relatedLinks.characterLinks = character.urls
            return
        }
        
        
        guard let related = segue.destinationViewController as? CharacterCrossReferenceContainer else { return }
        
        
        switch identifier {
        case "comics":
            related.nameForSection = "COMICS" ;
          //  related.elements = character.comics?.items
            related.route = Routes.ListComicsByCharacter(characterID: id)
        case "series":
            related.nameForSection = "SERIES" ;
          //  related.elements = delegate?.character?.series?.items
            related.route = Routes.ListSeriesByCharacter(characterID: id)
        case "stories":
            related.nameForSection = "STORIES" ;
          //  related.elements = delegate?.character?.stories?.items
            related.route = Routes.ListStoriesByCharacter(characterID: id)
        case "events":
            related.nameForSection = "EVENTS" ;
          //  related.elements = delegate?.character?.events?.items
            related.route = Routes.ListEventsByCharacter(characterID: id)
            
        default: break
        }
    }
    
    func fillData() -> CGFloat {
        
        guard
            let character = delegate?.character,
            let characterImage = delegate?.characterImage
            else { return 0 }
        
        self.largeImage.image = characterImage
        self.largeImage.sizeToFit()
        
        let imageSize = characterImage.size
        let widthFactor = UIScreen.mainScreen().bounds.width / imageSize.width
        let newHeight = imageSize.height * widthFactor
        largeImageHeight.constant = newHeight
        parentView.setNeedsLayout()
        
        var height = newHeight
        factor = self.largeImage.frame.height > self.largeImage.frame.width ? 2 : 1.7
        if let items = character.name where items.isEmpty { nameContainer.removeFromSuperview() } else { height += 120}
        if let items = character.description where items.isEmpty { descriptionContainer.removeFromSuperview() } else {
            
            if let descriptionText = descriptionTextContainer/*?.textDescription*/ {
                descriptionText.textDescription.sizeToFit()
                //   print("bounds = \(descriptionText.bounds)")
                descriptionContainerHeight.constant = 60 + descriptionText.textDescription.bounds.height + 100
            }
            height += 180
            
        }
        
        if let items = character.comics?.items where items.isEmpty { comicsContainer.removeFromSuperview() } else { height += 280}
        if let items = character.series?.items where items.isEmpty { seriesContainer.removeFromSuperview() } else { height += 280}
        if let items = character.events?.items where items.isEmpty { eventsContainer.removeFromSuperview() } else { height += 280}
        if let items = character.stories?.items where items.isEmpty { storiesContainer.removeFromSuperview() } else { height += 280}
        
        if let items = character.urls where items.isEmpty { linksContainer.removeFromSuperview() } else { height += 230}
        
        return height
    }
}
