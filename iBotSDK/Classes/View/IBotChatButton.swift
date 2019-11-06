//
//  IBotChatButton.swift
//
//  Created by Enliple on 26/09/2019.
//

import UIKit

@IBDesignable
public class IBotChatButton: UIView {
    
    private static var podsBundle: Bundle {
        let bundle = Bundle(for: IBotChatButton.self)
        if let url = bundle.url(forResource: "iBotSDK", withExtension: "bundle") {
            return Bundle(url: url)!
        }
        
        return bundle 
    }
    
    
    
    
//    @IBInspectable 
    public var expandableViewShowing:Bool = true {
        didSet {
            isAnimated = !expandableViewShowing
        }
    }
    
    
//    @IBInspectable
    public var expandableViewBackgroundColor:UIColor = UIColor.init(r: 128, g: 70, b: 204) {
        didSet {
            subMessageView.backgroundColor = expandableViewBackgroundColor
        }
    }
    
    
//    @IBInspectable
    public var buttonImage:UIImage? = nil {
        didSet {
            if let _ = buttonImage {
                floatButtonView.image = buttonImage
                floatButtonView.contentMode = .scaleAspectFit
            }
        }
    }
    
    var isShowing:Bool = true {
        didSet {
            self.isHidden = !isShowing
        }
    }
    
    
    open var openInModal:Bool = true
    
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
                        
                        DispatchQueue.main.async {
                            self.isShowing = !self.chatbotUrl.isEmpty
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
    private var subMessageView: UIView = UIView.init(frame: .zero)
    private var messageLabel: UILabel = UILabel.init(frame: .zero)
    private var closeButton: UIButton = UIButton.init(frame: .zero)
    
    private var isAnimated:Bool = false
    private var maximumWidth:CGFloat = 200.0
    
    private var isLeftSide:Bool = false
    
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
        
        if !isAnimated {
            isAnimated = true
            isLeftSide = self.frame.midX < UIScreen.main.bounds.midX
            calcMaximumWidth(isInLeftSide: isLeftSide)
            
            if isLeftSide {
                closeButton.frame = CGRect.init(x: maximumWidth - 35, y: 0, width: 30, height: self.bounds.height)
                messageLabel.frame = CGRect.init(x: self.bounds.width + 5, y: 0, width: maximumWidth - (self.bounds.width + 10 + closeButton.frame.width + 5), height: self.bounds.height)
            }
            else {
                closeButton.frame = CGRect.init(x: 5, y: 0, width: 30, height: self.bounds.height)
                messageLabel.frame = CGRect.init(x: 40, y: 0, width: maximumWidth - (self.bounds.width + 10 + closeButton.frame.width + 5), height: self.bounds.height)
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0) {
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
        isAnimated = !expandableViewShowing
        
        self.backgroundColor = .clear
        self.layer.masksToBounds = false
        self.clipsToBounds = false
        
        self.addSubview(subMessageView)
        self.addSubview(floatButtonView)
        
        subMessageView.frame = self.bounds
        subMessageView.backgroundColor = expandableViewBackgroundColor
        subMessageView.layer.masksToBounds = true
        subMessageView.layer.cornerRadius = self.bounds.height / 2.0
        
        floatButtonView.frame = self.bounds
        floatButtonView.backgroundColor = UIColor.init(r: 119, g: 88, b: 186)
        floatButtonView.layer.masksToBounds = true
        floatButtonView.layer.cornerRadius = (self.bounds.height < self.bounds.width ? self.bounds.height : self.bounds.width) / 2.0
        
        loadDefaultImage()
        if buttonImage != nil && buttonImage!.size != .zero {
            floatButtonView.image = buttonImage
            floatButtonView.contentMode = .scaleAspectFit
        } 
        
        floatButtonView.isUserInteractionEnabled = true
        floatButtonView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(excuteTapGesture(gesture:))))
        
        
        setUpCloseButtonImage()
        closeButton.backgroundColor = .clear
        closeButton.addTarget(self, action: #selector(closeButtonClicked), for: .touchUpInside)
        
        messageLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        messageLabel.textColor = .white
        messageLabel.text = "반가워요~ 인공지능 상담봇 입니다."
        
        subMessageView.addSubview(messageLabel)
        subMessageView.addSubview(closeButton)
    }
    
    func loadDefaultImage() {
        if buttonImage == nil || buttonImage!.size == .zero {
            buttonImage = UIImage.init(named: "showbot_icon", in: IBotChatButton.podsBundle, compatibleWith: nil)
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
        //TODO - close button clicked
    }
    
    @objc func excuteTapGesture(gesture:UITapGestureRecognizer) {

        if gesture.view == floatButtonView {
            if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
                
                IBApi.shared.checkIbotAlive(apiKey: apiKey) { (result, error) in
                    if let json = result, ((json["result"] as? String)?.uppercased() == "TRUE" || (json["result"] as? Bool) == true) {
                        
                        let showingUrl = self.chatbotUrl
                        
                        DispatchQueue.main.async {
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
    
    
    public func showSubMessageView() {
        subMessageView.alpha = 0.0
        subMessageView.frame = CGRect.init(x: 0, y: 0, width: self.frame.width, height: self.frame.height)

        UIView.animate(withDuration: 1.0, delay: 0.0, animations: { 
            self.subMessageView.alpha = 1.0
            if self.isLeftSide {
                self.subMessageView.frame = CGRect.init(x:0 , y: 0, width: self.maximumWidth, height: self.frame.height)
            }
            else {
                self.subMessageView.frame = CGRect.init(x: (self.frame.width-self.maximumWidth), y: 0, width: self.maximumWidth, height: self.frame.height)    
            }
            
            self.setNeedsDisplay()
        }) { (finish) in
             if finish {
                Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { (t2) in
                    self.hideSubMessageView()
                }
            }
        }
        
    }
    
    public func hideSubMessageView() {
        subMessageView.alpha = 1.0
        if self.isLeftSide {
            subMessageView.frame = CGRect.init(x:0 , y: 0, width: self.maximumWidth, height: self.frame.height)
        }
        else {
            subMessageView.frame = CGRect.init(x: (self.frame.width-maximumWidth), y: 0, width: maximumWidth, height: self.frame.height)    
        }
        
        
        UIView.animate(withDuration: 1.0, delay: 0.0, animations: {
            self.subMessageView.alpha = 0.0
            self.subMessageView.frame = CGRect.init(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        }) { (finish) in
        }
    }
    
}
