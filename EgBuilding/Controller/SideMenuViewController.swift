//
//  SideMenuViewController.swift
//  EgBuilding
//
//  Created by (주)에너넷 on 2021/04/26.
//

import UIKit

class SideMenuViewController: UIViewController {

    @IBOutlet weak var lblAdminName: UILabel!
    @IBOutlet weak var lblSiteName: UILabel!
    
    
    @IBOutlet weak var UIHome: UIView!
    @IBOutlet weak var UISaving: UIView!
    
    @IBOutlet weak var UIUsageCompare: UIView!
    @IBOutlet weak var UIUsageDaily: UIView!
    @IBOutlet weak var UIUsageMonthly: UIView!
    @IBOutlet weak var UIUsageYearly: UIView!
    @IBOutlet weak var UINotice: UIView!
    @IBOutlet weak var UIAlarm: UIView!
    @IBOutlet weak var UISetting: UIView!
    @IBOutlet weak var UILogout: UIView!
    
    @IBOutlet weak var btnUnReadNotice: UIButton!
    @IBOutlet weak var btnUnReadAlarm: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // 정보 setting
        
        lblSiteName.text = CaApplication.m_Info.m_strSiteName
        lblAdminName.text = CaApplication.m_Info.m_strAdminName
        
        
        if CaApplication.m_Info.m_nUnreadAlarmCount == 0 {
            btnUnReadAlarm.isHidden = true
        }
        else {
            btnUnReadAlarm.setTitle("\(CaApplication.m_Info.m_nUnreadAlarmCount)", for: .normal)
        }
        if CaApplication.m_Info.m_nUnreadNoticeCount == 0 {
            btnUnReadNotice.isHidden = true
        }
        else {
            btnUnReadNotice.setTitle("\(CaApplication.m_Info.m_nUnreadNoticeCount)", for: .normal)
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
        
        let tapUISaving = MyTapGesture(target: self, action: #selector(self.pageMove))
        tapUISaving.title = "UISaving"
        self.UISaving.addGestureRecognizer(tapUISaving)
        
        let tapUIAlarm = MyTapGesture(target: self, action: #selector(self.pageMove))
        tapUIAlarm.title = "UIAlarm"
        self.UIAlarm.addGestureRecognizer(tapUIAlarm)
        
        let tapUINotice = MyTapGesture(target: self, action: #selector(self.pageMove))
        tapUINotice.title = "UINotice"
        self.UINotice.addGestureRecognizer(tapUINotice)
        
        let tapUIUsageCompare = MyTapGesture(target: self, action: #selector(self.pageMove))
        tapUIUsageCompare.title = "UIUsageCompare"
        self.UIUsageCompare.addGestureRecognizer(tapUIUsageCompare)
        
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
            
        case "UISaving":
            self.dismiss(animated: true, completion: nil)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UISaving"), object: self)
            
        case "UIAlarm":
            self.dismiss(animated: true, completion: nil)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UIAlarm"), object: self)
        
        case "UINotice":
            self.dismiss(animated: true, completion: nil)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UINotice"), object: self)
            
        case "UIUsageCompare":
            self.dismiss(animated: true, completion: nil)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UIUsageCompare"), object: self)
        
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
