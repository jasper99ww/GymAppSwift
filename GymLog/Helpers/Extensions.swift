//
//  Extensions.swift
//  GymLog
//
//  Created by Kacper P on 21/07/2021.
//

import Foundation

extension Notification.Name {
    
    static let unitSegmentedControl = Notification.Name("unitSegmentedControl")
    static let unitSegmentedControlExhausted = Notification.Name("unitSegmentedControlExhausted")

}

extension String {
    static let numberFormatter = NumberFormatter()
    var doubleValue: Double {
        String.numberFormatter.decimalSeparator = "."
        if let result = String.numberFormatter.number(from: self) {
            return result.doubleValue
        } else {
            String.numberFormatter.decimalSeparator = ","
            if let result = String.numberFormatter.number(from: self) {
                return result.doubleValue
            }
        }
        return 0
    }
}
