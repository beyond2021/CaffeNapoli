//
//  CustomAnimationPresenter.swift
//  CaffeNapoli
//
//  Created by Kev1 on 11/25/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
class CustomAnimationPresenter: NSObject, UIViewControllerAnimatedTransitioning {
    //
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        //
        return 0.5
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // my custom transition animation code logic
        let containerView = transitionContext.containerView
        
        guard let toView = transitionContext.view(forKey: .to) else { return } // cameraController
        guard let fromView = transitionContext.view(forKey: .from) else { return }// HomeController
        containerView.addSubview(toView)
        // left to right animation transition
        let startingFrame = CGRect(x: -toView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height)
        toView.frame = startingFrame
        //
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            //animation
            toView.frame = CGRect(x: 0, y: 0, width: toView.frame.width, height: toView.frame.height) // slide camera in from left
            
            fromView.frame = CGRect(x: fromView.frame.width, y: 0, width: fromView.frame.width, height: fromView.frame.height)// slide to right offn the screen
            
        }) { (_) in
            //completion
            transitionContext.completeTransition(true)// tell system transition is done
            
        }
       
    }
}

