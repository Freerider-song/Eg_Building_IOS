//
//  NoticeViewController.swift
//  EgBuilding
//
//  Created by (주)에너넷 on 2021/05/07.
//

import UIKit

import WebKit

//html to label

class NoticeViewController: CustomUIViewController {

    @IBOutlet var webView: WKWebView!
    @IBOutlet var totalView: UIView!
    @IBOutlet var lbTitle: UILabel!
    @IBOutlet var lbNoticeType: UILabel!
    @IBOutlet var lbDtCreated: UILabel!
    var strTitle = ""
    var strContent = ""
    var nNoticeType = 0
    var dtCreated = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.scrollView.bounces = false
        
        
        totalView.layer.cornerRadius = 15
        webView.layer.cornerRadius = 15
        webView.layer.masksToBounds = true
    
        
        loadHTMLStringImage()

        lbTitle.text = self.strTitle
        lbDtCreated.text = self.dtCreated
        
       
        if nNoticeType == 1 {
            lbNoticeType.text = "아파트관리실"
        }
        else if nNoticeType == 2{
            lbNoticeType.text = "에너넷"
        }
        else {
            lbNoticeType.text = "구청관리자"
        }
        
    }
    
    //content를 webview를 통해 출력
    
    func loadHTMLStringImage() -> Void {
        
       let htmlString = ("<meta name = \"viewport\" content = \"initial-scale = 1.0\" />") + strContent
        
        webView.loadHTMLString(htmlString, baseURL: nil)
        
    }
    
    
    @IBAction func onBackBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
}
