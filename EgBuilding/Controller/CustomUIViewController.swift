//
//  CustomUIViewController.swift
//  EgBuilding
//
//  Created by (주)에너넷 on 2021/04/22.
//

import UIKit

class CustomUIViewController: UIViewController {

    var bKeyboardOn: Bool = false
    var window: UIWindow?
    let m_Pref: CaPref = CaPref()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(self.viewPop(_:)), name: NSNotification.Name(rawValue: "UIHome"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.viewPop(_:)), name: NSNotification.Name(rawValue: "UIUsageDaily"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.viewPop(_:)), name: NSNotification.Name(rawValue: "UIUsageMonthly"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.viewPop(_:)), name: NSNotification.Name(rawValue: "UIUsageYearly"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.viewPop(_:)), name: NSNotification.Name(rawValue: "UISaving"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.viewPop(_:)), name: NSNotification.Name(rawValue: "UIAlarm"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.viewPop(_:)), name: NSNotification.Name(rawValue: "UINotice"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.viewPop(_:)), name: NSNotification.Name(rawValue: "UIUsageCompare"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.viewPop(_:)), name: NSNotification.Name(rawValue: "UISetting"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.viewPop(_:)), name: NSNotification.Name(rawValue: "UILogout"), object: nil)
    }
    
    @objc func viewPop(_ noti: Notification) {
        switch noti.name {
        case NSNotification.Name(rawValue: "UIHome"):
            print("Custom: UIHome Clicked")
            // UIHome은 rootView임으로 다른 모든 View를 Dismiss
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            
        case NSNotification.Name(rawValue: "UISaving"):
            print("Custom: UISaving Clicked")
            
            let storyboard = UIStoryboard(name: "Saving", bundle: nil)
            let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "SavingViewController")
            view.modalPresentationStyle = .fullScreen
            self.present(view, animated: true, completion: nil)
            
        case NSNotification.Name(rawValue: "UIUsageCompare"):
            print("Custom: UIUsageCompare Clicked")
            
            let storyboard = UIStoryboard(name: "UsageDaily", bundle: nil)
            let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "UsageDailyViewController")
            //fullscrean으로 화면 전환
            view.modalPresentationStyle = .fullScreen
            self.present(view, animated: true, completion: nil)
            
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
            
        case NSNotification.Name(rawValue: "UIAlarm"):
            print("Custom: UIAlarm Clicked")
            
            let storyboard = UIStoryboard(name: "Alarm", bundle: nil)
            let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "AlarmListViewController")
            view.modalPresentationStyle = .fullScreen
            self.present(view, animated: true, completion: nil)
            
            
        case NSNotification.Name(rawValue: "UINotice"):
            print("Custom: UINotice Clicked")
            
            let storyboard = UIStoryboard(name: "Notice", bundle: nil)
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
            
            let msg = UIAlertController(title: "로그아웃", message: "로그아웃을 하시면, 로그인 정보가 초기화됩니다. 정말로 로그아웃 하시겠습니까?", preferredStyle: .alert)
                    
                    //Alert에 부여할 Yes이벤트 선언
                    let YES = UIAlertAction(title: "예", style: .default, handler: { (action) -> Void in
                        
                        //로그읹 정보 초기화
                        self.m_Pref.setValue(m_GlobalEngine.PREF_MEMBER_ID, "")
                        self.m_Pref.setValue(m_GlobalEngine.PREF_PASSWORD, "")
                        
                        let storyboard = UIStoryboard(name: "Login", bundle: nil)
                        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "LoginViewController")
                        view.modalPresentationStyle = .fullScreen
                        self.present(view, animated: true, completion: nil)
                    })
                    
                    //Alert에 부여할 No이벤트 선언
            let NO = UIAlertAction(title: "아니요", style: .default, handler: { (action) -> Void in
                                    self.dismiss(animated: true, completion: nil)})
                    
                
                    //Alert에 이벤트 연결
                    msg.addAction(YES)
                    msg.addAction(NO)

                    //Alert 호출
                    self.present(msg, animated: true, completion: nil)
            
        default:
            print("default!")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func onResult(_ Result: CaResult) {
        
    }
    
    func alert(title : String, message : String, text : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: text, style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(okButton)
        return self.present(alertController, animated: true, completion: nil)
    }
    /*
    func showPopUpConfirm(message : String) {
        
        let storyboard = UIStoryboard(name: "PopUp", bundle: nil)
        let view: CustomUIViewController = storyboard.instantiateViewController(identifier: "ViewControllerPopUpConfirm")
        
        view.modalPresentationStyle = .overCurrentContext
        self.present(view, animated: true, completion: nil)
    }
    */

}
