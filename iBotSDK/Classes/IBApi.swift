//
//  IBApi.swift
//  iBotSDK
//
//  Created by Enliple on 18/10/2019.
//

import Foundation

typealias IBApiCallback = (_ result:[String: Any]?, _ error:Error?) -> Void

class IBApi {
    let timeOutInterval:TimeInterval = 15
    
    let HOST = "https://chatapi.istore.camp"
    
    let API_SDK_INIT = "/chat/initSdk"
    let API_CHECK_ISALIVE = "/chat/isAlivePackage"
    let API_SEND_DEVICEINFO = "/chat/chatSdkLog"
    
    
    public static let shared: IBApi = IBApi()
    
    
    func sendPostRequest(apiUrl:String, params:[String: Any]?, completionHandler:@escaping IBApiCallback) {
        do {
            var requestParams:[String: Any]? = params
            if requestParams == nil {
                requestParams = [:]
            }
            let requestObject = try JSONSerialization.data(withJSONObject: requestParams!)

            var request = URLRequest(url: URL(string: apiUrl)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: timeOutInterval)

            request.httpBody = requestObject
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")

            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data, error == nil else {
                    completionHandler(nil, error)
                    return
                }

                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    completionHandler(json as? [String : Any], nil)
                }
                catch {
                    completionHandler(nil, NSError.init())
                }
            }
            task.resume()
            
        } catch {
            completionHandler(nil, error)
        }
    }
    
    func sendGetRequest(apiUrl:String, params:[String: Any]?, completionHandler:@escaping IBApiCallback) {
        var requestParams:[String: Any]? = params
        if requestParams == nil {
            requestParams = [:]
        }
        
        var paramString = ""
        for key in requestParams!.keys {
            
            if let value = requestParams![key] {
                paramString = paramString.appending("\(key)=\(value)&")
            }
        }
        if paramString.count > 0 {
            paramString.removeLast()
        }
        
        
        var realUrl = apiUrl
        if !paramString.isEmpty {
            realUrl = "\(apiUrl)?\(paramString)"
        }
        

        var request = URLRequest(url: URL(string: realUrl)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: timeOutInterval)

        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completionHandler(nil, error)
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                completionHandler(json as? [String : Any], nil)
            }
            catch {
                completionHandler(["result" : String.init(data: data, encoding: .utf8) as Any], NSError.init())
            }
        }
        task.resume()
    }
    
    
    
    func getIBotInfo(apiKey:String, completionHandler:@escaping IBApiCallback) {
        let param = [
            "apiKey" : apiKey,
            "uuid" : IBUtil.shared.getUUID,
            "sdk_version" : IBUtil.shared.sdkVersion,
            "os_version" : IBUtil.shared.OSVersion,
            "bundleId" : IBUtil.shared.bundleID
        ]
        
        sendGetRequest(apiUrl: HOST + API_SDK_INIT, params: param, completionHandler: completionHandler)
    }
    
    
    func checkIbotAlive(apiKey:String, completionHandler:@escaping IBApiCallback) {
        sendGetRequest(apiUrl: HOST + API_CHECK_ISALIVE, params: ["apiKey" : apiKey], completionHandler: completionHandler)
    }
    
    func sendDeviceInfo(uid:String, completionHandler:@escaping IBApiCallback) {
        let data = [
            "uuid" : IBUtil.shared.getUUID,
            "os_version" : IBUtil.shared.OSVersion,
            "os_type" : IBUtil.shared.OSType,
            "sdk_version" : IBUtil.shared.sdkVersion,
            "device" : IBUtil.shared.modelName
        ]
        
        let params:[String: Any] = [
            "uid" : uid,
            "data" : data
        ]
        
        sendPostRequest(apiUrl: HOST + API_SEND_DEVICEINFO, params: params, completionHandler: completionHandler)
    }
    
    
    func downloadButtonImage(apiKey:String, imageUrl:String, completionHandler:@escaping IBApiCallback) {
        if let url = URL(string: imageUrl) {
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig)
            var request = URLRequest.init(url: url)
            request.httpMethod = "GET"
            
            let task = session.dataTask(with: request) { (data, response, error) in
                if (error == nil) {
                    let dirPath = self.getButtonImageDirectoryPath(apiKey: apiKey)
                    let filePath = self.getButtonImageFilePath(apiKey: apiKey)
                    
                    do {
                        if !FileManager.default.fileExists(atPath: dirPath.absoluteString) {
                            try FileManager.default.createDirectory(at: dirPath, withIntermediateDirectories: true, attributes: nil)
                        }
                        
                        if let data = data {
                            try data.write(to: filePath)
                            completionHandler(["result" : "success"], NSError.init())
                        }
                        else {
                            completionHandler(nil, error)
                        }
                    }
                    catch {
                        completionHandler(nil, error)
                    }
                }
                else {
                    // Failure
                    completionHandler(nil, error)
                }
            }
            
            task.resume()
        }
        else {
            completionHandler(nil, NSError.init())
        }
        
    }
    
    
    func getButtonImageDirectoryPath(apiKey:String) -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("iBotResource")
        
    }
    
    func getButtonImageFilePath(apiKey:String) -> URL {
        return getButtonImageDirectoryPath(apiKey: apiKey).appendingPathComponent("button_\(apiKey).png")
    }
}

