//
//  RepositionBackTransition.swift
//  Marvel Characters
//
//  Created by Hugo Alonso on 6/6/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import Foundation
import UIKit

class RepositionBackTransition : NSObject, UIViewControllerAnimatedTransitioning {
    
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
        snapShot.opaque = true
        
        let frame = endingView.frame
        
        startOn.getImageView()?.hidden = true
        endsOn.getViewOfController().alpha = 0
        
        endsOn.getViewOfController().frame = transitionContext.finalFrameForViewController(endsOn.getViewController())
        
        containerView.addSubview(endsOn.getViewOfController())
        containerView.addSubview(snapShot)
       
        endsOn.getEnclosingView().alpha = 0
        UIView.animateWithDuration(0.2, animations: {
            
            startOn.getViewOfController().alpha = 0.35
            
            }, completion:  {_ in
                UIView.animateWithDuration(0.35, animations: {
                    snapShot.frame = endingView.convertRect(frame, toView: containerView)
                    snapShot.clipsToBounds = true
                    
                    startOn.getViewOfController().alpha = 0
                    endsOn.getViewOfController().alpha = 0.5
                    
                    }, completion: {_ in
                        UIView.animateWithDuration(0.35, animations: {
                            endsOn.getViewOfController().alpha = 1
                            endsOn.getEnclosingView().alpha = 1
                            
                            }, completion: { _ in
                                
                                startOn.getImageView()?.hidden = false
                                startOn.getViewOfController().alpha = 1
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
