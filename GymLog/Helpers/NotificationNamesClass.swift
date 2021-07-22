//
//  NotificationClass.swift
//  GymLog
//
//  Created by Kacper P on 19/06/2021.
//

import Foundation
import UIKit

class NotificationNamesClass {
    
    static let unitSegmentedControl: String = "unitSegmentedControl"
    static let unitNotificationKeyLB: String = "unitKeyLB"
    static let placeholderLast: String = "placeholderLastValue"
    static let placeholderConstant: String = "placeholderConstantValue"
    
    static let unit = Notification.Name(unitSegmentedControl)
    
    static let nameLB = Notification.Name(unitNotificationKeyLB)
    
    static let placeholderLastValue = Notification.Name(placeholderLast)
    
    static let placeholderConstantValue = Notification.Name(placeholderConstant)
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
