//
//  IBWebViewController.swift
//  iBotSDK
//
//  Created by Enliple on 17/09/2019.
//

import UIKit
import WebKit

class IBWebViewController: UIViewController {

    fileprivate let jsHandlerName:String = "iBotAppHandler"
    fileprivate let jsMethodClose:String = "onAppViewClose"
    
    var createWebView: WKWebView?
    private weak var lastPresentedController : UIViewController?
    
    deinit {
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init() {
        super.init(nibName: "IBWebViewController", bundle: Bundle(for: IBWebViewController.self))
    }
    
    @objc convenience public init(url:String) {
        self.init()
    }
    
    
    
    @IBOutlet fileprivate weak var wkWebView: WKWebView!
    
    var loadUrl:String = ""
    var isFirstLoadingFinish:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wkWebView.uiDelegate = self
        wkWebView.navigationDelegate = self
        
        wkWebView.scrollView.bounces = false
        
        wkWebView.configuration.userContentController.add(self, name: jsHandlerName)
        
        if let url = URL.init(string: loadUrl) {
            isFirstLoadingFinish = false
            wkWebView.load(URLRequest.init(url: url))
        }   
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        // WKWebView actions sheets workaround
        if presentedViewController != nil && lastPresentedController != presentedViewController  {
            lastPresentedController = presentedViewController
            presentedViewController?.dismiss(animated: flag, completion: {
                completion?();
                self.lastPresentedController = nil;
            })

        } else if lastPresentedController == nil {
            super.dismiss(animated: flag, completion: completion)
        }
    }
    
    @IBAction func clickedBackButton(_ sender: Any) {
        self.hlDismiss()
    }
    
}



extension IBWebViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("WebView-ScriptMessage : [name : \(message.name)], [body : \(message.body)]")
        
        if message.name == jsHandlerName {
            let messageBody = message.body as! String
            print("message body : \(messageBody)")
            
            if message.body as! String == jsMethodClose {
                self.hlDismiss()
            }
        }
    }
}


extension IBWebViewController: WKUIDelegate {

    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if let url = navigationAction.request.url {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)    
        }
        
        return nil
    }
}


extension IBWebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if !isFirstLoadingFinish {
            isFirstLoadingFinish = true
            getUidFromCookie()
        }
    }
    
    
    func getUidFromCookie() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) { 
            var uid = ""
            WKWebsiteDataStore.default().httpCookieStore.getAllCookies { (cookies) in
                for cookie in cookies{ 
                    if cookie.name == "uid" {
                        uid = cookie.value
                        break
                    }
                }
                
                if uid.isEmpty {
                    print("try again-----")
                    self.getUidFromCookie()
                }
                else {
                    print("uid : \(uid)")
                    IBApi.shared.sendDeviceInfo(uid: uid) { (result, error) in }
                }
            }
        }
    }
}

