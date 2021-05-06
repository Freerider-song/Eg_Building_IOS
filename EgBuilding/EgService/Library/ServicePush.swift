//
//  ServicePush.swift
//  EgService
//
//  Created by (주)에너넷 on 2021/01/27.
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
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                    didReceive response: UNNotificationResponse,
                                    withCompletionHandler completionHandler: @escaping () -> Void) {
        
        
            switch response.actionIdentifier {
            
            case UNNotificationDismissActionIdentifier:
                print("Dismiss Action")
      
            case UNNotificationDefaultActionIdentifier:
                print("Open Action")
                
            case "REQUEST_ACCEPT_ACTION":
                print("Request Accepted")
                CaApplication.m_Engine.ResponseAckMember(CaApplication.m_Info.nSeqMemberAckRequester, 1, _bShowWaitDialog: false, self)
                
            case "REQUEST_DECLINE_ACTION":
                print("Request Declined")
                CaApplication.m_Engine.ResponseAckMember(CaApplication.m_Info.nSeqMemberAckRequester, 2, _bShowWaitDialog: false, self)
                
            default:
                print("default")
            }
            completionHandler()
        }
    
    
    public func notifyRequestAckMember(_ strTitle: String, _ strBody: String){
        
        // Define the custom actions.
        let acceptAction = UNNotificationAction(identifier: "REQUEST_ACCEPT_ACTION",
              title: "승인",
              options: UNNotificationActionOptions(rawValue: 0))
        
        let declineAction = UNNotificationAction(identifier: "REQUEST_DECLINE_ACTION",
              title: "거절",
              options: UNNotificationActionOptions(rawValue: 0))
        
        // Define the notification type
        let meetingInviteCategory =
              UNNotificationCategory(identifier: "REQUEST_ACK_MEMBER",
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
        push.categoryIdentifier = "REQUEST_ACK_MEMBER"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "notifyRequestAckMember", content: push, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
    public func notifyResponseAckMemberAccepted(_ strTitle: String, _ strBody: String){
        
        
        let push = UNMutableNotificationContent()
        push.title = strTitle
        push.body = strBody
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "notifyResponseAckMemberAccepted", content: push, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
    public func notifyResponseAckMemberRejected(_ strTitle: String, _ strBody: String){
        
        
        let push = UNMutableNotificationContent()
        push.title = strTitle
        push.body = strBody
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "notifyResponseAckMemberRejected", content: push, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
    public func notifyResponseAckMemberCanceled(_ strTitle: String, _ strBody: String){
        
        
        let push = UNMutableNotificationContent()
        push.title = strTitle
        push.body = strBody
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "notifyResponseAckMemberCanceled", content: push, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
    public func notifyAlarmKwh(_ strTitle: String, _ strBody: String){
        
        
        let push = UNMutableNotificationContent()
        push.title = strTitle
        push.body = strBody
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "notifyAlarmKwh", content: push, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
    public func notifyAlarmWon(_ strTitle: String, _ strBody: String){
        
        
        let push = UNMutableNotificationContent()
        push.title = strTitle
        push.body = strBody
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "notifyAlarmWon", content: push, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
    public func notifyAlarmPriceLevel(_ strTitle: String, _ strBody: String){
        
        
        let push = UNMutableNotificationContent()
        push.title = strTitle
        push.body = strBody
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "notifyAlarmPriceLevel", content: push, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
    public func notifyAlarmUsage(_ strTitle: String, _ strBody: String){
        
        
        let push = UNMutableNotificationContent()
        push.title = strTitle
        push.body = strBody
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "notifyAlarmUsage", content: push, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
    //SendPush API
    public func notifyAlarmTrans(_ strTitle: String, _ strBody: String){
        
        
        let push = UNMutableNotificationContent()
        push.title = strTitle
        push.body = strBody
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "notifyAlarmTrans", content: push, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
   
   
}
