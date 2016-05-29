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
    
    var viewWithBlur : UIVisualEffectView?
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        viewWithBlur?.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        blurredImage?.image = characterImage
        
        
        self.title = character?.name
        
        
        guard let bar = navigationController?.navigationBar else { return }
        
        //makeNavigationBarTransparent
        _ = {
            bar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
            bar.shadowImage = UIImage()
        }()
        
        viewWithBlur = {
            let blur =  UIBlurEffect(style: UIBlurEffectStyle.Dark)
            let viewWithBlur = UIVisualEffectView(frame: CGRectMake(0, -20, bar.bounds.width, bar.bounds.height + 20))
            viewWithBlur.effect = blur
            
            let vibrancy = UIVibrancyEffect(forBlurEffect: blur)
            
            let viewWithVibrancy = UIVisualEffectView(frame: CGRectMake(0, -20, bar.bounds.width, bar.bounds.height + 20))
            viewWithVibrancy.effect = vibrancy
            
            viewWithBlur.addSubview(viewWithVibrancy)
            
            viewWithBlur.userInteractionEnabled = false
            
            bar.addSubview(viewWithBlur)
            bar.sendSubviewToBack(viewWithBlur)
            return viewWithBlur
        }()
        
        navigationBarAlpha = 0
        super.viewDidLoad()
   }
        
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let embedded = segue.destinationViewController as? CharacterDetailsViewController {
            embedded.delegate = self
            embedded.delegateBar = self
        }
        super.prepareForSegue(segue, sender: sender)
    }
}