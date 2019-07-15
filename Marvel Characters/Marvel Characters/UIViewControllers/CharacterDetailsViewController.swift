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
        largeImage.contentMode = UIViewContentMode.scaleAspectFill
        // Clip the parts of the image that are not in frame
        largeImage.clipsToBounds = true
        // Set the autoresizingMask to always be the same height as the header
        largeImage.autoresizingMask = UIViewAutoresizing.flexibleTopMargin
        
        scrollView
            .rx.contentOffset
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
            .drive(onNext: { [weak self] (alpha) in
                self?.delegateBar?.navigationBarAlpha = alpha
                }, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        
        scrollView
            .rx.contentOffset
            .asDriver()
            .filter { $0.y < 0 }
            .distinctUntilChanged()
            .drive(onNext: { [weak self] (offset) in
                let progress:CGFloat = fabs(offset.y ) / 250
                self?.largeImage.transform = CGAffineTransform(scaleX: 1 + progress, y: 1 + progress)
                self?.largeImage.frame.origin.y = offset.y * CGFloat((self?.factor)!)
                //          self?.largeImageHeight.constant = self!.largeImageHeight.constant * (1 + progress)
                }, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        
        let _ = fillData()
    }
    var factor : CGFloat = 1
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let identifier = segue.identifier,
            let character = delegate?.character,
            let id = character.id
            else { return }
        
        if let detail = segue.destination as? CharacterDetailContainer {
            
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
        
        
        if let relatedLinks = segue.destination as? CharacterRelatedLinksContainer, identifier == "links" {
            relatedLinks.nameForSection = "RELATED LINKS" ;
            relatedLinks.characterLinks = character.urls
            return
        }
        
        
        guard let related = segue.destination as? CharacterCrossReferenceContainer else { return }
        
        
        switch identifier {
        case "comics":
            related.nameForSection = "COMICS" ;
          //  related.elements = character.comics?.items
            related.route = Routes.listComicsByCharacter(characterID: id)
            related.total = character.comics!.available
        case "series":
            related.nameForSection = "SERIES" ;
          //  related.elements = delegate?.character?.series?.items
            related.route = Routes.listSeriesByCharacter(characterID: id)
            related.total = character.series!.available
        case "stories":
            related.nameForSection = "STORIES" ;
          //  related.elements = delegate?.character?.stories?.items
            related.route = Routes.listStoriesByCharacter(characterID: id)
            related.total = character.stories!.available
        case "events":
            related.nameForSection = "EVENTS" ;
          //  related.elements = delegate?.character?.events?.items
            related.route = Routes.listEventsByCharacter(characterID: id)
            related.total = character.events!.available
            
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
        let widthFactor = UIScreen.main.bounds.width / imageSize.width
        let newHeight = imageSize.height * widthFactor
        largeImageHeight.constant = newHeight
        parentView.setNeedsLayout()
        
        var height = newHeight
        factor = self.largeImage.frame.height > self.largeImage.frame.width ? 2 : 1.7
        if let items = character.name, items.isEmpty { nameContainer.removeFromSuperview() } else { height += 120}
        if let items = character.description, items.isEmpty { descriptionContainer.removeFromSuperview() } else {
            
            if let descriptionText = descriptionTextContainer/*?.textDescription*/ {
                descriptionText.textDescription.sizeToFit()
                //   print("bounds = \(descriptionText.bounds)")
                descriptionContainerHeight.constant = 60 + descriptionText.textDescription.bounds.height + 100
            }
            height += 180
            
        }
        
        if let items = character.comics?.items, items.isEmpty { comicsContainer.removeFromSuperview() } else { height += 280}
        if let items = character.series?.items, items.isEmpty { seriesContainer.removeFromSuperview() } else { height += 280}
        if let items = character.events?.items, items.isEmpty { eventsContainer.removeFromSuperview() } else { height += 280}
        if let items = character.stories?.items, items.isEmpty { storiesContainer.removeFromSuperview() } else { height += 280}
        
        if let items = character.urls, items.isEmpty { linksContainer.removeFromSuperview() } else { height += 230}
        
        return height
    }
}

