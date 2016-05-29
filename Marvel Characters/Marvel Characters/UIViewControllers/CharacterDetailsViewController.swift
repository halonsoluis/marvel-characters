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

class CharacterDetailsViewController: UITableViewController {
    
    @IBOutlet weak var largeImage: UIImageView!
    @IBOutlet weak var characterDescription: UILabel!
    @IBOutlet weak var characterName: UILabel!
    
    let disposeBag = DisposeBag()
    weak var delegate: CharacterProviderDelegate?
    weak var delegateBar : BlurredNavigationBarAlphaChangerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillData()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 500 //Put just any approximate average height for cell. This will just be used to show scroll bar offset.
        
        tableView
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
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard
            let related = segue.destinationViewController as? CrossReferencePresenterProtocol
            
            else {
                guard let relatedLinks = segue.destinationViewController as? LinksPresenterProtocol else {return}
                relatedLinks.characterLinks = delegate?.character?.urls
                return
        }
        let identifier = segue.identifier!
        switch identifier {
        case "relatedComics": related.elements = delegate?.character?.comics?.items
        case "relatedSeries": related.elements = delegate?.character?.series?.items
        case "relatedStories": related.elements = delegate?.character?.stories?.items
        case "relatedEvents": related.elements = delegate?.character?.events?.items
        default : break
            
        }
    }
    
    func fillData() {
        guard let character = delegate?.character else { return }
        
        self.characterName?.text = character.name
        self.characterDescription?.text = character.description
        
        self.largeImage.image = delegate?.characterImage
        
        
    }
    
}