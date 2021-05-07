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
            /*
            
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
 */
            
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
