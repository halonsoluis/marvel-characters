//
//  BlurredImageContainerViewController.swift
//  Marvel Characters
//
//  Created by Hugo Alonso on 5/28/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import UIKit

protocol CharacterProviderDelegate: class {
    var character: MarvelCharacter? { get set }
    var characterImage: UIImage? { get set}
}

protocol BlurredNavigationBarAlphaChangerProtocol: class {
    var navigationBarAlpha : CGFloat { get set }
}

class BlurredImageContainerViewController : UIViewController, CharacterProviderDelegate ,BlurredNavigationBarAlphaChangerProtocol {
    var character : MarvelCharacter?
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
        setUpNavigatorAppearance()
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        addViewWithBlur()
    }
    
    func setUpNavigatorAppearance() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        blurredImage?.image = characterImage
        
        guard let bar = navigationController?.navigationBar else { return }
        
        //makeNavigationBarTransparent
        _ = {
            bar.backgroundColor = UIColor.clearColor()
            bar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
            bar.shadowImage = UIImage()
            }()
        
        self.title = character?.name
        
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
            return viewHoldingBlur
            }()
        
        addViewWithBlur()
        navigationBarAlpha = 0
    }
    
    func addViewWithBlur() {
        guard let bar = navigationController?.navigationBar, let viewWithBlur = viewWithBlur else { setUpNavigatorAppearance() ; return }
        
        bar.addSubview(viewWithBlur)
        bar.sendSubviewToBack(viewWithBlur)
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

extension BlurredImageContainerViewController: RepositionImageZoomingTransitionProtocol {
    
    func getImageView() -> UIImageView? {
        return embeddedVC?.largeImage
    }
    
    func doBeforeTransition() {
        embeddedVC!.view.frame.origin.y = embeddedVC!.view.frame.height
        view.alpha = 0
    }
    
    func doAfterTransition(){
        
    }
    
    
    func doWhileTransitioningStepOne() {
        view.alpha = 0.8
    }
    func doWhileTransitioningStepTwo(){
        view.alpha = 1
        embeddedVC!.view.frame.origin.y = 0
    }
    func doWhileTransitioningStepThree(){
        
    }
    
    func getViewOfController() -> UIView {
        return self.view
    }
    func getViewController() -> UIViewController {
        return self
    }
    func getEnclosingView() -> UIView {
        return embeddedVC!.largeImage
    }
    
}


extension BlurredImageContainerViewController: UINavigationControllerDelegate {
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.delegate = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.delegate = self
    }
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if self == fromVC && toVC is CharacterListViewController {
            return RepositionBackTransition()
        }
        return nil
    }
}
