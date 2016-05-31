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

protocol BlurredNavigationBarAlphaChangerProtocol: class {
    var navigationBarAlpha : CGFloat { get set }
}

class BlurredImageContainerViewController : UIViewController, CharacterProviderDelegate ,BlurredNavigationBarAlphaChangerProtocol {
    var character : Character?
    var characterImage : UIImage?
    
    var navigationBarAlpha : CGFloat = 0 {
        didSet {
          //  print(navigationBarAlpha)
            self.viewWithBlur?.alpha = navigationBarAlpha
            self.navigationItem.titleView?.alpha = navigationBarAlpha
            
            self.title = navigationBarAlpha == 1 ? character?.name : " "
        }
    }
    
    weak var embeddedVC : CharacterDetailsViewController?
    
    @IBOutlet weak var blurredImage: UIImageView!
    
    var viewWithBlur : UIView?
    
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
            bar.backgroundColor = UIColor.clearColor()
            bar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
            bar.shadowImage = UIImage()
        }()
        
        viewWithBlur = {
            let viewHoldingBlur = UIView(frame: CGRectMake(0, -20, bar.bounds.width, bar.bounds.height + 20))
            let blur =  UIBlurEffect(style: UIBlurEffectStyle.Dark)
            let viewWithBlur = UIVisualEffectView(frame: CGRectMake(0, 0, viewHoldingBlur.bounds.width, viewHoldingBlur.bounds.height))
            viewWithBlur.effect = blur
            
            let vibrancy = UIVibrancyEffect(forBlurEffect: blur)
            
            let viewWithVibrancy = UIVisualEffectView(frame: CGRectMake(0, 0, viewHoldingBlur.bounds.width, viewHoldingBlur.bounds.height))
            viewWithVibrancy.effect = vibrancy
            
            viewWithBlur.addSubview(viewWithVibrancy)
            
            viewHoldingBlur.userInteractionEnabled = false
            
            viewHoldingBlur.addSubview(viewWithBlur)
            viewHoldingBlur.opaque = false
            viewHoldingBlur.backgroundColor = UIColor.clearColor()
            bar.addSubview(viewHoldingBlur)
            bar.sendSubviewToBack(viewHoldingBlur)
            return viewHoldingBlur
        }()
        
        navigationBarAlpha = 0
        super.viewDidLoad()
   }
        
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let embedded = segue.destinationViewController as? CharacterDetailsViewController {
            embedded.delegate = self
            embedded.delegateBar = self
            embeddedVC = embedded
        }
        super.prepareForSegue(segue, sender: sender)
    }
}