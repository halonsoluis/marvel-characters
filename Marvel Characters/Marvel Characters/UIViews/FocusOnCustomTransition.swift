//
//  FocusOnCustomTransition.swift
//  Marvel Characters
//
//  Created by Hugo Alonso on 5/30/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import Foundation
import UIKit

class FocusOnCustomTransition : NSObject, UIViewControllerAnimatedTransitioning {
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard
            let startOn = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            let endsOn = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
            
            let containerView = transitionContext.containerView()
            else { return }
        
        if let startOn = startOn as? CharacterListViewController, let endsOn = endsOn as? BlurredImageContainerViewController {
            guard
                let indexPath = startOn.tableView.indexPathForSelectedRow,
                let cell = startOn.tableView.cellForRowAtIndexPath(indexPath) as? CharacterCell
                else { return }
            
            let snapShot = UIImageView(image: cell.bannerImage.image)
            snapShot.contentMode = .ScaleAspectFill
            snapShot.frame = cell.bannerImage.convertRect(cell.bannerImage.frame, toView: containerView)
            cell.hidden = true
            snapShot.clipsToBounds = startOn is SearchViewController ? false : true
            let imageSize = cell.bannerImage.image!.size
            let widthFactor = UIScreen.mainScreen().bounds.width / imageSize.width
            let newHeight = imageSize.height * widthFactor
            let frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: newHeight)
            
            endsOn.view.frame = transitionContext.finalFrameForViewController(endsOn)
            endsOn.view.alpha = 0
           
            let destinationView = endsOn.embeddedVC!.largeImage
            destinationView.hidden = true
            endsOn.embeddedVC!.view.frame.origin.y = endsOn.embeddedVC!.view.frame.height
            
            containerView.addSubview(endsOn.view)
            containerView.addSubview(snapShot)
        
            startOn.navigationController?.navigationBar.alpha = 0
            snapShot.opaque = true
       
            let frameFullHeight = CGRect(x: 0, y: snapShot.frame.origin.y, width: snapShot.frame.width, height: newHeight)
            
            UIView.animateWithDuration(0.35, animations: {
                startOn.view.alpha = 0
                
                endsOn.view.alpha = 0.8
                snapShot.frame = containerView.convertRect(frameFullHeight, toView: containerView)
                
                }, completion:  {_ in
                    UIView.animateWithDuration(0.35, animations: {
                        endsOn.view.alpha = 1
                        snapShot.frame = containerView.convertRect(frame, toView: containerView)
                        endsOn.embeddedVC!.view.frame.origin.y = 0                        }, completion: {_ in
                            UIView.animateWithDuration(0.2, animations: {
                                startOn.navigationController?.navigationBar.alpha = 1
                                
                                }, completion: { _ in
                                    destinationView.hidden = false
                                    snapShot.hidden = true
                                    snapShot.removeFromSuperview()
                                    startOn.view.alpha = 1
                                    cell.hidden = false
                                    startOn.navigationController?.navigationBar.alpha = 1
                                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                            })
                    })
            })
        }
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.9
    }
}