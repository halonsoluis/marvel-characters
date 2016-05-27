//
//  CharacterDetailsViewController.swift
//  Marvel Characters
//
//  Created by Hugo on 5/27/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import Foundation
import UIKit

class CharacterDetailsViewController: UIViewController {
    
    var character: Character?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationItem.titleView?.backgroundColor = UIColor.clearColor()
        navigationController?.view.backgroundColor = UIColor.clearColor()
        
        guard let character = character else { return }
        
        self.title = character.name
        
        
    }
    
}