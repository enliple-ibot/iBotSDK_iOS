//
//  IBWebViewController.swift
//  iBotSDK
//
//  Created by Enliple on 17/09/2019.
//

import UIKit
import WebKit

class IBWebViewController: UIViewController {

    private let jsHandlerName:String = "iBotAppHandler"
    private let jsMethodClose:String = "onAppViewClose"
    
    
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
    
    var loadUrl:String = ""
    
    @IBOutlet fileprivate weak var wkWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let userContentController:WKUserContentController = WKUserContentController()
        userContentController.add(self, name: jsHandlerName)
        wkWebView.configuration.userContentController = userContentController
        
        if let url = URL.init(string: loadUrl) {
            wkWebView.load(URLRequest.init(url: url))
        }
    }

    
    @IBAction func clickedBackButton(_ sender: Any) {
        self.hlDismiss()
    }
    
}


extension IBWebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == jsHandlerName {
            let messageBody = message.body as! String
            print("message body : \(messageBody)")
            
            if message.body as! String == jsMethodClose {
                self.hlDismiss()
            }
        }
    }
}
