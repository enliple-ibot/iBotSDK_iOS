//
//  IBotSDK.swift
//  iBotSDK
//
//  Created by enliple on 16/10/2019.
//

import Foundation
import AdSupport


public class IBotSDK {
    
    public static let shared: IBotSDK = IBotSDK()
    
    private var globalIbotButton:IBotChatButton? = nil
    
    
    public func showIBotButton(in parent:UIView, apiKey:String) -> IBotChatButton {
        let parentBound = parent.bounds
 
        var bottomPadding:CGFloat = 0.0
        
        if let window = UIApplication.shared.keyWindow {
            bottomPadding = window.safeAreaInsets.bottom
        }
        else if UIApplication.shared.windows.count > 0 {
            bottomPadding = UIApplication.shared.windows[0].safeAreaInsets.bottom
        }
        
        let buttonSize:CGFloat = 60.0
        let button: IBotChatButton = IBotChatButton.init(frame: CGRect.init(x: parentBound.width - (buttonSize + 10.0),
                                                                            y: parentBound.height - (buttonSize + bottomPadding + 10.0),
                                                                            width: buttonSize,
                                                                            height: buttonSize))
        button.isUserInteractionEnabled = true
        IBotChatButton.isAnimated = false
        button.expandableViewShowing = true
        button.isShowing = false
        
        parent.addSubview(button)
        
        button.apiKey = apiKey
        
        return button
    }
    
    
    public func showChatbotInBrowser(apiKey:String) {
        
        IBApi.shared.getIBotInfo(apiKey: apiKey, completionHandler: { (jsonDict, error) in
            if let json = jsonDict {
                let chatbotUrl = json["url"] as? String ?? ""
                
                if let urls = URL.init(string: chatbotUrl) {
                    IBApi.shared.checkIbotAlive(apiKey: apiKey) { (result, error) in
                        DispatchQueue.main.async {
                            if let json = result, ((json["result"] as? String)?.uppercased() == "TRUE" || (json["result"] as? Bool) == true) {
                                UIApplication.shared.open(urls, options: [:], completionHandler: nil)
                            }
                        }
                    }
                }
            }
            else {

            }
        })
    }
    
    
}
