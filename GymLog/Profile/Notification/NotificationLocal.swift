//
//  NotificationLocal.swift
//  GymLog
//
//  Created by Kacper P on 10/07/2021.
//

import UIKit
import UserNotifications

class NotificationLocal: NSObject {
    
    func createDate(weekday: Int, hour: Int, minute: Int, completionhandler: (DateComponents) -> Void)  {
        
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
//        components.year = Calendar.current.component(.year, from: Date())
        components.weekday = weekday
//        components.weekdayOrdinal = 10
//        components.timeZone = .current
        
        completionhandler(components)
    }
    
    func createNotification(title: String, body: String, badge: Int?, at date: DateComponents, id: String) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
//        notificationContent.subtitle = subtitle
        notificationContent.body = body

        let delayTimeTrigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        
        if let badge = badge {
            var currentBadgeCount = UIApplication.shared.applicationIconBadgeNumber
            currentBadgeCount += badge
            notificationContent.badge = NSNumber(integerLiteral: currentBadgeCount)
        }
        
        notificationContent.sound = UNNotificationSound.default
        
        UNUserNotificationCenter.current().delegate = self
        
        let request = UNNotificationRequest(identifier: id + String(describing: date), content: notificationContent, trigger: delayTimeTrigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func createNotificationAfterPause(title: String, body: String, delayInterval: Int?) {
    
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
//        notificationContent.subtitle = subtitle
        notificationContent.body = body

        var delayTimeTrigger: UNTimeIntervalNotificationTrigger?
        
        if let delayInterval = delayInterval {
        delayTimeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(delayInterval), repeats: false)
        }
        
        notificationContent.sound = UNNotificationSound.default
        
        UNUserNotificationCenter.current().delegate = self
        
        let request = UNNotificationRequest(identifier: "pause", content: notificationContent, trigger: delayTimeTrigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func deletePauseNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["pause"])
    }
}

extension NotificationLocal: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("The notification is about to be presented")
        completionHandler([.badge, .sound, .alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let identifier = response.actionIdentifier
        
        switch identifier {
        case UNNotificationDismissActionIdentifier:
            print("The notification is dismissed")
            completionHandler()
        case UNNotificationDefaultActionIdentifier:
            print("The user opened the app from the notification")
            completionHandler()
        default:
            print("The default case was called")
            completionHandler()
        }
    }
    
}
