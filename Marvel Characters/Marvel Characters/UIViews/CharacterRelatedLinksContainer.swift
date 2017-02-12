//
//  CharacterRelatedLinksContainer.swift
//  Marvel Characters
//
//  Created by Hugo Alonso on 5/29/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import UIKit

class CharacterRelatedLinksContainer: GenericBlockCharacterDetail, LinksPresenterProtocol {
    
    @IBOutlet weak var relatedLinksContainer: UIContentContainer!
    
    var characterLinks: [LinkURL]? = []
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let relatedLinks = segue.destination as? LinksPresenterProtocol else {return}
       
        relatedLinks.characterLinks = characterLinks
    }

}
