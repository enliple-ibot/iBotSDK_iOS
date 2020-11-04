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
    
    private var apiKey:String = "2"
    
    @IBOutlet weak var openTypeSegment: UISegmentedControl!
    @IBOutlet weak var positionSegment: UISegmentedControl!
    @IBOutlet weak var dragSegment: UISegmentedControl!
    
    var chatButton:UIView? = nil
    
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    
    
    @IBAction func generatorButtonClicked(_ sender: Any) {
        
        if let button = chatButton {
            button.removeFromSuperview()
            chatButton = nil
        }
        
        let position = positionSegment.selectedSegmentIndex
        let openType = openTypeSegment.selectedSegmentIndex
        
        if openType == 2 {
            chatButton = makeCustomButton()
        }
        else if openType == 3 {
            chatButton = makeDirectButton()
        }
        else {
            let button = IBotSDK.shared.showIBotButton(in: self.view, apiKey: apiKey)
            if openType == 1 {
                button.openInModal = false
            }
            button.canDrag = (dragSegment.selectedSegmentIndex == 1)
            if button.canDrag {
                button.canDragX = true
            }
            
            chatButton = button
        }
        
        
        if position == 1 {      // middle
            chatButton!.center = CGPoint.init(x: self.view.bounds.width / 2.0,
                                              y: chatButton!.frame.origin.y + (chatButton!.frame.size.height / 2.0) )
            
        }
        else if position == 2 {     //left
            chatButton!.frame = CGRect.init(x: 10.0,
                                            y: chatButton!.frame.origin.y, 
                                            width: chatButton!.frame.size.width, 
                                            height: chatButton!.frame.size.height)
        }
        
        
        if let button = chatButton {
            button.removeFromSuperview()
            self.view.addSubview(button)
        }
    }
    
    
    func makeCustomButton() -> UIButton {
        let parentBound = self.view.bounds
        
        var bottomPadding:CGFloat = 0.0
        
        if let window = UIApplication.shared.keyWindow {
            bottomPadding = window.safeAreaInsets.bottom
        }
        else if UIApplication.shared.windows.count > 0 {
            bottomPadding = UIApplication.shared.windows[0].safeAreaInsets.bottom
        }
        
        let buttonSize:CGFloat = 60.0
        let button = UIButton.init(frame: CGRect.init(x: parentBound.width - (buttonSize + 10.0),
                                                      y: parentBound.height - (buttonSize + bottomPadding + 10.0),
                                                      width: buttonSize,
                                                      height: buttonSize))
        button.setTitle("웹으로보기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        button.backgroundColor = .cyan
        button.layer.cornerRadius = buttonSize / 2.0
        button.layer.masksToBounds = true
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(openBrowserButtonClicked), for: .touchUpInside)
         
        return button   
    }
    
    @objc func openBrowserButtonClicked() {
        IBotSDK.shared.showChatbotInBrowser(apiKey: apiKey)
    }
    
    
    
    func makeDirectButton() -> UIButton {
        let parentBound = self.view.bounds
        
        var bottomPadding:CGFloat = 0.0
        
        if let window = UIApplication.shared.keyWindow {
            bottomPadding = window.safeAreaInsets.bottom
        }
        else if UIApplication.shared.windows.count > 0 {
            bottomPadding = UIApplication.shared.windows[0].safeAreaInsets.bottom
        }
        
        let buttonSize:CGFloat = 60.0
        let button = UIButton.init(frame: CGRect.init(x: parentBound.width - (buttonSize + 10.0),
                                                      y: parentBound.height - (buttonSize + bottomPadding + 10.0),
                                                      width: buttonSize,
                                                      height: buttonSize))
        
        button.setTitle("바로보기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        
        button.backgroundColor = .blue
        button.layer.cornerRadius = buttonSize / 2.0
        button.layer.masksToBounds = true
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(openDirectly), for: .touchUpInside)
         
        return button   
    }
    
    
    @objc func openDirectly(_ sender: Any) {
        IBotSDK.shared.showChatbot(parent: self, apiKey: apiKey, openInModal: false)
    }
}



