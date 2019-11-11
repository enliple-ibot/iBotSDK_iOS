//
//  IBViewAnimation.swift
//  iBotSDK
//
//  Created by enliple on 2019/11/08.
//

import UIKit


class IBViewAnimation {

    func animateFlipping(view:UIView) {
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
    }
    
    func animateSpring(view:UIView) {
        view.center.y = view.center.y - 40.0
        UIView.animate(withDuration: 2.0, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            view.center.y = view.center.y + 40.0
        }, completion: nil)
    }
    
    func animationSlideUp(view:UIView) {
        view.frame.origin.y = view.frame.origin.y + 100            
        UIView.animate(withDuration: 2.0, delay: 0.0, animations: {
            view.frame.origin.y = view.frame.origin.y - 100 
        }) { (finish) in
        }
    }
    
    func animationFadeIn(view:UIView) {
        view.alpha = 0.0      
        UIView.animate(withDuration: 2.0, delay: 0.0, animations: {
            view.alpha = 1.0
        }) { (finish) in
        }
    }
    
    func animationTwinkle(view:UIView) {
        view.alpha = 0.0
        
        UIView.animate(withDuration: 0.8, delay: 0, options: [.repeat], animations: {
            UIView.setAnimationRepeatCount(3)
            view.alpha = 1.0
        }, completion: nil)
    }
}
