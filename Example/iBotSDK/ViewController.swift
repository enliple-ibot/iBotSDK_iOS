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
    
    private var apiKey:String = "2"
//    private var apiKey:String = "205"
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let siteUrl:String = "https://mobon.net/main/m2/"
        
        if let url = URL(string: siteUrl) {
            wkWebView.load(URLRequest.init(url: url))
        }
        
        let button = IBotSDK.shared.showIBotButton(in: self.view, apiKey:apiKey)
        button.isHidden = false
        
        
        let button2 = IBotSDK.shared.showIBotButton(in: self.view, apiKey:apiKey)
        button2.isHidden = false
        button2.frame.origin.y = button2.frame.origin.y - 100
        button2.openInModal = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    @IBAction func buttonClicked(_ sender: Any) {
        IBotSDK.shared.showChatbotInBrowser(apiKey:apiKey)
    }
    
}



