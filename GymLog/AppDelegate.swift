//
//  AppDelegate.swift
//  GymLog
//
//  Created by Barbara Podgórska on 20/02/2021.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private func requestNotificationAuthorization(application: UIApplication) {
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        center.requestAuthorization(options: options) { (granted, error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        requestNotificationAuthorization(application: application)
        FirebaseApp.configure()
        checking()
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
//        IQKeyboardManager.shared.layoutIfNeededOnUpdate = true
        return true
    }
    
    func checking() {
        
        let userDefaults = UserDefaults.standard

        if (!userDefaults.bool(forKey: "hasRunBefore")) {
            print("The app is launching for the first time. Setting UserDefaults...")

            do {
                try Auth.auth().signOut()
            } catch {

            }

            // Update the flag indicator
            userDefaults.set(true, forKey: "hasRunBefore")
            userDefaults.synchronize() // This forces the app to update userDefaults

            // Run code here for the first launch

        } else {
            print("The app has been launched before. Loading UserDefaults...")
        
            // Run code here for every other launch but the first
        }
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
