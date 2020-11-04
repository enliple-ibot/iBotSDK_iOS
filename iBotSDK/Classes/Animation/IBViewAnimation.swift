//
//  IBViewAnimation.swift
//  iBotSDK
//
//  Created by enliple on 2019/11/08.
//

import UIKit

public enum IBAnimationType: String {
    case flipping           = "flipping"
    case fadeIn             = "ANIMATE_0000"
    case slideUp            = "ANIMATE_0001"
    case twinkle            = "ANIMATE_0002"
    case rotate             = "ANIMATE_0003"
    case spring             = "ANIMATE_0004"
    case slideLeftToRight   = "ANIMATE_0005"
}


class IBViewAnimation {
    
    static let shared = IBViewAnimation()
    
    func animate(with view:UIView, type:IBAnimationType, completion: ((Bool) -> Void)? = nil) {
        switch type {
        case .flipping:
            animationFlipping(view: view, completion: completion)
        case .spring:
            animationSpring(view: view, completion: completion)
        case .slideUp:
            animationSlideUp(view: view, completion: completion)
        case .slideLeftToRight:
            animationSlideRightToLeft(view: view, completion: completion)
        case .fadeIn:
            animationFadeIn(view: view, completion: completion)
        case .twinkle:
            animationTwinkle(view: view, completion: completion)
        case .rotate:
            animationRotate(view: view, completion: completion)
        }
    }
    

    private func animationFlipping(view:UIView, completion: ((Bool) -> Void)? = nil) {
        
        let animation = CABasicAnimation.init(keyPath: "transform.rotation.y")
        animation.fromValue = 0.0
        animation.toValue = (Double.pi * 2)
        animation.repeatCount = 3
        animation.duration = 2.0
        animation.isRemovedOnCompletion = true
        
        view.layer.add(animation, forKey: "rotation")
        
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / 500.0
        view.layer.transform = transform
        
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { (t) in
            completion?(true)
        }
    }
    
    
    private func animationSpring(view:UIView, completion: ((Bool) -> Void)? = nil) {
        view.center.y = view.center.y - 40.0
        UIView.animate(withDuration: 2.0, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            view.center.y = view.center.y + 40.0
        }) { (finish) in
            if finish {
                completion?(finish)
            }
        }
    }
    
    private func animationSlideUp(view:UIView, completion: ((Bool) -> Void)? = nil) {
        view.frame.origin.y = view.frame.origin.y + 100            
        UIView.animate(withDuration: 2.0, delay: 0.0, animations: {
            view.frame.origin.y = view.frame.origin.y - 100 
        }) { (finish) in
            if finish {
                completion?(finish)
            }
        }
    }
    
    private func animationFadeIn(view:UIView, completion: ((Bool) -> Void)? = nil) {
        view.alpha = 0.0      
        UIView.animate(withDuration: 2.0, delay: 0.0, animations: {
            view.alpha = 1.0
        }) { (finish) in
            if finish {
                completion?(finish)
            }
        }
    }
    
    private func animationTwinkle(view:UIView, completion: ((Bool) -> Void)? = nil) {
        view.alpha = 0.0
        
        UIView.animate(withDuration: 0.8, delay: 0, options: [.repeat], animations: {
            UIView.setAnimationRepeatCount(3)
            view.alpha = 1.0
        }) { (finish) in
            if finish {
                completion?(finish)
            }
        }
    }
    
    
    
    private func animationRotate(view:UIView, completion: ((Bool) -> Void)? = nil) {

        UIView.animate(withDuration: 1.0, delay: 0.0, options: [ .curveLinear ] , animations: {
            view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }, completion: { finished in
            if finished {
                UIView.animate(withDuration: 1.0, delay: 0.0, options: [ .curveLinear ], animations: {
                    view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi*2))
                }, completion: { finish in
                    if finish {
                        completion?(finish)
                    }
                })    
            }
        })
    }
    
    
    private func animationSlideRightToLeft(view:UIView, completion: ((Bool) -> Void)? = nil) {
        let diff = UIScreen.main.bounds.width - view.frame.origin.x
        
        view.frame.origin.x = view.frame.origin.x - diff            
        UIView.animate(withDuration: 2.0, delay: 0.0, animations: {
            view.frame.origin.x = view.frame.origin.x + diff 
        }) { (finish) in
            if finish {
                completion?(finish)
            }
        }
    }
}
