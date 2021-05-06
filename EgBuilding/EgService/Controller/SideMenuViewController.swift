//
//  SideMenuViewController.swift
//  EgService
//
//  Created by (주)에너넷 on 2020/11/27.
//

import UIKit

class SideMenuViewController: UIViewController {
    
    @IBOutlet weak var lbSiteName: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var btnUnReadAlarm: UIButton!
    @IBOutlet weak var btnUnReadNotice: UIButton!
    
    
    // 새 화면 추가할 때 UIView 추가한 후 연결
    @IBOutlet var UIHome: UIView!
    @IBOutlet var UIUsageDaily: UIView!
    @IBOutlet var UIUsageMonthly: UIView!
    @IBOutlet var UIUsageYearly: UIView!
    
    @IBOutlet var UISiteState: UIView!
    @IBOutlet var UIAlarm: UIView!
    
    
    @IBOutlet var UINotice: UIView!
    @IBOutlet var UIFaq: UIView!
    @IBOutlet var UIQna: UIView!
    @IBOutlet var UISetting: UIView!
    @IBOutlet var UILogout: UIView!
    
    @IBOutlet weak var UIQnaAndUISettingHeight: NSLayoutConstraint!
    
    @IBOutlet weak var UISettingAndUILogoutHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //숨김처리
        UIFaq.isHidden = true
        UIQna.isHidden = true
        UIQnaAndUISettingHeight.constant = 0 - UIQna.frame.height - UIFaq.frame.height
        
        // 정보 setting
        
        lbSiteName.text = "\(CaApplication.m_Info.strSiteName) \(CaApplication.m_Info.strAptDongName)동 \(CaApplication.m_Info.strAptHoName)호"
        lbName.text = "\(CaApplication.m_Info.strMemberName)님"
        let nCountUnreadAlarm: Int = CaApplication.m_Info.getUnreadAlarmCount()
        let nCountUnreadNotice: Int = CaApplication.m_Info.getUnreadNoticeCount()
        
        if nCountUnreadAlarm == 0 {
            btnUnReadAlarm.isHidden = true
        }
        else {
            btnUnReadAlarm.setTitle("\(nCountUnreadAlarm)", for: .normal)
        }
        if nCountUnreadNotice == 0 {
            btnUnReadNotice.isHidden = true
        }
        else {
            btnUnReadNotice.setTitle("\(nCountUnreadNotice)", for: .normal)
        }
        
        btnUnReadAlarm.layer.cornerRadius = 10
        btnUnReadNotice.layer.cornerRadius = 10
        
        // 화면 Tap Gesture
        let tapUIHome = MyTapGesture(target: self, action: #selector(self.pageMove))
        tapUIHome.title = "UIHome"
        // UIHome View를 Tap했을 때 인식하는 Recognizer 등록
        self.UIHome.addGestureRecognizer(tapUIHome)
        
        // 일일 사용량 UI Click
        let tapUIUsageDaily = MyTapGesture(target: self, action: #selector(self.pageMove))
        tapUIUsageDaily.title = "UIUsageDaily"
        self.UIUsageDaily.addGestureRecognizer(tapUIUsageDaily)
        
        let tapUIUsageMonthly = MyTapGesture(target: self, action: #selector(self.pageMove))
        tapUIUsageMonthly.title = "UIUsageMonthly"
        self.UIUsageMonthly.addGestureRecognizer(tapUIUsageMonthly)
        
        let tapUIUsageYearly = MyTapGesture(target: self, action: #selector(self.pageMove))
        tapUIUsageYearly.title = "UIUsageYearly"
        self.UIUsageYearly.addGestureRecognizer(tapUIUsageYearly)
        
        let tapUISiteState = MyTapGesture(target: self, action: #selector(self.pageMove))
        tapUISiteState.title = "UISiteState"
        self.UISiteState.addGestureRecognizer(tapUISiteState)
        
        let tapUIAlarm = MyTapGesture(target: self, action: #selector(self.pageMove))
        tapUIAlarm.title = "UIAlarm"
        self.UIAlarm.addGestureRecognizer(tapUIAlarm)
        
        let tapUINotice = MyTapGesture(target: self, action: #selector(self.pageMove))
        tapUINotice.title = "UINotice"
        self.UINotice.addGestureRecognizer(tapUINotice)
        
        let tapUIFaq = MyTapGesture(target: self, action: #selector(self.pageMove))
        tapUIFaq.title = "UIFaq"
        self.UIFaq.addGestureRecognizer(tapUIFaq)
        
        let tapUIQna = MyTapGesture(target: self, action: #selector(self.pageMove))
        tapUIQna.title = "UIQna"
        self.UIQna.addGestureRecognizer(tapUIQna)
        
        let tapUISetting = MyTapGesture(target: self, action: #selector(self.pageMove))
        tapUISetting.title = "UISetting"
        self.UISetting.addGestureRecognizer(tapUISetting)
        
        let tapUILogout = MyTapGesture(target: self, action: #selector(self.pageMove))
        tapUILogout.title = "UILogout"
        self.UILogout.addGestureRecognizer(tapUILogout)
        
    }
    
    
    // Navigation bar 숨김
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // Title을 가지고 있는 TapGesture
    class MyTapGesture: UITapGestureRecognizer {
        // Title을 통해 어떤 UI Click했는지 확인
        var title = String()
    }
    
    @objc func pageMove(_ sender:MyTapGesture){
        
        // Title 분석을 통해 어떤 UI Click되었는지 확인
        switch sender.title {
        // UIHome Click
        case "UIHome":
            // SideMenu Dismiss
            self.dismiss(animated: true, completion: nil)
            // Notification을 보냄 -> CustomUIViewController에서 Notification 받고 처리
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UIHome"), object: self)
            
        case "UIUsageDaily":
            self.dismiss(animated: true, completion: nil)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UIUsageDaily"), object: self)
            
        case "UIUsageMonthly":
            self.dismiss(animated: true, completion: nil)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UIUsageMonthly"), object: self)
            
        case "UIUsageYearly":
            self.dismiss(animated: true, completion: nil)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UIUsageYearly"), object: self)
            
        case "UISiteState":
            self.dismiss(animated: true, completion: nil)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UISiteState"), object: self)
            
        case "UIAlarm":
            self.dismiss(animated: true, completion: nil)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UIAlarm"), object: self)
        
            
        case "UINotice":
            self.dismiss(animated: true, completion: nil)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UINotice"), object: self)
            
        case "UIFaq":
            self.dismiss(animated: true, completion: nil)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UIFaq"), object: self)
        
        case "UIQna":
            self.dismiss(animated: true, completion: nil)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UIQna"), object: self)
        
        case "UISetting":
            self.dismiss(animated: true, completion: nil)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UISetting"), object: self)
            
        case "UILogout":
            self.dismiss(animated: true, completion: nil)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UILogout"), object: self)
            
        default:
            print("default!")
        }
    }
}
