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
    
    let HOST = "http://scm-enliple.iptime.org:8880"
    
    let API_CHECK_ISALIVE = "/chat/isAlivePackage"
    
    
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
        do {
            var requestParams:[String: Any]? = params
            if requestParams == nil {
                requestParams = [:]
            }
            
            var paramString = ""
            for key in requestParams!.keys {
                
                if let value = requestParams![key] {
                    paramString = paramString.appending("\(key)=\(value)")    
                }
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
            
        } catch {
            completionHandler(nil, error)
        }
    }
    
    
    
    func getIBotInfo(completionHandler:@escaping IBApiCallback) {
//        let params = [
//            "email":""
//        ]
//
//        let requestParams: [String: Any] = [
//            "action": "601",
//            "params": params
//        ]

        sendPostRequest(apiUrl: "https://api.puddinglive.com:8080/v1/config", params: nil, completionHandler: completionHandler)
    }
    
    
    func checkIbotAlive(mallId:String, completionHandler:@escaping IBApiCallback) {
        
        sendGetRequest(apiUrl: HOST + API_CHECK_ISALIVE, params: ["mallId" : mallId], completionHandler: completionHandler)
    }
}
