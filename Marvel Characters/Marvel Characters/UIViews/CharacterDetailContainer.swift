//
//  CharacterDetailContainer.swift
//  Marvel Characters
//
//  Created by Hugo Alonso on 5/29/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import UIKit

class CharacterDetailContainer: GenericBlockCharacterDetail {

    @IBOutlet var textDescription: UILabel!

    var text: String? = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        textDescription?.text = text
    }
}
