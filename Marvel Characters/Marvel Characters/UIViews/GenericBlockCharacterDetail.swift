//
//  GenericBlockCharacterDetail.swift
//  Marvel Characters
//
//  Created by Hugo Alonso on 5/29/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import UIKit

class GenericBlockCharacterDetail: UIViewController {
    
    @IBOutlet weak var sectionName: UILabel!
    
    var nameForSection : String = ""
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        sectionName?.text = nameForSection
    }
}
