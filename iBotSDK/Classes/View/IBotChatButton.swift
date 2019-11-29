//
//  IBotChatButton.swift
//
//  Created by Enliple on 26/09/2019.
//

import UIKit

@IBDesignable
public class IBotChatButton: UIView {
    
    fileprivate let IBOT_USERDEFAULT_BUTTON_MODIFYDATE_S = "IBOT_USERDEFAULT_BUTTON_MODIFYDATE_S"
    fileprivate let IBOT_USERDEFAULT_BUTTON_IMAGE_S = "IBOT_USERDEFAULT_BUTTON_IMAGE_S"
    fileprivate let IBOT_USERDEFAULT_NO_SHOW_MESSAGE_ENDDATE_L = "IBOT_USERDEFAULT_NO_SHOW_MESSAGE_ENDDATE_L"
    
    fileprivate let noShowTimeInterval = 3.0 * 24.0 * 3600.0
    
    private static var podsBundle: Bundle {
        let bundle = Bundle(for: IBotChatButton.self)
        if let url = bundle.url(forResource: "iBotSDK", withExtension: "bundle") {
            return Bundle(url: url)!
        }
        
        return bundle 
    }
    
     
    public var expandableViewShowing:Bool = true {
        didSet {
            IBotChatButton.isAnimated = IBotChatButton.isAnimated == false ? !expandableViewShowing : IBotChatButton.isAnimated
        }
    }
    
    
//    public var expandableViewBackgroundColor:UIColor = UIColor.init(r: 128, g: 70, b: 204) {
    public var expandableViewBackgroundColor:UIColor = UIColor.init(r: 41, g: 61, b: 124) {
        didSet {
            subMessageView.backgroundColor = expandableViewBackgroundColor
            floatButtonView.backgroundColor = expandableViewBackgroundColor
//            floatButtonView.backgroundColor = UIColor.init(r: 119, g: 88, b: 186)
        }
    }
    
    
    public var buttonImage:UIImage? = nil {
        didSet {
            if let _ = buttonImage {
                floatButtonView.image = buttonImage
                floatButtonView.contentMode = .scaleAspectFill
            }
        }
    }
    
    var isShowing:Bool = false {
        didSet {
            self.isHidden = !isShowing
            
            if isShowing {
                IBViewAnimation.shared.animate(with: self, type: animationType)
            }
        }
    }
    
    private var textColor:UIColor = .white {
        didSet {
            self.messageLabel.textColor = textColor
        }
    }
    
    private var message:String = "반갑습니다.\n인공지능 상담봇입니다." {
        didSet {
            self.messageLabel.text = message
        }
    }
    
    private var floatingType:String = "D"
    
    private var animationType:IBAnimationType = .slideLeftToRight
    
    open var openInModal:Bool = true
    open var canDrag:Bool = true
    
