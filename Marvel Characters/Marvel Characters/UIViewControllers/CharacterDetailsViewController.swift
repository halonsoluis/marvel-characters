//
//  CharacterDetailsViewController.swift
//  Marvel Characters
//
//  Created by Hugo on 5/27/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import Foundation
import UIKit

class CharacterDetailsViewController: UITableViewController {
    
    @IBOutlet weak var largeImage: UIImageView!
    @IBOutlet weak var characterDescription: UILabel!
    @IBOutlet weak var characterName: UILabel!
    
    weak var delegate: CharacterProviderDelegate?
    
   // private static var containerSize = CGFloat(0)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillData()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 500 //Put just any approximate average height for cell. This will just be used to show scroll bar offset.
    }
        
    func fillData() {
        guard let character = delegate?.character else { return }
        
        self.characterName?.text = character.name
        self.characterDescription?.text = character.description
        
        self.largeImage.image = delegate?.characterImage
        
    }
    
}