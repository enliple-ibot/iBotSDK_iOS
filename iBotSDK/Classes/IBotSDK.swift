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
}
