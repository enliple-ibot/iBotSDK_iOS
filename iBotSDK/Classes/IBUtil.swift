//
//  IBUtil.swift
//  iBotSDK
//
//  Created by enliple on 23/10/2019.
//

import Foundation

class IBUtil {
    static let shared:IBUtil = IBUtil()
    
    var getUUID:String {
        return UUID.init().uuidString
    }
    
    var OSVersion:String {
        return UIDevice.current.systemVersion
    }
    
    var OSType:String {
        return UIDevice.current.systemName
    }
    
    var sdkVersion:String {
        return Bundle(for: IBUtil.self).object(forInfoDictionaryKey: "CFBundleShortVersionString" as String) as? String ?? "unknown"
    }
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        if identifier == "i386" || identifier == "x86_64" {
            return "Simulator"
        }
        else {
            return identifier
        }
    }
    
}
