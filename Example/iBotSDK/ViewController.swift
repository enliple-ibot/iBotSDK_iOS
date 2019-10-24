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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let siteUrl:String = "https://mobon.net/main/m2/"
        

        if let url = URL(string: siteUrl) {
            wkWebView.load(URLRequest.init(url: url))
        }
        
        
        IBotSDK.shared.setUp(apiKey: "205")
//        IBotSDK.shared.setUp(apiKey: "1")
        
        let button = IBotSDK.shared.showIBotButton(in: self.view)
        button.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
}



