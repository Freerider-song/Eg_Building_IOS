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
        
        
        //SceneDelegate에서 rootViewController를 가져와주는 작업
        guard let rootViewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController else {
            return
        }
        
        let storyboard = UIStoryboard(name: "Alarm", bundle: nil)
        
        //notifyNotImplemented가 호출되었을 시, 절감 조치 이행 화면 전환
        if (response.notification.request.identifier == "notifyNotImplemented"){
            
            let view = storyboard.instantiateViewController(identifier: "AlarmViewController") as? AlarmViewController
            print("didReceive: savePlanElem is \(CaApplication.m_Info.nPushPlanElem)")
            view?.nSeqPlanElem = CaApplication.m_Info.nPushPlanElem
            
            //modalPresentationStyle을 fullscreen으로 하여야 절감 조치 이행 화면이 dismiss되었을 시, 그 전 view에서 viewDidAppear가 호출됨
            view?.modalPresentationStyle = .fullScreen
            
            //rootView(Main)이 켜진 후 그 위에 화면 present.
            rootViewController.present(view!, animated: true, completion: nil)
            
        } else if response.notification.request.identifier == "notifyAlarm" {
            if  let view = storyboard.instantiateViewController(withIdentifier: "AlarmListViewController") as? AlarmListViewController {
                
                view.modalPresentationStyle = .fullScreen
                rootViewController.present(view, animated: true, completion: nil)
            }
        }
            
    
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
        
        CaApplication.m_Info.nPushPlanElem = nSeqPlanElem
        print("ServicePush: savePlanElem is \(CaApplication.m_Info.nPushPlanElem)")
        
        //버튼 삭제 후 로컬 노티 클릭 시 바로 넘어갈 수 있도록 설정. IOS에서는 버튼 보기 위해서는 노티를 밑으로 내리는 작업이 필요해 실질적으로 버튼을 보지 않는 경향이 있음.
        /*
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
        */
        
        let push = UNMutableNotificationContent()
        push.title = strTitle
        push.body = strBody
        //fggggpush.categoryIdentifier = "EXECUTE"
        
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
