//
//  IBUIViewController.swift
//  iBotSDK
//
//  Created by Enliple on 17/09/2019.
//

import Foundation

extension UIViewController {
    
    public func ibPresent(vc:UIViewController, isPush:Bool = false, animated:Bool = false, completion: (() -> Void)? = nil) {
        if isPush && self.navigationController != nil {
            self.navigationController?.pushViewController(vc, animated: animated, completion: completion)
        }
        else {
            self.present(vc, animated: animated, completion: completion)
        }
    }
    
    public func hlDismiss() {
        if let _ = self.navigationController {
            self.navigationController?.popViewController(animated: true)    
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    
    
}
