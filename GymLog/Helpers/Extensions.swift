//
//  Extensions.swift
//  GymLog
//
//  Created by Kacper P on 21/07/2021.
//

import Foundation
import UIKit

extension UIView {
    func showAnimation(_ completionBlock: @escaping () -> Void) {
          isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           options: .curveLinear,
                           animations: { [weak self] in
                                self?.transform = CGAffineTransform.init(scaleX: 0.95, y: 0.95)
            }) {  (done) in
                UIView.animate(withDuration: 0.1,
                               delay: 0,
                               options: .curveLinear,
                               animations: { [weak self] in
                                    self?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                }) { [weak self] (_) in
                    self?.isUserInteractionEnabled = true
                    completionBlock()
                }
            }
        }
}


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
