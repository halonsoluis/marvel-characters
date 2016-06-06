//
//  BackToPreviousCellTransition.swift
//  Marvel Characters
//
//  Created by Hugo Alonso on 6/6/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import Foundation
import UIKit

protocol RepositionImageZoomingTransitionProtocol : class {
    func getImageView() -> UIImageView?
    func getViewOfController() -> UIView
    func getViewController() -> UIViewController
    func getEnclosingView() -> UIView
    
    func doBeforeTransition()
    func doWhileTransitioningStepOne()
    func doWhileTransitioningStepTwo()
    func doWhileTransitioningStepThree()
    func doAfterTransition()
    
}

class RepositionImageZoomingTransition : NSObject, UIViewControllerAnimatedTransitioning {
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard
            let startOn = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as? RepositionImageZoomingTransitionProtocol,
            let endsOn = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as? RepositionImageZoomingTransitionProtocol,
            let containerView = transitionContext.containerView(),
            let initialView = startOn.getImageView(),
            let endingView = endsOn.getImageView()
            else { return }
        
        endingView.hidden = true
        
        let snapShot = UIImageView(image: initialView.image)
        snapShot.contentMode = .ScaleAspectFill
        snapShot.frame = initialView.convertRect(initialView.frame, toView: containerView)
        snapShot.clipsToBounds = true
        snapShot.opaque = true
        
        let imageSize = initialView.image!.size
        let widthFactor = UIScreen.mainScreen().bounds.width / imageSize.width
        let newHeight = imageSize.height * widthFactor
        let frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: newHeight)
        
        startOn.doBeforeTransition()
        endsOn.doBeforeTransition()
        
        endsOn.getViewOfController().frame = transitionContext.finalFrameForViewController(endsOn.getViewController())
        
        containerView.addSubview(endsOn.getViewOfController())
        containerView.addSubview(snapShot)
        
        UIView.animateWithDuration(0.35, animations: {
            
            snapShot.frame = containerView.convertRect(frame, toView: containerView)
            
            startOn.doWhileTransitioningStepOne()
            endsOn.doWhileTransitioningStepOne()
            
            }, completion:  {_ in
                UIView.animateWithDuration(0.35, animations: {
                    
                    startOn.doWhileTransitioningStepTwo()
                    endsOn.doWhileTransitioningStepTwo()
                    
                    }, completion: {_ in
                        UIView.animateWithDuration(0.2, animations: {
                            startOn.doWhileTransitioningStepThree()
                            endsOn.doWhileTransitioningStepThree()
                            }, completion: { _ in
                                startOn.doAfterTransition()
                                endsOn.doAfterTransition()
                                
                                endingView.hidden = false
                                snapShot.hidden = true
                                snapShot.removeFromSuperview()
                                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                        })
                })
        })
        
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.9
    }
}