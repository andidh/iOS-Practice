//
//  FadeOutAnimationController.swift
//  StoreSearch
//
//  Created by Dehelean Andrei on 9/25/16.
//  Copyright © 2016 Dehelean Andrei. All rights reserved.
//

import UIKit

class FadeOutAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.4
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey) {
            let duration = transitionDuration(transitionContext)
            UIView.animateWithDuration(duration, animations: { 
                fromView.alpha = 0
                }, completion: { (bool) in
                    transitionContext.completeTransition(bool)
            })
        }
    }
}

