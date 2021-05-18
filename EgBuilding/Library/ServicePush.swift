//
//  ServicePush.swift
//  EgService
//
//  Created by (주)에너넷 on 2021/04/22.
//

import Foundation
import Firebase
import UserNotifications
import UserNotificationsUI


public class ServicePush: NSObject , UNUserNotificationCenterDelegate{
    
    var savePlanElem: Int = 0

    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                   willPresent notification: UNNotification,
                                   withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
           completionHandler([.alert,.sound])
       }
    
    //notification action 관련 함수
    // This function will be called right after user tap on the notification
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                    didReceive response: UNNotificationResponse,
                                    withCompletionHandler completionHandler: @escaping () -> Void) {
        
        
        //local noti 클릭시 알림리스트뷰로 전환
        guard let rootViewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController else {
            return
        }
        
        let storyboard = UIStoryboard(name: "Alarm", bundle: nil)
        
        if (response.notification.request.identifier == "notifyNotImplemented"){
            
            let view = storyboard.instantiateViewController(identifier: "AlarmViewController") as? AlarmViewController
            print("didReceive: savePlanElem is \(savePlanElem)")
            view?.nSeqPlanElem = savePlanElem
            view?.modalPresentationStyle = .overCurrentContext
            rootViewController.present(view!, animated: true, completion: nil)
            
        } else if response.notification.request.identifier == "notifyAlarm" {
            if  let view = storyboard.instantiateViewController(withIdentifier: "AlarmListViewController") as? AlarmListViewController {
                
                view.modalPresentationStyle = .fullScreen
                rootViewController.present(view, animated: true, completion: nil)
            }
        }
            
        //action에서는 뷰 전환 안되나/
        
        switch response.actionIdentifier {
        
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
            
        case UNNotificationDefaultActionIdentifier:
            print("Open Action")
            
            
        case "REQUEST_DECLINE_ACTION":
            print("Request Declined")
   
        
        case "EXECUTE_ACTION":
            print("Execute Button clicked..")
           
            
        default:
            print("default")
        }
        // tell the app that we have finished processing the user’s action / response
        completionHandler()
        
    }
    
    
    public func notifyNotImplemented(_ strTitle: String, _ strBody: String, _ nSeqPlanElem: Int){
        
        // Define the custom actions.
        
        savePlanElem = nSeqPlanElem
        print("ServicePush: savePlanElem is \(savePlanElem)")
        
        let acceptAction = UNNotificationAction(identifier: "EXECUTE_ACTION",
              title: "조치하기",
              options: UNNotificationActionOptions(rawValue: 0))
        
        let declineAction = UNNotificationAction(identifier: "REQUEST_DECLINE_ACTION",
              title: "취소",
              options: UNNotificationActionOptions(rawValue: 0))
        
        // Define the notification type
        let meetingInviteCategory =
              UNNotificationCategory(identifier: "EXECUTE",
              actions: [acceptAction, declineAction],
              intentIdentifiers: [],
              hiddenPreviewsBodyPlaceholder: "",
              options: .customDismissAction)
        
        // Register the notification type.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.setNotificationCategories([meetingInviteCategory])
        
        let push = UNMutableNotificationContent()
        push.title = strTitle
        push.body = strBody
        push.categoryIdentifier = "EXECUTE"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "notifyNotImplemented", content: push, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    

    public func notifyAlarm(_ strTitle: String, _ strBody: String){
        
        
        let push = UNMutableNotificationContent()
        push.title = strTitle
        push.body = strBody
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "notifyAlarm", content: push, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
  
}
