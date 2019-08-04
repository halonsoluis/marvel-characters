//
//  BackToPreviousCellTransition.swift
//  Marvel Characters
//
//  Created by Hugo Alonso on 6/6/16.
//  Copyright © 2016 halonsoluis. All rights reserved.
//

import Foundation
import UIKit

protocol RepositionImageZoomingTransitionProtocol: class {
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

class RepositionImageZoomingTransition: NSObject, UIViewControllerAnimatedTransitioning {

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
        snapShot.clipsToBounds = true
        snapShot.isOpaque = true

        let imageSize = initialView.image!.size
        let widthFactor = UIScreen.main.bounds.width / imageSize.width
        let newHeight = imageSize.height * widthFactor
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: newHeight)

        startOn.doBeforeTransition()
        endsOn.doBeforeTransition()

        endsOn.getViewOfController().frame = transitionContext.finalFrame(for: endsOn.getViewController())

        containerView.addSubview(endsOn.getViewOfController())
        containerView.addSubview(snapShot)

        UIView.animate(withDuration: 0.35, animations: {

            snapShot.frame = containerView.convert(frame, to: containerView)

            startOn.doWhileTransitioningStepOne()
            endsOn.doWhileTransitioningStepOne()

            }, completion: {_ in
                UIView.animate(withDuration: 0.35, animations: {

                    startOn.doWhileTransitioningStepTwo()
                    endsOn.doWhileTransitioningStepTwo()

                    }, completion: {_ in
                        UIView.animate(withDuration: 0.2, animations: {
                            startOn.doWhileTransitioningStepThree()
                            endsOn.doWhileTransitioningStepThree()
                            }, completion: { _ in
                                startOn.doAfterTransition()
                                endsOn.doAfterTransition()

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
