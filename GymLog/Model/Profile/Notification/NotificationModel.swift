//
//  NotificationModel.swift
//  GymLog
//
//  Created by Kacper P on 06/08/2021.
//

import Foundation

struct DataForNotification {
    let day: String
    let workout: String
}

struct NotificationModel {
    
    var mainLabel: String?
    var secondLabel: String?
    
    func getNotificationModel() -> [NotificationModel] {
        let model = [NotificationModel(mainLabel: "Workout notification", secondLabel: "Send notification in a workout day"),
                     NotificationModel(mainLabel: "Notification after pause", secondLabel: "Send notification when pause is finished")]
        return model
    }
}
