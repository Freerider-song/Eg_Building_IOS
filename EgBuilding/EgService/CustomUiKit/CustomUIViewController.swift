//
//  CustomUiVIewController.swift
//  EgService
//
//  Created by (주)에너넷 on 2020/11/18.
//

import UIKit
import Foundation

// Side bar Click시 페이지 이동 + onResult 정의한 UIViewController
class CustomUIViewController: UIViewController{
    
    // 화면
    var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SideMenu에서 새로운 UI 추가되면 여기에 새로 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.viewPop(_:)), name: NSNotification.Name(rawValue: "UIHome"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.viewPop(_:)), name: NSNotification.Name(rawValue: "UIUsageDaily"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.viewPop(_:)), name: NSNotification.Name(rawValue: "UIUsageMonthly"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.viewPop(_:)), name: NSNotification.Name(rawValue: "UIUsageYearly"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.viewPop(_:)), name: NSNotification.Name(rawValue: "UISiteState"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.viewPop(_:)), name: NSNotification.Name(rawValue: "UIAlarm"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.viewPop(_:)), name: NSNotification.Name(rawValue: "UINotice"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.viewPop(_:)), name: NSNotification.Name(rawValue: "UIFaq"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.viewPop(_:)), name: NSNotification.Name(rawValue: "UIQna"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.viewPop(_:)), name: NSNotification.Name(rawValue: "UISetting"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.viewPop(_:)), name: NSNotification.Name(rawValue: "UILogout"), object: nil)
        
    }
    
    // Page 띄우는 함수
    @objc func viewPop(_ noti: Notification) {
        switch noti.name {
        case NSNotification.Name(rawValue: "UIHome"):
            print("Custom: UIHome Clicked")
            // UIHome은 rootView임으로 다른 모든 View를 Dismiss
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            
        case NSNotification.Name(rawValue: "UIUsageDaily"):
            print("Custom: UIUsageDaily Clicked")
            
            let storyboard = UIStoryboard(name: "UsageDaily", bundle: nil)
            let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "UsageDailyViewController")
            //fullscrean으로 화면 전환
            view.modalPresentationStyle = .fullScreen
            self.present(view, animated: true, completion: nil)
            
        case NSNotification.Name(rawValue: "UIUsageMonthly"):
            print("Custom: UIUsageMonthly Clicked")
            
            let storyboard = UIStoryboard(name: "UsageMonthly", bundle: nil)
            let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "UsageMonthlyViewController")
            view.modalPresentationStyle = .fullScreen
            self.present(view, animated: true, completion: nil)
            
        case NSNotification.Name(rawValue: "UIUsageYearly"):
            print("Custom: UIUsageYearly Clicked")
            
            let storyboard = UIStoryboard(name: "UsageYearly", bundle: nil)
            let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "UsageYearlyViewController")
            view.modalPresentationStyle = .fullScreen
            self.present(view, animated: true, completion: nil)
            
        case NSNotification.Name(rawValue: "UISiteState"):
            print("Custom: UISiteState Clicked")
            
            let storyboard = UIStoryboard(name: "SiteState", bundle: nil)
            let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "SiteStateViewController")
            view.modalPresentationStyle = .fullScreen
            self.present(view, animated: true, completion: nil)
            
        case NSNotification.Name(rawValue: "UIAlarm"):
            print("Custom: UIAlarm Clicked")
            
            let storyboard = UIStoryboard(name: "Alarm", bundle: nil)
            let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "AlarmViewController")
            view.modalPresentationStyle = .fullScreen
            self.present(view, animated: true, completion: nil)
            
            
        case NSNotification.Name(rawValue: "UINotice"):
            print("Custom: UINotice Clicked")
            
            let storyboard = UIStoryboard(name: "NoticeList", bundle: nil)
            let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "NoticeListViewController")
            view.modalPresentationStyle = .fullScreen
            self.present(view, animated: true, completion: nil)
            
        case NSNotification.Name(rawValue: "UISetting"):
            print("Custom: UISetting Clicked")
            
            let storyboard = UIStoryboard(name: "Setting", bundle: nil)
            let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "SettingViewController")
            view.modalPresentationStyle = .fullScreen
            self.present(view, animated: true, completion: nil)
            
        case NSNotification.Name(rawValue: "UILogout"):
            print("Custom: UILogout Clicked")
            
            let storyboard = UIStoryboard(name: "PopUp", bundle: nil)
            let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "LogoutPopUpViewController")
            view.modalPresentationStyle = .overFullScreen
            self.present(view, animated: true, completion: nil)
            
        default:
            print("default!")
        }
    }
    
    func onResult(_ Result: CaResult){
        
    }
}
