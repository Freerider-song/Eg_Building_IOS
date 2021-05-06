//
//  AuthViewController.swift
//  EgService
//
//  Created by (주)에너넷 on 2021/01/20.
//

import UIKit
import WebKit
import Foundation
import SwiftyJSON


class AuthViewController: CustomUIViewController, WKScriptMessageHandler, WKUIDelegate, WKNavigationDelegate{
    
    
    //@IBOutlet var webView: WKWebView!, IBOulet으로 할 수 없음
    var webView: WKWebView?
   
    let strUrlCert: String = "https://www.egservice.co.kr/CertNiceApp/index.jsp"
    
    
    //URL SCHEME 설정, 앱 호출시
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {

        //현재 로딩 URL을 가져옵니다.

        let urlString : String = navigationAction.request.url!.absoluteString

        //앱설치 링크로 진입시 별도 처리
        if urlString.hasPrefix("https://itunes.apple.com"){
            //스토어 연결(OS에서 처리)
            
            if UIApplication.shared.canOpenURL(URL(string: urlString)!) {
                UIApplication.shared.open(URL(string: urlString)!, options: [:], completionHandler: nil)
                }
            else {
                print("No appstore installed.")
                }

            //웹뷰 내 페이지 이동 안하도록 설정
            decisionHandler(WKNavigationActionPolicy.cancel)
            return
        }

        else if (urlString.hasPrefix("tauthlink") || urlString.hasPrefix("ktauthexternalcall") || urlString.hasPrefix("upluscorporation") || urlString.hasPrefix("niceipin2")) {

            //외부 앱 Scheme로 URL이 시작되는 경우
            //앱 실행
            if UIApplication.shared.canOpenURL(URL(string: urlString)!) {
                UIApplication.shared.open(URL(string: urlString)!, options: [:], completionHandler: nil)
                }
            else {
                print("No app installed.")
                }
            //웹뷰 내 페이지 이동 안하도록 설정
            decisionHandler(WKNavigationActionPolicy.cancel)
            return
            }
        //일반 웹 페이지 링크처리
        decisionHandler(WKNavigationActionPolicy.allow)
        
        return
        }
    
    //webview에 page loading
    func loadWebPage(_ url: String) {
        let myUrl = URL(string: url)
        let myRequest = URLRequest(url: myUrl!)
        //webView.addJavascriptInterface(CaJsInterface(), forKey: "EgApp")
        webView?.load(myRequest)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contentController = WKUserContentController()
        // * WKWebView JS Functions 통신을 위한 WKWebViewConfiguration 구성
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        //JS -> Native Call 핸들러 추가 - 핸들러 이름 = 실제 호출 할 함수 이름
        contentController.add(self, name: "fnSuccess")
        print("fnSuccess added")
        contentController.add(self, name: "fnFail")
  
        webView = WKWebView(frame: CGRect.init(x: 0, y:0, width: self.view.frame.size.width, height: self.view.frame.size.height), configuration: config)
        
        webView?.uiDelegate = self //굳이 할 필요는 없음
        webView?.navigationDelegate = self //굳이 할 필요는 없dma
        
        
        //webview layout 설정
        self.view.addSubview(webView!)
        
        webView?.translatesAutoresizingMaskIntoConstraints = false
        webView?.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        webView?.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        webView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        webView?.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        
        loadWebPage(strUrlCert)
    
    }


    //Webview에서 앱으로 결과값 전달(JS -> Native Call)
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        // * message.name == 함수명, message.body == 파라미터 정보
        print("message name == \(message.name)")
        print("message body == \(message.body)")

        if message.name == "fnSuccess" {
            
            //message.body 가 Json string 타입이 아닌 일반 String Type으로  전달됨
            
            if message.body is String {
              print("String")  // Int
            } else {
              print("else")
            }
            
            let body = message.body as! String
            
            var firstIndex = body.index(body.startIndex, offsetBy: 68)
            var lastIndex = body.index(body.startIndex, offsetBy: 71)
            let strName = "\(body[firstIndex..<lastIndex])"

            firstIndex = body.index(body.startIndex, offsetBy: 82)
            lastIndex = body.index(body.startIndex, offsetBy: 93)
            let strPhone = "\(body[firstIndex..<lastIndex])"
            
            print(" name is \(strName) and phone is \(strPhone)")
     
            switch (CaApplication.m_Info.nAuthType){
            case CaApplication.m_Engine.AUTH_TYPE_SUBSCRIBE:
                
                let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
                let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "SignUpSubscribeViewController")
                view.modalPresentationStyle = .fullScreen
                self.present(view, animated: true, completion: nil)
                
            case CaApplication.m_Engine.AUTH_TYPE_CHANGE_PASSWORD:
             
                CaApplication.m_Engine.GetMemberIdSeq(strName, strPhone, false, self)
            default:
                print("unknown Auth Type...")
             }
            
            CaApplication.m_Info.nAuthType = CaApplication.m_Engine.AUTH_TYPE_UNKNOWN
            }
            
            
        
        else if message.name == "fail" {
          
            CaApplication.m_Info.strMessage = "본인인증에 실패했습니다."
            
            guard let pvc = self.presentingViewController else { return }

            self.dismiss(animated: true) {
              pvc.present(D02PopUpViewController(), animated: true, completion: nil)
            }
        }
    }
    
    override func onResult(_ Result: CaResult) {
        
        switch Result.callback {
        
            case m_GlobalEngine.EG_GET_MEMBER_ID_SEQ:
                let jo:[String:Any] = Result.JSONResult
                
                let nSeqMember: Int = jo["seq_member"] as! Int
                let strMemberId: String = jo["member_id"] as! String
                
                CaApplication.m_Info.nSeqMemberChanging = nSeqMember
                CaApplication.m_Info.strMemberIdChanging = strMemberId

                
                print("GetMemberIdSeq :" + strMemberId)
                
                if nSeqMember == 0 {
                    
                    
                    CaApplication.m_Info.strMessage = "본인인증을 받은 분과 일치하는 사용자가 없습니다."
                    
                    guard let pvc = self.presentingViewController else { return }

                    self.dismiss(animated: true) {
                      pvc.present(D01PopUpViewController(), animated: true, completion: nil)
                    }
                    
                }
                else{
                    
                    let storyboard = UIStoryboard(name: "ChangePassword", bundle: nil)
                    let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "ChangePasswordInputViewController")
                    view.modalPresentationStyle = .fullScreen
                    self.present(view, animated: true, completion: nil)
                    
                }
                
            default:
                print("Default!")
        }
    }
    
    @IBAction func btnGoBack(_ sender: UIBarButtonItem) {
        if webView!.canGoBack{
            webView?.goBack()
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func btnGoForward(_ sender: UIBarButtonItem) {
        
        webView!.goForward()
    }
    
}
