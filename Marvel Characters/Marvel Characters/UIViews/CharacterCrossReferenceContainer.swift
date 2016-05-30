//
//  CharacteCrossReferenceContainer.swift
//  Marvel Characters
//
//  Created by Hugo Alonso on 5/29/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import UIKit

class CharacterCrossReferenceContainer: GenericBlockCharacterDetail, CrossReferencePresenterProtocol {
    
    @IBOutlet weak var crossReferenceContainer: UIContentContainer!
    
    var elements: [CrossReferenceItem]? = []
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        guard let related = segue.destinationViewController as? CrossReferencePresenterProtocol else { return }
        
        related.elements = elements
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}