//
//  IBViewControllerPresenter.swift
//  iBotSDK
//
//  Created by Enliple on 17/09/2019.
//

import Foundation


class IBViewControllerPresenter {
    public static let shared: IBViewControllerPresenter = IBViewControllerPresenter()
    
    func showWebViewController(parent:UIViewController, url:String, isPush:Bool = false, animated:Bool = true, callback:IBotSDKCallback? = nil, completion: (() -> Void)? = nil) {
        let vc = IBWebViewController.init(url:url)
        vc.loadUrl = url
        vc.modalPresentationStyle = .overFullScreen
        vc.callback = callback
        
        var navigation:UINavigationController? = nil
        if parent is UINavigationController {
            navigation = parent as? UINavigationController
        }
        else  {
            navigation = parent.navigationController
        }
        vc.willShowNavigationBarWhenDismiss = !(navigation?.isNavigationBarHidden ?? true)
        
        parent.ibPresent(vc: vc, isPush: isPush, animated: animated, completion: completion)
    }
}
