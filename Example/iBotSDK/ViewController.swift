//
//  ViewController.swift
//  iBotSDK
//
//  Created by Enliple on 10/15/2019.
//  Copyright (c) 2019 Enliple. All rights reserved.
//

import UIKit
import WebKit

import iBotSDK

class ViewController: UIViewController {

    @IBOutlet weak var wkWebView: WKWebView!
    @IBOutlet weak var chatbotButton: DHChatBotButton!
    
    
    let subWebView = WKWebView()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wkWebView.enableConsoleLog()
        wkWebView.customUserAgent = "android"
        
        let siteUrl:String = "https://mobon.net/main/m2/"

        if let url = URL(string: siteUrl) {
            wkWebView.load(URLRequest.init(url: url))
        }
        
//        let htmlStart = "<HTML><HEAD><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\"></HEAD><BODY>"
//        let htmlEnd = "</BODY></HTML>"
//        let htmlStart = "<HTML><head><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no\"><style type=\"text/css\">body,html {height: 100%;margin: 0;padding: 0;}#close {position: absolute;cursor: pointer;top: 15px;right: 0;padding: 15px;background-image: url('https://bot.istore.camp/chatImages/images/icon/common/icon_close_purple.png');background-size: 50%;background-position: center;background-repeat: no-repeat;z-index: 100;width:30px;}.area_map_local {position: absolute;width: 100%;height: 100%;overflow: hidden;padding-top: 60px;top: 0;}#iblock-kakao-map {width: 100%;height:90%;}.map_title {border: 1px solid #dcdcdc; border-radius: 5px 0px; height: 10%; padding: 13px 50px 13px 12px; position: relative;}.map_title .name {display: block;margin-bottom: 5px; font-size: 14px;}.map_title span {font-size:12px;}</style><script type=\"text/javascript\" src=\"//dapi.kakao.com/v2/maps/sdk.js?appkey=641518ac9c9558572cf924a2943139bb&amp;libraries=services;drawing\"></script><script charset=\"UTF-8\" src=\"https://t1.daumcdn.net/mapjsapi/js/main/4.1.8/kakao.js\"></script><link href=\"https://bot.istore.camp/static/css/build.css\" rel=\"stylesheet\"><script>document.domain = 'istore.camp';function calcHeight(id){if(id&&document.getElementById(id).contentWindow) {setTimeout(() => {var the_height= document.getElementById(id).contentWindow.document.body.scrollHeight;document.getElementById(id).height= the_height;}, 500);}}function iblockMapAdd(){$(\"#messageTalkBody\").append('<div class=\"bot_box\" data-a=\"st2\"><div class=\"bot\"><div class=\"profile\"><img src=\"https://image.istore.camp/admin/mall/317/qnwNgpjqR7Kc4dPzaapO.png\" alt=\"프로필\"></div><div><p class=\"bubble\"><iframe width=\"100%\" id=\"99ce0f9aaadd46cdad3c2fb25baefd23\" src=\"https://iblock.istore.camp/iblock/map/kakao/defaultmarker/test\" onload=\"window.calcHeight(this.id);\" scrolling=\"no\"></p><span class=\"time\">오후 2:07</span></div></div></div>');}</script><script type=\"application/json\" id=\"initial-data\">{\"mode\":\"dev\", \"userType\":\"U\", \"theme\":\"showbot4\", \"themeCss\":\"theme_01\", \"viewPath\":\"localhost\", \"loginPath\":\"http://shopbot2.com/m/login.html?type=login\"}</script><link rel=\"stylesheet\" type=\"text/css\" href=\"https://image.istore.camp/store/theme/15698299673171521315619/css/theme_style.css\"></head><BODY>"
//        let htmlEnd = "</BODY></HTML>"
//        
//        let htmlString = "<div class=\"iblock_location type03\"><div class=\"area_text\"><strong>인라이플 모비온 오시는길입니다.</strong><p>서울특별시 구로구 디지털로  272 한신it 타워 501호~504호</p><ul class=\"lists-icons\"><li><i class=\"ico-car\"></i><span>인라이플 혹은 한신it 타워로 검색해주시면 됩니다. </span></li><li><i class=\"ico-subway\"></i><span>2호선  구로디지털단지역 3번 출구로 나와서  약 1.02km  걸으시면  한신IT타워 가 보이십니다. </span></li></ul></div><div class=\"area_map\"><div style=\"height: 100%; position: relative; overflow: hidden; background: url(&quot;https://t1.daumcdn.net/mapjsapi/images/bg_tile.png&quot;);\"><div style=\"position: absolute; left: 0px; top: 0px; width: 100%; height: 100%; touch-action: none; cursor: default;\"><div style=\"position: absolute;\"><div style=\"position: absolute; z-index: 0;\"></div><div style=\"position: absolute; z-index: 1; left: 0px; top: 0px;\"><img src=\"https://map2.daumcdn.net/map_2d/1909dms/L4/981/430.png\" alt=\"\" draggable=\"false\" style=\"position: absolute; user-select: none; -webkit-user-drag: none; min-width: 0px; min-height: 0px; max-width: none; max-height: none; left: -102px; top: -36px; opacity: 1; transition-property: opacity; transition-duration: 0.2s; transition-timing-function: ease; width: 256px; height: 256px;\"><img src=\"https://map3.daumcdn.net/map_2d/1909dms/L4/981/431.png\" alt=\"\" draggable=\"false\" style=\"position: absolute; user-select: none; -webkit-user-drag: none; min-width: 0px; min-height: 0px; max-width: none; max-height: none; left: 154px; top: -36px; opacity: 1; transition-property: opacity; transition-duration: 0.2s; transition-timing-function: ease; width: 256px; height: 256px;\"><img src=\"https://map0.daumcdn.net/map_2d/1909dms/L4/981/432.png\" alt=\"\" draggable=\"false\" style=\"position: absolute; user-select: none; -webkit-user-drag: none; min-width: 0px; min-height: 0px; max-width: none; max-height: none; left: 410px; top: -36px; opacity: 1; transition-property: opacity; transition-duration: 0.2s; transition-timing-function: ease; width: 256px; height: 256px;\"><img src=\"https://map2.daumcdn.net/map_2d/1909dms/L4/982/430.png\" alt=\"\" draggable=\"false\" style=\"position: absolute; user-select: none; -webkit-user-drag: none; min-width: 0px; min-height: 0px; max-width: none; max-height: none; left: -102px; top: -292px; opacity: 1; transition-property: opacity; transition-duration: 0.2s; transition-timing-function: ease; width: 256px; height: 256px;\"><img src=\"https://map3.daumcdn.net/map_2d/1909dms/L4/982/431.png\" alt=\"\" draggable=\"false\" style=\"position: absolute; user-select: none; -webkit-user-drag: none; min-width: 0px; min-height: 0px; max-width: none; max-height: none; left: 154px; top: -292px; opacity: 1; transition-property: opacity; transition-duration: 0.2s; transition-timing-function: ease; width: 256px; height: 256px;\"><img src=\"https://map0.daumcdn.net/map_2d/1909dms/L4/982/432.png\" alt=\"\" draggable=\"false\" style=\"position: absolute; user-select: none; -webkit-user-drag: none; min-width: 0px; min-height: 0px; max-width: none; max-height: none; left: 410px; top: -292px; opacity: 1; transition-property: opacity; transition-duration: 0.2s; transition-timing-function: ease; width: 256px; height: 256px;\"></div><div style=\"position: absolute; z-index: 1;\"></div><div style=\"position: absolute; z-index: 1; width: 283px; height: 145px;\"></div><div style=\"position: absolute; z-index: 1;\"><svg version=\"1.1\" style=\"stroke: none; stroke-dashoffset: 0.5; stroke-linejoin: round; fill: none; transform: translateZ(0px); position: absolute; left: -566px; top: -290px; width: 1415px; height: 725px;\" viewBox=\"0 0 1415 725\"><defs></defs></svg></div><div style=\"position: absolute; z-index: 1; width: 100%; height: 0px; transform: translateZ(0px);\"><div style=\"position: absolute; margin: -39px 0px 0px -14px; z-index: 0; left: 149px; top: 73px;\"><img draggable=\"false\" src=\"https://t1.daumcdn.net/mapjsapi/images/marker.png\" alt=\"\" title=\"\" style=\"min-width: 0px; min-height: 0px; max-width: 99999px; max-height: none; border: 0px; display: block; position: absolute; user-select: none; -webkit-user-drag: none; clip: rect(0px, 29px, 42px, 0px); top: 0px; left: 0px; width: 29px; height: 42px;\"><img src=\"https://i1.daumcdn.net/dmaps/apis/transparent.gif\" alt=\"\" draggable=\"false\" usemap=\"#daum.maps.Marker.Area:1\" style=\"min-width: 0px; min-height: 0px; max-width: 99999px; max-height: none; border: 0px; display: block; position: absolute; user-select: none; -webkit-user-drag: none; width: 29px; height: 42px;\"><map id=\"daum.maps.Marker.Area:1\" name=\"daum.maps.Marker.Area:1\"><area href=\"javascript:void(0)\" alt=\"\" shape=\"poly\" coords=\"14,39,9,27,4,21,1,16,1,10,4,4,11,0,18,0,25,4,28,10,28,16,25,21,20,27\" title=\"\" style=\"-webkit-tap-highlight-color: transparent;\"></map></div></div></div></div><div style=\"position: absolute; cursor: default; z-index: 1; margin: 0px 6px; height: 19px; line-height: 14px; left: 0px; bottom: 0px; color: rgb(0, 0, 0);\"><div style=\"color: rgb(0, 0, 0); text-align: center; font-size: 10px; float: left; display: none;\"><div style=\"float: left; margin: 2px 3px 0px 4px; height: 6px; transition: width 0.1s ease 0s; border-top: none rgb(0, 0, 0); border-right: 2px solid rgb(0, 0, 0); border-bottom: 2px solid rgb(0, 0, 0); border-left: 2px solid rgb(0, 0, 0); border-image: initial; width: 46px;\"></div><div style=\"float: left; margin: 0px 4px 0px 0px; font-family: AppleSDGothicNeo-Regular, 돋움, dotum, sans-serif; font-weight: bold; color: rgb(0, 0, 0);\">100m</div></div><div style=\"margin: 0px 4px; float: left;\"><a target=\"_blank\" href=\"http://map.kakao.com/\" title=\"Kakao 지도로 보시려면 클릭하세요.\" style=\"float: left; width: 32px; height: 10px;\"><img src=\"https://t1.daumcdn.net/mapjsapi/images/m_bi_b.png\" alt=\"Kakao 지도로 이동\" style=\"float: left; width: 32px; height: 10px; border: none;\"></a><div style=\"font: 11px/11px Arial, Tahoma, Dotum, sans-serif; float: left;\"></div></div></div><div style=\"cursor: auto; position: absolute; z-index: 2; left: 0px; top: 0px;\"></div></div></div></div>"
//        subWebView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width - 30, height: 400)
//        subWebView.navigationDelegate = self
//        self.view.addSubview(subWebView)
//        
//        subWebView.loadHTMLString("\(htmlStart)\n\(htmlString)\n\(htmlEnd)", baseURL: URL.init(string: "https://bot.istore.camp"))
//        
        
//        let label : UILabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width - 100, height: 400))
//        label.backgroundColor = .white
//        let data = "<p>아래 상담 메뉴를 선택해 주세요  <img class=\"emoji\" alt=\"smiley\" height=\"20\" src=\"https://admin.istore.camp/view/js/plugin/ckeditor/plugins/smiley/images/regular_smile.gif\" title=\"smiley\" width=\"20\"><p></p></p>".data(using: String.Encoding.unicode) 
//        try? label.attributedText =  
//            NSAttributedString(data: data!,
//                           options: [.documentType:NSAttributedString.DocumentType.html], 
//                documentAttributes: nil)
//        
//        label.textAlignment = .left
//        label.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
//        self.view.addSubview(label)
        
        
        chatbotButton.showingUrl = "https://bot.istore.camp/index.html?mallId=1" 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    