    public var apiKey:String = "" {
        didSet {
            if apiKey.isEmpty {
                chatbotUrl = ""
            }
            else {
                IBApi.shared.getIBotInfo(apiKey: apiKey, completionHandler: { (jsonDict, error) in
                    if let json = jsonDict {
                        print(json)
                        self.chatbotUrl = json["url"] as? String ?? ""
                        
                        let savedDt = UserDefaults.standard.string(forKey: self.IBOT_USERDEFAULT_BUTTON_MODIFYDATE_S)
                        
                        let modifyDt = json["modifyDt"] as? String ?? ""
                        let tTooltipFlag = json["tooltipFlag"] as? Bool ?? true
                        let tFloatingType = json["floatingType"] as? String ?? "D"
                        let tAnimationType = json["animationType"] as? String ?? ""
                        let tSlideColor = json["slideColor"] as? String ?? ""
                        let tTextColor = json["textColor"] as? String ?? ""
                        let tMsg = json["floatingMessage"] as? String ?? ""
                        var tFloatingImage = json["floatingImage"] as? String ?? ""
//                        let tFloatingImageThumbPath = json["floatingImageThumbPath"] as? String ?? ""
                        
                        DispatchQueue.main.async {
                            if !tMsg.isEmpty {
                                self.message = tMsg.replacingOccurrences(of: "<br/>", with: "\n")
                            }
                            
                            if !tTextColor.isEmpty {
                                self.textColor = UIColor.init(hexString: tTextColor.replacingOccurrences(of: "#", with: ""))
                            }
                            
                            if !tSlideColor.isEmpty {
                                self.expandableViewBackgroundColor = UIColor.init(hexString: tSlideColor.replacingOccurrences(of: "#", with: ""))
                            }
                            
                            self.animationType = IBAnimationType(rawValue: tAnimationType) ?? IBAnimationType.fadeIn
                            self.topBubbleView.isHidden = !tTooltipFlag
                            
                            if savedDt != modifyDt {
                                if !tFloatingImage.isEmpty {
                                    if tFloatingImage.contains(".gif") {
                                        let gifImage = UIImage.gifImageWithURL(tFloatingImage)
                                        DispatchQueue.main.async {
                                            self.buttonImage = gifImage
                                            self.isShowing = !self.chatbotUrl.isEmpty
                                        }
                                    }
                                    else {
                                        IBApi.shared.downloadButtonImage(apiKey: self.apiKey, imageUrl: tFloatingImage) { (response, error) in
                                            if let result = response, (result["result"] as? String ?? "") == "success" {
                                                let imageFilePath = IBApi.shared.getButtonImageFilePath(apiKey: self.apiKey)
                                                
                                                DispatchQueue.main.async {
                                                    do {
                                                        let imageData = try Data.init(contentsOf: imageFilePath)
                                                        self.buttonImage = UIImage.init(data: imageData)
                                                    }
                                                    catch {}
                                                    
                                                    self.isShowing = !self.chatbotUrl.isEmpty
                                                }
                                            }
                                        }
                                    }
                                    
                                }
                                else {
                                    self.isShowing = !self.chatbotUrl.isEmpty
                                }
                                
                                UserDefaults.standard.set(tFloatingImage, forKey: self.IBOT_USERDEFAULT_BUTTON_IMAGE_S)
                                UserDefaults.standard.set(modifyDt, forKey: self.IBOT_USERDEFAULT_BUTTON_MODIFYDATE_S)
                            }
                            else {
                                let imageUrl = UserDefaults.standard.string(forKey: self.IBOT_USERDEFAULT_BUTTON_IMAGE_S)
                                
                                if (imageUrl?.isEmpty ?? true) {
                                    self.loadDefaultImage()
                                }
                                else {
                                    do {
                                        let imageData = try Data.init(contentsOf: IBApi.shared.getButtonImageFilePath(apiKey: self.apiKey))
                                        self.buttonImage = UIImage.init(data: imageData)
                                    }
                                    catch {
                                        self.loadDefaultImage()
                                    }
                                }
                                
                                self.isShowing = !self.chatbotUrl.isEmpty
                            }
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            self.isShowing = false
                        }
                    }
                }) 
            }
        }
    }
    
    fileprivate var chatbotUrl:String = ""
    
    
    
    override public var isHidden: Bool {
        didSet {
            if !isShowing && isHidden == false {
                self.isHidden = true
            }
        }
    }
    
    
    
    private var floatButtonView: UIImageView = UIImageView.init(frame: .zero)
    private var topBubbleView: UIImageView = UIImageView.init(frame: .zero)
    private var subMessageView: UIView = UIView.init(frame: .zero)
    private var messageLabel: UILabel = UILabel.init(frame: .zero)
    private var closeButton: UIButton = UIButton.init(frame: .zero)
    
    private var buttonShadowView: UIView = UIView.init(frame: .zero)
    private var rootViewShadow: UIView = UIView.init(frame: .zero)
    
    public static var isAnimated:Bool = false
    private var maximumWidth:CGFloat = 200.0
    
    private var isLeftSide:Bool = false
    
    private var defalutFrame:CGRect = .zero
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
        
