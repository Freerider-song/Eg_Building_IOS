//
//  AppDelegate.swift
//  EgBuilding
//
//  Created by (주)에너넷 on 2021/04/22.
//

import UIKit
import Firebase
@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    let notificationDelegate = ServicePush()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self as? MessagingDelegate
        
        UNUserNotificationCenter.current().delegate = notificationDelegate as UNUserNotificationCenterDelegate
        
        let authOptions: UNAuthorizationOptions = [.alert, .sound]
          
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, _ in }
        
        //app will attempt to register for push notifications any time it's launched.
        application.registerForRemoteNotifications()
        
        print("register for remote notifications has succeed")
        
        //badge
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        return true
       
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
// ------------------------------------
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
        print("push received...")
        print(userInfo)
        var strSeqPlanElem: String = ""
        
        let strTitle = userInfo["title"] as! String
        let strBody = userInfo["body"] as! String
        let strPushType = userInfo["push_type"] as! String
        if(userInfo["seq_plan_elem"] != nil) {
            strSeqPlanElem = userInfo["seq_plan_elem"] as! String
        }
        
        
     
        let nPushType = Int(strPushType)
       
      
        
        print("push : title=\(strTitle) body=\(strBody)")
        
       
        let sp: ServicePush = ServicePush()
        
        completionHandler(UIBackgroundFetchResult.newData)
        
        switch nPushType {
     
        case m_GlobalEngine.ALARM_THIS_MONTH_USAGE_AT, m_GlobalEngine.ALARM_THIS_MONTH_KWH_OVER,
             m_GlobalEngine.ALARM_THIS_MONTH_WON_OVER, m_GlobalEngine.ALARM_METER_KWH_OVER_SAVE_REF,
             m_GlobalEngine.ALARM_METER_KWH_OVER_SAVE_PLAN, m_GlobalEngine.ALARM_NEW_NOTICE:
            print("simple Alarm Push received...")
            sp.notifyAlarm(strTitle, strBody)
        
       
        case m_GlobalEngine.ALARM_PLAN_ELEM_END, m_GlobalEngine.ALARM_PLAN_ELEM_BEGIN,
             m_GlobalEngine.ALARM_SAVE_ACT_MISSED:
            print("ResponseAckMemberCanceled Push received...")
            sp.notifyNotImplemented(strTitle, strBody, strSeqPlanElem)
       
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

