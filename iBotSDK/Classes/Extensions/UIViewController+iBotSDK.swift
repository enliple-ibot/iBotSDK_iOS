//
//  IBUIViewController.swift
//  iBotSDK
//
//  Created by Enliple on 17/09/2019.
//

import Foundation

extension UIViewController {
    
    public func ibPresent(vc:UIViewController, isPush:Bool = false, animated:Bool = false, completion: (() -> Void)? = nil) {
        if isPush {
            var navigation:UINavigationController? = nil
            if self is UINavigationController {
                navigation = self as? UINavigationController
            }
            else  {
                navigation = self.navigationController
            }
            
            if let navi = navigation {
                navi.setNavigationBarHidden(true, animated: false)
                navi.pushViewController(vc, animated: animated, completion: completion)
            }
            else {
                self.present(vc, animated: animated, completion: completion)    
            }
        }
        else {
            self.present(vc, animated: animated, completion: completion)
        }
    }
    
    public func ibDismiss(naviBarShow:Bool = true) {
        if let _ = self.navigationController {
            var navigation:UINavigationController? = nil
            if self is UINavigationController {
                navigation = self as? UINavigationController
            }
            else  {
                navigation = self.navigationController
            }
            
            if let navi = navigation {
                navi.setNavigationBarHidden(!naviBarShow, animated: false)
            }
            
            navigation?.popViewController(animated: true)    
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    
    
}
