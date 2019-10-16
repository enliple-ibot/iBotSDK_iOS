//
//  DHChatBotButton.swift
//
//  Created by enliple on 26/09/2019.
//

import UIKit

@IBDesignable
public class DHChatBotButton: UIView {
    
    @IBInspectable public var showingUrl:String = ""
    @IBInspectable public var expandableViewShowing:Bool = true
    @IBInspectable public var expandableViewBackgroundColor:UIColor = UIColor.init(r: 114, g: 71, b: 199)
    @IBInspectable public var buttonImage:UIImage? = nil
    
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
    }
    
    
    public override func didMoveToWindow() {
        super.didMoveToWindow()
    }
    
    func commonInit() {
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
        floatButtonView.backgroundColor = UIColor.init(r: 121, g: 98, b: 162)
        floatButtonView.layer.masksToBounds = true
        floatButtonView.layer.cornerRadius = (self.bounds.height < self.bounds.width ? self.bounds.height : self.bounds.width) / 2.0
//        floatButtonView.layer.borderColor = UIColor.init(r: 111, g: 88, b: 182).cgColor
        floatButtonView.layer.borderColor = UIColor.white.cgColor
        floatButtonView.layer.borderWidth = 1.0
        
        loadDefaultImage()
        if buttonImage != nil && buttonImage!.size != .zero {
            floatButtonView.image = buttonImage
            floatButtonView.contentMode = .scaleAspectFit
        } 
        
        floatButtonView.isUserInteractionEnabled = true
        floatButtonView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(excuteTapGesture(gesture:))))
        
        closeButton.setTitle("X", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.backgroundColor = .clear
        closeButton.addTarget(self, action: #selector(closeButtonClicked), for: .touchUpInside)
        
        messageLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        messageLabel.textColor = .white
        messageLabel.text = "아이봇 샘플 메세지 입니다."
        
        subMessageView.addSubview(messageLabel)
        subMessageView.addSubview(closeButton)
    }
    
    func loadDefaultImage() {
        if buttonImage == nil || buttonImage!.size == .zero {
            buttonImage = UIImage.init(named: "showbot_icon", in: Bundle(for: DHWebViewController.self), compatibleWith: nil)
        }
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
                
                if showingUrl.isEmpty {
                    showingUrl = "https://bot.istore.camp/index.html?mallId=1"
                }
                
                
                if rootViewController is UINavigationController {
                    DHViewControllerPresenter.shared.showWebViewController(parent: rootViewController, url: showingUrl, isPush: true)
                }
                else {
                    DHViewControllerPresenter.shared.showWebViewController(parent: rootViewController, url: showingUrl)
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
