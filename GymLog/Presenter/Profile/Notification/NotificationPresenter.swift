//
//  NotificationPresenter.swift
//  GymLog
//
//  Created by Kacper P on 06/08/2021.
//

import Foundation
import UserNotifications

protocol NotificationPresenterDelegate: class {
    func getNotificationModel(data: [NotificationModel])
    func showNotificationInformation()
}

class NotificationPresenter {
    
    weak var notificationPresenterDelegate: NotificationPresenterDelegate?
    private let notificationModel = NotificationModel()
    private let service = NotificationService()
    private let notificationPublisher = NotificationLocal()
    
    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE h:mm a"
        return dateFormatter
    }
        
    private var workoutsTitle: [String]? {
        guard let array = UserDefaults.standard.object(forKey: "workoutsName") as? [String] else { return nil}
        return array
    }
    
    init(notificationPresenterDelegate: NotificationPresenterDelegate) {
        self.notificationPresenterDelegate = notificationPresenterDelegate
    }
    
    func uiSwitchChanged(senderTag: Int, senderIsOn: Bool) {
        
        switch senderTag {
        case 0:
            if senderIsOn {
                if workoutsTitle != nil {
                    service.getDayOfWorkoutForNotification(workoutTitles: workoutsTitle!) { [weak self] (data) in
                        
                        guard let self = self else { return }
                        
                        for day in data {
                                      
                            guard let notificationDateComponents = self.workoutDayToDateComponents(day: day.day) else { return }

                            self.notificationPublisher.createNotification(title: "Workout!", body: "You've got a \(day.workout) training today", badge: 1, at: notificationDateComponents, id: day.day)
                            
                            self.notificationPresenterDelegate?.showNotificationInformation()
                        }
                    }
                }
            } else {
                // Remove notification if uiSwitch is off
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            }
        case 1:
            if senderIsOn {
                UserDefaults.standard.set(true, forKey: "pauseNotification")
            } else {
                UserDefaults.standard.set(false, forKey: "pauseNotification")
            }
        default:
            print("default switch tag")
        }
    }
    
    func workoutDayToDateComponents(day: String) -> DateComponents? {
        
        guard let dayFormatted = dateFormatter.date(from: day) else { return nil }
   
        //Make notification one hour before a training
        guard let hourBeforeNotification = Calendar.current.date(byAdding: .hour, value: -1, to: dayFormatted) else { return nil}

        let notificationDateComponents = Calendar.current.dateComponents([.weekday, .hour, .minute], from: hourBeforeNotification)
        
        return notificationDateComponents
    }
    
    func getModel() {
       let model = notificationModel.getNotificationModel()
       notificationPresenterDelegate?.getNotificationModel(data: model)
    }
    
}
