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


}
