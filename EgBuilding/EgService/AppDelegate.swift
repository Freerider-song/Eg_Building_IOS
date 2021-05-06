//
//  AppDelegate.swift
//  EgServiceTest
//
//  Created by (주)에너넷 on 2020/10/12.
//

import UIKit
import Firebase
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    let notificationDelegate = ServicePush()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        //start set_messaging_delegate
        Messaging.messaging().delegate = self as? MessagingDelegate
        
        //register for remote notifications. this shows a permission dialog on first run
      
        UNUserNotificationCenter.current().delegate = notificationDelegate as UNUserNotificationCenterDelegate
        
        let authOptions: UNAuthorizationOptions = [.alert, .sound]
          
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, _ in }
        
        //app will attempt to register for push notifications any time it's launched.
        application.registerForRemoteNotifications()
        
        print("register for remote notifications has succeed")
        
        //badge
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        configureInitialViewController()
        
        return true
    }
    
    private func configureInitialViewController() {
        // 앱 실행 시 Login 화면 띄움
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let loginView: CustomUIViewController = storyboard.instantiateViewController(identifier: "LoginViewController")
        
        loginView.modalPresentationStyle = .fullScreen

        self.window?.makeKeyAndVisible()
        self.window?.rootViewController?.present(loginView, animated: false, completion: nil)
    }

    // MARK: UISceneSession Lifecycle
    
    
    // Called when APNs has assigned the device a unique token, registerForRemoteNotifications()가 성공적으로 호출될 시 불러짐.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        //Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        //print it to console
        print("APNs device token: \(deviceTokenString)")
      
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        //print the error to console
        print("APNs registration failed: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // if you are receiving a notification message while your app is in the background
        // this callback will not be fired til the user taps on the notification launching the application
        // 알림 클릭 시 breakpoint로 이동
        print("receive push notification...")
        print(userInfo)
        
        let strTitle = userInfo["title"] as! String
        let strBody = userInfo["body"] as! String
        let strPushType = userInfo["push_type"] as! String
        let strSeqMemberAckRequester = userInfo["seq_member_ack_requester"] as? String
        
        /*
        CaApplication.m_Info.strPushTitle = strTitle
        CaApplication.m_Info.strPushBody = strBody
        CaApplication.m_Info.strPushType = strPushType
        */
        
        let nPushType = Int(strPushType)
        let nSeqMemberAckRequester = Int(strSeqMemberAckRequester ?? "0")
        CaApplication.m_Info.nSeqMemberAckRequester = nSeqMemberAckRequester!
    
        
        let servicePush: ServicePush = ServicePush()
        
        completionHandler(UIBackgroundFetchResult.newData)
        
        switch nPushType {
        case CaApplication.m_Engine.ALARM_TYPE_NOTI_TRANS:
            print("AlarmTrans Push received...")
            servicePush.notifyAlarmTrans(strTitle, strBody)
            
        case CaApplication.m_Engine.ALARM_TYPE_REQUEST_ACK_MEMBER:
            print("RequestAckMember Push received...")
            servicePush.notifyRequestAckMember(strTitle, strBody)
            
        case CaApplication.m_Engine.ALARM_TYPE_RESPONSE_ACK_MEMBER_ACCEPTED:
            print("RequestAckMember Push received...")
            servicePush.notifyResponseAckMemberAccepted(strTitle, strBody)
            
        case CaApplication.m_Engine.ALARM_TYPE_RESPONSE_ACK_MEMBER_REJECTED:
            print("ResponseAckMemberRejected Push received...")
            servicePush.notifyResponseAckMemberRejected(strTitle, strBody)
            
        case CaApplication.m_Engine.ALARM_TYPE_RESPONSE_ACK_MEMBER_CANCELED:
            print("ResponseAckMemberCanceled Push received...")
            servicePush.notifyResponseAckMemberCanceled(strTitle, strBody)
            
        case CaApplication.m_Engine.ALARM_TYPE_NOTI_KWH:
            print("NotiKwh Push received...")
            servicePush.notifyAlarmKwh(strTitle, strBody)
            
        case CaApplication.m_Engine.ALARM_TYPE_NOTI_WON:
            print("NotiWon Push received...")
            servicePush.notifyAlarmWon(strTitle, strBody)
            
        case CaApplication.m_Engine.ALARM_TYPE_NOTI_PRICE_LEVEL:
            print("Noti Price Level Push received...")
            servicePush.notifyAlarmPriceLevel(strTitle, strBody)
            
        case CaApplication.m_Engine.ALARM_TYPE_NOTI_USAGE:
            print("Noti Usage Push received...")
            servicePush.notifyAlarmUsage(strTitle, strBody)
            
        
        default:
            print("Unknown push type: " + strPushType)
        }
    }
    
    //앱은 꺼져있는데 푸시를 받고, 해당 푸시를 클릭했을 때
   /* private func application(_ application: UIApplication,
                             didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Configure the user interactions first.
        self.configureUserInteractions()
        
        // Register with APNs
        UIApplication.shared.registerForRemoteNotifications()
    }*/
    
    //method 재구성이 사용 중지된 경우의 메시지 처리,앱이 현재 화면에서 실행되고 있을 때
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        
    }
    
    //앱은 꺼져있지만 완전히 종료되지 않고 백그라운드에서 실행중일 때
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        print(userInfo)
        completionHandler()
    }
}



