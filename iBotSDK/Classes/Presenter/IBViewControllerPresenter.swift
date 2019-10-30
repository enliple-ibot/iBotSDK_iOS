//
//  IBViewControllerPresenter.swift
//  iBotSDK
//
//  Created by Enliple on 17/09/2019.
//

import Foundation


class IBViewControllerPresenter {
    public static let shared: IBViewControllerPresenter = IBViewControllerPresenter()
    
    func showWebViewController(parent:UIViewController, url:String, isPush:Bool = false, animated:Bool = true, completion: (() -> Void)? = nil) {
        let vc = IBWebViewController.init(url:url)
        vc.loadUrl = url
        vc.modalPresentationStyle = .overFullScreen
        parent.ibPresent(vc: vc, isPush: isPush, animated: animated, completion: completion)
    }
}
