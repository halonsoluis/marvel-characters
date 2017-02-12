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
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let startOn = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? RepositionImageZoomingTransitionProtocol,
            let endsOn = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? RepositionImageZoomingTransitionProtocol,
            let initialView = startOn.getImageView(),
            let endingView = endsOn.getImageView()
            else { return }
        let containerView = transitionContext.containerView
        endingView.isHidden = true
        
        let snapShot = UIImageView(image: initialView.image)
        snapShot.contentMode = .scaleAspectFill
        snapShot.frame = initialView.convert(initialView.frame, to: containerView)
        snapShot.isOpaque = true
        
        let frame = endingView.frame
        
        startOn.getImageView()?.isHidden = true
        endsOn.getViewOfController().alpha = 0
        
        endsOn.getViewOfController().frame = transitionContext.finalFrame(for: endsOn.getViewController())
        
        containerView.addSubview(endsOn.getViewOfController())
        containerView.addSubview(snapShot)
       
        endsOn.getEnclosingView().alpha = 0
        UIView.animate(withDuration: 0.2, animations: {
            
            startOn.getViewOfController().alpha = 0.35
            
            }, completion:  {_ in
                UIView.animate(withDuration: 0.35, animations: {
                    snapShot.frame = endingView.convert(frame, to: containerView)
                    snapShot.clipsToBounds = true
                    
                    startOn.getViewOfController().alpha = 0
                    endsOn.getViewOfController().alpha = 0.5
                    
                    }, completion: {_ in
                        UIView.animate(withDuration: 0.35, animations: {
                            endsOn.getViewOfController().alpha = 1
                            endsOn.getEnclosingView().alpha = 1
                            
                            }, completion: { _ in
                                
                                startOn.getImageView()?.isHidden = false
                                startOn.getViewOfController().alpha = 1
                                endingView.isHidden = false
                                snapShot.isHidden = true
                                snapShot.removeFromSuperview()
                                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                        })
                })
        })
        
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.9
    }
}
