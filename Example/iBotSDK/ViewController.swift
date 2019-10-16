//
//  ViewController.swift
//  iBotSDK
//
//  Created by Enliple on 10/15/2019.
//  Copyright (c) 2019 Enliple. All rights reserved.
//

import UIKit
import WebKit

import iBotSDK

class ViewController: UIViewController {

    @IBOutlet weak var wkWebView: WKWebView!
    @IBOutlet weak var chatbotButton: IBotChatButton!
    
    
    let subWebView = WKWebView()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IBotSDK.shared.setUp(apiKey: "1")
        
        
        wkWebView.enableConsoleLog()
        wkWebView.customUserAgent = "android"
        
        let siteUrl:String = "https://mobon.net/main/m2/"

        if let url = URL(string: siteUrl) {
            wkWebView.load(URLRequest.init(url: url))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    func checkWebKitInnerHeight() {
        wkWebView.evaluateJavaScript("window.innerHeight") { (result, error) in
            if let result = result {
                print("innerHeight : \(result)")
            }
        }
        
        wkWebView.evaluateJavaScript("document.documentElement.clientHeight") { (result, error) in
            if let result = result {
                print("clientHeight : \(result)")
            }
        }
        
        wkWebView.evaluateJavaScript("document.body.scrollHeight") { (result, error) in
            if let result = result {
                print("body.scrollHeight : \(result)")
            }
        }
        
        wkWebView.evaluateJavaScript("document.body.clientHeight") { (result, error) in
            if let result = result {
                print("body.clientHeight : \(result)")
            }
        }
        
        wkWebView.evaluateJavaScript("window.screen.height") { (result, error) in
            if let result = result {
                print("screen.height : \(result)")
            }
        }
        
        
        
        
    }
}



extension WKWebView: WKScriptMessageHandler {

    /// enabling console.log
    public func enableConsoleLog() {

        //    set message handler
        configuration.userContentController.add(self, name: "logging")

        //    override console.log
        let _override = WKUserScript(source: "var console = { log: function(msg){window.webkit.messageHandlers.logging.postMessage(msg) }};", injectionTime: .atDocumentStart, forMainFrameOnly: false)
        
        configuration.userContentController.addUserScript(_override)
    }

    /// message handler
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("WebView: ", message.body)
    }
}


extension ViewController: WKNavigationDelegate {
 
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if webView == subWebView {
            self.subWebView.evaluateJavaScript("document.readyState") { (complete, error) in
                if complete != nil {
                    self.subWebView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                        let webViewHeight = height as! CGFloat
                        self.subWebView.frame.size.height = webViewHeight
                    })
                }
            }
        }
        
    }
    
}

