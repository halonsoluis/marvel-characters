//
//  BlurredImageContainerViewController.swift
//  Marvel Characters
//
//  Created by Hugo Alonso on 5/28/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import UIKit

protocol CharacterProviderDelegate: class {
    var character: Character? { get set }
    var characterImage: UIImage? { get set}
}

class BlurredImageContainerViewController : UIViewController, CharacterProviderDelegate {
    var character : Character?
    var characterImage : UIImage?
    
    @IBOutlet weak var blurredImage: UIImageView!
    
    override func viewDidLoad() {
       
        
        blurredImage?.image = characterImage
         super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            if let embedded = segue.destinationViewController as? CharacterDetailsViewController {
                embedded.delegate = self
            }
        super.prepareForSegue(segue, sender: sender)
        
    }
}