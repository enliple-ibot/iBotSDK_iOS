//
//  IBotSDK.swift
//  iBotSDK
//
//  Created by enliple on 16/10/2019.
//

import Foundation



public class IBotSDK {
    
    public static let shared: IBotSDK = IBotSDK()
    
    public var apiKey:String = ""
    
    
    
    public func setUp(apiKey:String) {
        self.apiKey = apiKey
    }
    
    
    func getChatBotUrl() -> String? {
        if apiKey.isEmpty {
            return nil
        }
        else {
            return "https://bot.istore.camp/index.html?mallId=\(apiKey)"
        }
    }
    
    
    public func showIBotButton(in parent:UIView) -> IBotChatButton {
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
        button.buttonBorderColor = .white
        button.expandableViewShowing = true
        button.isShowing = true
        
        parent.addSubview(button)
        
        
        return button
    }
}
