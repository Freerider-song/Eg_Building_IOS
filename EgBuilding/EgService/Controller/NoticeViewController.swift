//
//  NoticeViewController.swift
//  EgService
//
//  Created by (주)에너넷 on 2021/01/06.
//

import UIKit
import WebKit

//html to label

class NoticeViewController: CustomUIViewController {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbContent: UILabel!
    @IBOutlet weak var lbNoticeType: UILabel!
    @IBOutlet weak var lbDtCreated: UILabel!
    @IBOutlet var ivNoticeType: UIImageView!
    

    @IBOutlet weak var totalView: UIView!
    @IBOutlet var webView: WKWebView!
    
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
        
        if nNoticeType == 1 || nNoticeType == 3 {
            ivNoticeType.image = UIImage(named: "notice_site.png")
        }
        else {
            ivNoticeType.image = UIImage(named: "notice_eg.png")}
        
        if nNoticeType == 1 {
            lbNoticeType.text = "관리사무실"
        }
        else if nNoticeType == 2{
            lbNoticeType.text = "EG서비스 운영자"
        }
        else {
            lbNoticeType.text = "동사무소"
        }
        
    }
    
    //content를 webview를 통해 출력
    
    func loadHTMLStringImage() -> Void {
        
       let htmlString = ("<meta name = \"viewport\" content = \"initial-scale = 1.0\" />") + strContent
        
        webView.loadHTMLString(htmlString, baseURL: nil)
        
    }
    
    
    @IBAction func onBackBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func onAlarmBtnClicked(_ sender: UIButton) {
        print("alarm button clicked...")
        let storyboard = UIStoryboard(name: "Alarm", bundle: nil)
        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "AlarmViewController")
        view.modalPresentationStyle = .fullScreen
        self.present(view, animated: true, completion: nil)
    }
    
}
