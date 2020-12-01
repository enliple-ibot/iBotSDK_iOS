//
//  IBWebViewController.swift
//  iBotSDK
//
//  Created by Enliple on 17/09/2019.
//

import UIKit
import WebKit

class IBWebViewController: UIViewController {

    fileprivate let jsHandlerName:String                = "iBotAppHandler"
    fileprivate let jsMethodClose:String                = "onAppViewClose"
    fileprivate let jsMethodExcuteIBOTMessage:String    = "onAppSend"
    
    var createWebView: WKWebView?
    private weak var lastPresentedController : UIViewController?
    
    var callback:IBotSDKCallback? = nil
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
//        return .default
        if let navigation = self.navigationController {
            return navigation.preferredStatusBarStyle 
        }
        else {
            return self.presentingViewController?.preferredStatusBarStyle ?? .default
        }
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
    
    var willShowNavigationBarWhenDismiss:Bool = true
    
    @IBOutlet fileprivate weak var wkWebView: WKWebView!
    @IBOutlet weak var bottomMargin: NSLayoutConstraint!
    
    
    var loadUrl:String = ""
    var isFirstLoadingFinish:Bool = false
    var isFinished:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearCache()
        
        wkWebView.uiDelegate = self
        wkWebView.navigationDelegate = self
        
        wkWebView.scrollView.bounces = false
        wkWebView.scrollView.isScrollEnabled = false
        
        wkWebView.configuration.userContentController.add(self, name: jsHandlerName)
        wkWebView.configuration.websiteDataStore = WKWebsiteDataStore.default()
//
//        let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache])
//        let date = Date(timeIntervalSince1970: 0)
//        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: date, completionHandler:{ })
//
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                #if DEBUG
                    print("WKWebsiteDataStore record deleted:", record)
                #endif
            }
        }
        
        
        wkWebView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        loadChatBotUrl()
        
        registKeyboardNotifications()
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        updateBackgroundColor()
    }
    
    
    func updateBackgroundColor() {
        var statusBarStyle:UIStatusBarStyle = .default
        
        if let navigation = self.navigationController {
            statusBarStyle = navigation.preferredStatusBarStyle 
        }
        else {
            statusBarStyle = self.presentingViewController?.preferredStatusBarStyle ?? .default
        }
        
        if statusBarStyle == .lightContent {
            self.view.backgroundColor = .black
        }
        else {
            self.view.backgroundColor = .white
        }
    }
    
    

    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        
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
        self.isFinished = true
        self.ibDismiss(naviBarShow: willShowNavigationBarWhenDismiss)
    }
    
    
    func loadChatBotUrl() {
        if let url = URL.init(string: loadUrl) {
            isFirstLoadingFinish = false
            wkWebView.load(URLRequest.init(url: url))
//            wkWebView.load(URLRequest.init(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 15))
        }
    }
    
    
    func clearCache() {
        let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache])
        let date = Date(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: date, completionHandler:{ })
    }
}



extension IBWebViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("WebView-ScriptMessage : [name : \(message.name)], [body : \(message.body)]")
        
        if message.name == jsHandlerName {
            if let messageBody = message.body as? String {
                
                switch messageBody {
                case jsMethodClose:
                    self.isFinished = true
                    self.ibDismiss(naviBarShow: willShowNavigationBarWhenDismiss)
                    break
                    
                default:
                    break
                }
            }
            else if let dictionaryBody = message.body as? Dictionary<String, Any> {
                
                let action = dictionaryBody["action"] as? String ?? "";
                let body = dictionaryBody["body"] as? String ?? "";
                
                switch action {
                case jsMethodExcuteIBOTMessage:
                    callback?(body)
                    break
                    
                default:
                    break
                }
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
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let urlScheme = navigationAction.request.url?.scheme ?? ""
        if urlScheme == "tel" || urlScheme == "mailto" {
            UIApplication.shared.open(navigationAction.request.url!, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}


extension IBWebViewController: WKNavigationDelegate {    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("loading finish : \(webView.url?.absoluteString ?? "unknown url...")")
        
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
                
                if uid.isEmpty && !self.isFinished {
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
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "estimatedProgress") {
//            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            print(wkWebView.estimatedProgress)
        }
    }
}



extension IBWebViewController {
    
    func registKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unregistKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        adjustingHeight(show: true, notification: notification)
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        adjustingHeight(show: false, notification: notification)
    }
    
    func adjustingHeight(show:Bool, notification:NSNotification) {
        
        if #available(iOS 13.0, *) {
            self.wkWebView.scrollView.scrollRectToVisible(CGRect.init(x: self.wkWebView.scrollView.contentSize.width-1,
                                                                      y: self.wkWebView.scrollView.contentSize.height-1, 
                                                                      width: 1,
                                                                      height: 1),
                                                          animated: false)
        } else {
            let userInfo = notification.userInfo!
            let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as! UInt
            
            if(show) {
                let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
                let offset:CGFloat = self.view.safeAreaInsets.bottom
                let changeInHeight = (keyboardFrame.height-offset) * (show ? 1 : -1)
                
                UIView.animate(withDuration: animationDurarion, delay: 0.0, options: UIViewAnimationOptions(rawValue:curve), animations: { 
                    self.bottomMargin.constant = changeInHeight
                }) { (finish) in
                    if finish {
                        self.wkWebView.scrollView.scrollRectToVisible(CGRect.init(x: 0,
                                                                                  y: self.wkWebView.scrollView.contentSize.height-(self.wkWebView.frame.height), 
                                                                                  width: self.wkWebView.frame.width,
                                                                                  height: self.wkWebView.frame.height - changeInHeight),
                                                                      animated: false)
                    }
                }
            }
            else {
                UIView.animate(withDuration: animationDurarion, delay: 0.0, options: UIViewAnimationOptions(rawValue:curve), animations: { 
                    self.bottomMargin.constant = 0
                }) { (finish) in
                    if finish {
                        self.wkWebView.scrollView.scrollRectToVisible(CGRect.init(x: 0,
                                                                                  y: self.wkWebView.scrollView.contentSize.height-self.wkWebView.frame.height, 
                                                                                  width: self.wkWebView.frame.width,
                                                                                  height: self.wkWebView.frame.height),
                                                                      animated: false)
                    }
                }
            }
        }
        
    }
}

