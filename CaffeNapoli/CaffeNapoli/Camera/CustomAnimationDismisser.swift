//
//  CustomAnimationDismisser.swift
//  CaffeNapoli
//
//  Created by Kev1 on 11/25/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
class CustomAnimationDismisser : NSObject, UIViewControllerAnimatedTransitioning {
    //
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        //
        return 0.5
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // my custom transition animation code logic
        let containerView = transitionContext.containerView
        guard let fromView = transitionContext.view(forKey: .from) else { return } // cameraController view
        guard let toView = transitionContext.view(forKey: .to) else { return }// Homecontroller view
        containerView.addSubview(toView)// important to see the toview during the transition
//       left to right animation

        //
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            //animation
            fromView.frame = CGRect(x: -fromView.frame.width, y: 0, width: fromView.frame.width, height: fromView.frame.height)// cvameracontroller slide off the screen to the right
            
            toView.frame = CGRect(x: 0, y: 0, width: toView.frame.width, height: toView.frame.height) // homecontroller slide on the screen from left
            
        }) { (_) in
            //completion
            transitionContext.completeTransition(true)
            
        }
        
        
        
        
        
        
    }
    
    
    
}

