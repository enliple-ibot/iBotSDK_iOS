//
//  IBotSDK.swift
//  iBotSDK
//
//  Created by enliple on 16/10/2019.
//


public typealias IBotSDKCallback = (_ messageInfo:String) -> Void


@objc public class IBotSDK: NSObject {
    
    @objc public static let shared: IBotSDK = IBotSDK()
     
    private var globalIbotButton:IBotChatButton? = nil
    
    
    /**
    아이봇 버튼을 생성하여 화면에 표시해 준다.
    
    - parameter in:  아이봇 버튼을 표시할 뷰
    - parameter apiKey:  어드민 페이지에서 발급 받은 apikey
    
    - returns 생성된 ibot 버튼을 반환 합니다.
    */
    @objc public func showIBotButton(in parent:UIView, apiKey:String, callback:IBotSDKCallback? = nil) -> IBotChatButton {
        let parentBound = parent.bounds
 
        var bottomPadding:CGFloat = 0.0
        
        if let window = UIApplication.shared.keyWindow {
            bottomPadding = window.safeAreaInsets.bottom
        } 
        else if UIApplication.shared.windows.count > 0 {
            bottomPadding = UIApplication.shared.windows[0].safeAreaInsets.bottom
        }
        
        let buttonSize:CGFloat = 70.0
        let button: IBotChatButton = IBotChatButton.init(frame: CGRect.init(x: parentBound.width - (buttonSize + 10.0),
                                                                            y: parentBound.height - (buttonSize + bottomPadding + 10.0),
                                                                            width: buttonSize,
                                                                            height: buttonSize))
        button.isUserInteractionEnabled = true
        IBotChatButton.isAnimated = false
        button.expandableViewShowing = true
        button.isShowing = false
        button.callback = callback
        
        
        parent.addSubview(button)
        
        button.apiKey = apiKey
        
        return button
    }
    
    
    /**
    아이봇 채팅창을 외부 브라우저를 통해서 열어 줍니다.
    
    - parameter apiKey: 어드민 페이지에서 발급 받은 apikey
    
    */
    @objc public func showChatbotInBrowser(apiKey:String) {
        
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
    
    
    /**
     아이봇 버튼을 사용하지 않고 직접 아이봇 채팅창을 열고자 할 때 사용. 
     
     - parameter parent: 아이봇 채팅창에 대한 부모 ViewController
     - parameter apiKey: 어드민 페이지에서 발급 받은 apikey
     - parameter openInModal: 부모뷰가 NavigationController를 사용하는지 여부에 상관없이 modal로 열고자 하는 경우 true로 설정하면 됩니다. 기본값은 false 입니다.
     
     */
    @objc public func showChatbot(parent:UIViewController, apiKey:String, openInModal:Bool = false, callback:IBotSDKCallback? = nil) {
        IBApi.shared.getIBotInfo(apiKey: apiKey, completionHandler: { (jsonDict, error) in
            if let json = jsonDict {
                let chatbotUrl = json["url"] as? String ?? ""
                
                if let _ = URL.init(string: chatbotUrl) {
                    IBApi.shared.checkIbotAlive(apiKey: apiKey) { (result, error) in
                        if let json = result, ((json["result"] as? String)?.uppercased() == "TRUE" || (json["result"] as? Bool) == true) {
                            
                            let showingUrl = chatbotUrl
                            
                            DispatchQueue.main.async {
                                let pVC = parent.navigationController ?? parent
                                let isPush = ((pVC is UINavigationController) && openInModal == false)
                                IBViewControllerPresenter.shared.showWebViewController(parent: pVC, url: showingUrl, isPush: isPush, callback: callback)
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
