//
//  IBotChatButtonManager.swift
//  iBotSDK
//
//  Created by enliple on 25/10/2019.
//

import Foundation


class IBotChatButtonManager {
    
    public static var shared:IBotChatButtonManager = IBotChatButtonManager()
    
    var iBotButtons:[IBotChatButton] = []
    var isInitFinish:Bool = false
    
    func add(button:IBotChatButton) {
        if !iBotButtons.contains(button) {
            button.isShowing = isInitFinish
            iBotButtons.append(button)
        }
    }
    
    
    func remove(button:IBotChatButton) {
        iBotButtons.removeAll { (item) -> Bool in
            return button == item
        }
    }
    
    func finishSDKInit(initSuccess:Bool) {
        isInitFinish = initSuccess
        for button in iBotButtons {
            button.isShowing = isInitFinish
        }
    }
    
    func updateButtons() {
        
    }
    
}
