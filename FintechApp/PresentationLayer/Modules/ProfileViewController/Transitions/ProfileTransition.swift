//
//  ProfileTransition.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 22.11.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit

final class ProfileTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    enum TransitionType {
        case present
        case dismiss
    }
    
    private let animationDuration: Double
    private let transitionType: TransitionType
    
    init(duration: Double = 1.3, type: TransitionType) {
        self.animationDuration = duration
        self.transitionType = type
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        TimeInterval(exactly: animationDuration) ?? 0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to),
              let fromViewController = transitionContext.viewController(forKey: .from) else {
            transitionContext.completeTransition(false)
            return
        }
        
        switch transitionType {
        case .present:
            presentAnimation(with: transitionContext, toViewController: toViewController)
        case .dismiss:
            dismissAnimation(with: transitionContext, fromViewController: fromViewController)
        }
    }
    
    private func presentAnimation(with context: UIViewControllerContextTransitioning, toViewController: UIViewController) {
        let viewToAnimate = toViewController.view ?? UIView()
        
        viewToAnimate.frame = context.finalFrame(for: toViewController)
        context.containerView.addSubview(viewToAnimate)
        
        viewToAnimate.clipsToBounds = true
        viewToAnimate.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        let duration = transitionDuration(using: context)
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.35,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut) {
            
            viewToAnimate.transform = .identity
        } completion: { _ in
            context.completeTransition(true)
        }
    }
    
    private func dismissAnimation(with context: UIViewControllerContextTransitioning, fromViewController: UIViewController) {
        let viewToAnimate = fromViewController.view ?? UIView()
        context.containerView.addSubview(viewToAnimate)
        
        let duration = transitionDuration(using: context)
        let scaleDown = CGAffineTransform(scaleX: 0.3, y: 0.3)
        let smallJump = CGAffineTransform(translationX: 0, y: -52)
        let moveOut = CGAffineTransform(translationX: 0, y: viewToAnimate.frame.height)
        
        UIView.animateKeyframes(withDuration: duration,
                                delay: 0,
                                options: .calculationModeLinear) {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.3) {
                
                viewToAnimate.transform = scaleDown
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.4) {
                
                viewToAnimate.transform = scaleDown.concatenating(smallJump)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.4) {
                
                viewToAnimate.transform = scaleDown.concatenating(moveOut)
                viewToAnimate.alpha = 0
            }
        } completion: { _ in
            context.completeTransition(true)
        }
    }
}
