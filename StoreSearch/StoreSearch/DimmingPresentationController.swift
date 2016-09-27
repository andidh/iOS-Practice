//
//  DimmingPresentationController.swift
//  StoreSearch
//
//  Created by Dehelean Andrei on 9/22/16.
//  Copyright © 2016 Dehelean Andrei. All rights reserved.
//

import UIKit

class DimmingPresentationController: UIPresentationController {
    
    lazy var gradient = GradientView(frame: CGRect.zero)
    
    override func shouldRemovePresentersView() -> Bool {
        return false
    }
    
    override func presentationTransitionWillBegin() {
        gradient.frame = containerView!.bounds
        containerView?.insertSubview(gradient, atIndex: 0)
        
        gradient.alpha = 0
        if let transitionCoordinator = presentedViewController.transitionCoordinator() {
            transitionCoordinator.animateAlongsideTransition({ _ in
            self.gradient.alpha = 1
                }, completion: nil)
        }
    }
    
    override func dismissalTransitionWillBegin() {
        if let transitionCoordinator = presentedViewController.transitionCoordinator() {
            transitionCoordinator.animateAlongsideTransition({ (_) in
                self.gradient.alpha = 0
            }, completion: nil)
        }
    }
    
}