    @IBAction func showButtonClicked(_ sender: Any) {
//        checkWebKitInnerHeight()
//        DHViewControllerPresenter.shared.showWebViewController(parent: self, url: "https://bot.istore.camp/index.html?origin=http%3A%2F%2Fm.superbeeracing.com&referer=http%3A%2F%2Fm.superbeeracing.com%2F&mallId=8")
    }
    
    
    func checkWebKitInnerHeight() {
        wkWebView.evaluateJavaScript("window.innerHeight") { (result, error) in
            if let result = result {
                print("innerHeight : \(result)")
            }
        }
        
        wkWebView.evaluateJavaScript("document.documentElement.clientHeight") { (result, error) in
            if let result = result {
                print("clientHeight : \(result)")
            }
        }
        
        wkWebView.evaluateJavaScript("document.body.scrollHeight") { (result, error) in
            if let result = result {
                print("body.scrollHeight : \(result)")
            }
        }
        
        wkWebView.evaluateJavaScript("document.body.clientHeight") { (result, error) in
            if let result = result {
                print("body.clientHeight : \(result)")
            }
        }
        
        wkWebView.evaluateJavaScript("window.screen.height") { (result, error) in
            if let result = result {
                print("screen.height : \(result)")
            }
        }
        
        
        
        
    }
}



extension WKWebView: WKScriptMessageHandler {

    /// enabling console.log
    public func enableConsoleLog() {

        //    set message handler
        configuration.userContentController.add(self, name: "logging")

        //    override console.log
        let _override = WKUserScript(source: "var console = { log: function(msg){window.webkit.messageHandlers.logging.postMessage(msg) }};", injectionTime: .atDocumentStart, forMainFrameOnly: false)
        
        configuration.userContentController.addUserScript(_override)
    }

    /// message handler
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("WebView: ", message.body)
    }
}


extension ViewController: WKNavigationDelegate {
 
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if webView == subWebView {
            self.subWebView.evaluateJavaScript("document.readyState") { (complete, error) in
                if complete != nil {
                    self.subWebView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                        let webViewHeight = height as! CGFloat
                        self.subWebView.frame.size.height = webViewHeight
                    })
                }
            }
        }
        
    }
    
}