        self.floatButtonView.prepareForInterfaceBuilder()
        self.subMessageView.prepareForInterfaceBuilder()
    }
    
    deinit {
    }
    
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if !IBotChatButton.isAnimated {
            IBotChatButton.isAnimated = true
            
            isLeftSide = self.frame.midX < UIScreen.main.bounds.midX
            calcMaximumWidth(isInLeftSide: isLeftSide)
            
            if isLeftSide {
                closeButton.frame = CGRect.init(x: maximumWidth - 35, y: 0, width: 30, height: subMessageView.frame.height)
                messageLabel.frame = CGRect.init(x: self.bounds.width + 5, y: 0, width: maximumWidth - (self.bounds.width + 10 + closeButton.frame.width + 5), height: subMessageView.frame.height)
            }
            else {
                closeButton.frame = CGRect.init(x: 5, y: 0, width: 30, height: subMessageView.frame.height)
                messageLabel.frame = CGRect.init(x: 40, y: 0, width: maximumWidth - (self.bounds.width + 10 + closeButton.frame.width + 5), height: subMessageView.frame.height)
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0) {
                self.subMessageView.alpha = 0.0
                self.showSubMessageView()
            }
        }
        
    }
    
    
    public override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        if newWindow == nil {
            print("chatbot disappear")
        } else {
            print("chatbot appear")
            IBApi.shared.checkIbotAlive(apiKey: apiKey) { (json, error) in }
        }
    }
    
    public override func didMoveToWindow() {
        super.didMoveToWindow()
        
        let isHide = isHidden
        self.isHidden = isHide
    }
    
    private func commonInit() {
        defalutFrame = self.frame
        
        IBotChatButton.isAnimated = IBotChatButton.isAnimated == false ? !expandableViewShowing : IBotChatButton.isAnimated
        
        self.backgroundColor = .clear
        self.layer.masksToBounds = false
        self.clipsToBounds = false
        
        buttonShadowView.isUserInteractionEnabled = true
        buttonShadowView.backgroundColor = .clear
        buttonShadowView.addSubview(floatButtonView)
        buttonShadowView.addSubview(topBubbleView)
        
        rootViewShadow.isUserInteractionEnabled = true
        rootViewShadow.backgroundColor = .clear
        rootViewShadow.addSubview(subMessageView)
        rootViewShadow.addSubview(buttonShadowView)
        
        self.addSubview(rootViewShadow)
        
        subMessageView.frame = CGRect.init(x: 0, y: self.frame.height*0.1, width: self.frame.width, height: self.frame.height*0.8)
        subMessageView.backgroundColor = expandableViewBackgroundColor
        subMessageView.layer.masksToBounds = true
        subMessageView.layer.cornerRadius = subMessageView.frame.height / 2.0
        
        floatButtonView.frame = self.bounds
        floatButtonView.layer.masksToBounds = true
        floatButtonView.layer.cornerRadius = (self.bounds.height < self.bounds.width ? self.bounds.height : self.bounds.width) / 2.0
        
        let bubbleWidth = (floatButtonView.frame.width * 95.0) / 141.0
        let bubbleHeight = bubbleWidth * (76.0 / 83.0)
        topBubbleView.frame = CGRect.init(x: (floatButtonView.frame.width - bubbleWidth) / 2.0, y: -0.3 * bubbleHeight, width: bubbleWidth, height: bubbleHeight)
        topBubbleView.image = UIImage.init(named: "top_bubble", in: IBotChatButton.podsBundle, compatibleWith: nil)
        topBubbleView.contentMode = .scaleAspectFit

        rootViewShadow.layer.shadowColor = UIColor.init(r: 68, g: 68, b: 68, a:80).cgColor
        rootViewShadow.layer.shadowOpacity = 1.0
        rootViewShadow.layer.shadowOffset = CGSize(width: 0, height: 10)
        rootViewShadow.layer.shadowRadius = 14.1 / 2.0
        rootViewShadow.layer.shadowPath = nil
        
        loadDefaultImage()
        if buttonImage != nil && buttonImage!.size != .zero {
            floatButtonView.image = buttonImage
            floatButtonView.contentMode = .scaleAspectFit
        } 
        
//        setUpCloseButtonImage()
//        closeButton.isUserInteractionEnabled = true
//        closeButton.backgroundColor = .clear
//        closeButton.addTarget(self, action: #selector(closeButtonClicked), for: .touchUpInside)
        
        messageLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 2
        messageLabel.text = message
        
        subMessageView.addSubview(messageLabel)
//        subMessageView.addSubview(closeButton)
        
        updateTouchEvent()
    }
    
    open func updateTouchEvent() {
        floatButtonView.isUserInteractionEnabled = true
        floatButtonView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(excuteTapGesture(gesture:))))
        floatButtonView.addGestureRecognizer(UIPanGestureRecognizer.init(target: self, action: #selector(excutePanGesture(gesture:))))
    }
    
    func loadDefaultImage() {
        if buttonImage == nil || buttonImage!.size == .zero {
//            buttonImage = UIImage.init(named: "showbot_icon", in: IBotChatButton.podsBundle, compatibleWith: nil)
            buttonImage = UIImage.init(named: "bot", in: IBotChatButton.podsBundle, compatibleWith: nil)
        }
    }
    
    func setUpCloseButtonImage() {
        closeButton.setImage(UIImage.init(named: "closeWhiteIco", in: IBotChatButton.podsBundle, compatibleWith: nil),
                             for: .normal)
    }
    
    func calcMaximumWidth(isInLeftSide:Bool) {
        let mainBounds = UIScreen.main.bounds
        if isInLeftSide {
            let margin = self.frame.origin.x 
            maximumWidth = mainBounds.width - (margin * 2)
        }
        else {
            let margin = mainBounds.width - (self.frame.origin.x + self.frame.width) 
            maximumWidth = mainBounds.width - (margin * 2)
        }
    }
    
    
    @objc func closeButtonClicked() {
        if self.subMessageView.alpha >= 1.0 {
            hideSubMessageView()
        }
        
        UserDefaults.standard.set(Date().timeIntervalSince1970 + noShowTimeInterval, forKey: IBOT_USERDEFAULT_NO_SHOW_MESSAGE_ENDDATE_L)
    }
    
    
    @objc func excuteTapGesture(gesture:UITapGestureRecognizer) {

        if gesture.view == floatButtonView {
            if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
                
                IBApi.shared.checkIbotAlive(apiKey: apiKey) { (result, error) in
                    if let json = result, ((json["result"] as? String)?.uppercased() == "TRUE" || (json["result"] as? Bool) == true) {
                        
                        let showingUrl = self.chatbotUrl
                        
                        DispatchQueue.main.async {
                            self.subMessageView.alpha = 0.0
                            
                            if (rootViewController is UINavigationController) && self.openInModal == false {
                                IBViewControllerPresenter.shared.showWebViewController(parent: rootViewController, url: showingUrl, isPush: true)
                            }
                            else {
                                IBViewControllerPresenter.shared.showWebViewController(parent: rootViewController, url: showingUrl)
                            }
                        }
                        
                    }
                }
                
            }
        }
    }
    
    @objc func excutePanGesture(gesture:UIPanGestureRecognizer) {
        
        if let parent = self.superview, canDrag == true {
            let translation = gesture.translation(in: parent)
            
            var movedCenterY = self.center.y + translation.y
            if movedCenterY > (parent.frame.height - self.frame.height / 2.0) - 10 {
               movedCenterY = (parent.frame.height - self.frame.height / 2.0) - 10
            }
            else if movedCenterY < (self.frame.height / 2.0 + 10) {
               movedCenterY = (self.frame.height / 2.0) + 10 
            }
            
            self.center = CGPoint(x: self.center.x, y: movedCenterY)
            gesture.setTranslation(CGPoint.zero, in: parent)
        }
        
    }
    
    
    
    public func showSubMessageView() {
        
        if UserDefaults.standard.double(forKey: IBOT_USERDEFAULT_NO_SHOW_MESSAGE_ENDDATE_L) > Date().timeIntervalSince1970 {
            return
        }
        if subMessageView.alpha > 0.0 {
            return
        }
        
        defalutFrame = self.frame        
        subMessageView.alpha = 0.0
        
        self.frame = defalutFrame
        rootViewShadow.frame = self.bounds
        subMessageView.frame = CGRect.init(x: 0, y: self.frame.height*0.1, width: self.frame.width, height: self.frame.height*0.8)
        buttonShadowView.frame = self.bounds

        UIView.animate(withDuration: 1.0, delay: 0.0, animations: { 
            self.subMessageView.alpha = 1.0
            
            if self.isLeftSide {
                self.frame = CGRect.init(x:self.frame.origin.x , y: self.frame.origin.y, width: self.maximumWidth, height: self.frame.height)
                self.rootViewShadow.frame = self.bounds
                self.subMessageView.frame = CGRect.init(x: 0, y: self.frame.height*0.1, width: self.maximumWidth, height: self.frame.height*0.8)
                
            }
            else {
                self.frame = CGRect.init(x:(self.frame.origin.x + self.frame.width)-self.maximumWidth , y: self.frame.origin.y, width: self.maximumWidth, height: self.frame.height)
                self.rootViewShadow.frame = self.bounds
                self.subMessageView.frame = CGRect.init(x: 0, y: self.frame.height*0.1, width: self.maximumWidth, height: self.frame.height*0.8)
                self.buttonShadowView.frame = CGRect.init(x:self.maximumWidth-self.buttonShadowView.frame.width,
                                                          y: 0, 
                                                          width: self.buttonShadowView.frame.width, 
                                                          height: self.frame.height)
            }
            
            self.setNeedsDisplay()
        }) { (finish) in
             if finish {
                Timer.scheduledTimer(withTimeInterval: 6.0, repeats: false) { (t2) in
                    self.hideSubMessageView()
                }
            }
        }
        
    }
    
    public func hideSubMessageView() {
        if subMessageView.alpha <= 0.0 {
            return
        }
        
        subMessageView.alpha = 1.0
        if self.isLeftSide {
            self.frame = CGRect.init(x: self.frame.origin.x, y: self.frame.origin.y, width: self.maximumWidth, height: self.frame.height)
            rootViewShadow.frame = self.bounds
            self.subMessageView.frame = CGRect.init(x: 0, y: self.frame.height*0.1, width: self.maximumWidth, height: self.frame.height*0.8)
            self.buttonShadowView.frame = CGRect.init(x:0,
                                                      y: 0, 
                                                      width: self.buttonShadowView.frame.width, 
                                                      height: self.frame.height)
        }
        else {
            self.frame = CGRect.init(x:(self.frame.origin.x + self.frame.width)-self.maximumWidth , y: self.frame.origin.y, width: self.maximumWidth, height: self.frame.height)
            rootViewShadow.frame = self.bounds
            self.subMessageView.frame = CGRect.init(x: 0, y: self.frame.height*0.1, width: self.maximumWidth, height: self.frame.height*0.8)
            self.buttonShadowView.frame = CGRect.init(x:self.maximumWidth-self.buttonShadowView.frame.width,
                                                      y: 0, 
                                                      width: self.buttonShadowView.frame.width, 
                                                      height: self.frame.height)
        }
        
        
        UIView.animate(withDuration: 1.0, delay: 0.0, animations: {
            self.subMessageView.alpha = 0.0
            
            self.frame = self.defalutFrame
            self.rootViewShadow.frame = self.bounds
            self.subMessageView.frame = CGRect.init(x: 0, y: self.frame.height*0.1, width: self.frame.width, height: self.frame.height*0.8)
            self.buttonShadowView.frame = self.bounds
        }) { (finish) in
        }
    }
    
}
