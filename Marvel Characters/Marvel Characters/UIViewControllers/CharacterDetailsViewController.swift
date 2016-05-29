//
//  CharacterDetailsViewController.swift
//  Marvel Characters
//
//  Created by Hugo on 5/27/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import UIKit

class CharacterDetailsViewController: UITableViewController {
    
    @IBOutlet weak var largeImage: UIImageView!
    @IBOutlet weak var characterDescription: UILabel!
    @IBOutlet weak var characterName: UILabel!
    
    weak var delegate: CharacterProviderDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillData()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 500 //Put just any approximate average height for cell. This will just be used to show scroll bar offset.
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