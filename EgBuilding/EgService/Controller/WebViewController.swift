//
//  WebViewController.swift
//  EgService
//
//  Created by (주)에너넷 on 2021/01/25.
//

import UIKit
import WebKit

class WebViewController: CustomUIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var lblTitle: UILabel!
    
    /*func loadWebView(_ url: String) {
        let myUrl = URL(string: url)
        let myRequest = URLRequest(url: myUrl!)
    
        webView?.load(myRequest)
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if CaApplication.m_Info.nWeb == 1 {
            
            lblTitle.text = "서비스 이용 약관"
            
            let myUrl = "https://www.egservice.co.kr/EgService/EG_이용약관_2019_11_04.htm"
            let encodedString = myUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let url = URL(string: encodedString)!
            let myRequest = URLRequest(url: url)
        
            webView?.load(myRequest)
        
        }
        else {
            
            lblTitle.text = "개인정보 수집이용"
            let myUrl = "https://www.egservice.co.kr/EgService/EG_개인정보_2019_11_04.htm"
            let encodedString = myUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let url = URL(string: encodedString)!
            let myRequest = URLRequest(url: url)
        
            webView?.load(myRequest)
        
        }

    }
    
    @IBAction func OnBackBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
