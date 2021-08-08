//
//  Extensions.swift
//  GymLog
//
//  Created by Kacper P on 21/07/2021.
//

import Foundation
import UIKit

extension UISegmentedControl {
    func clearBG(color: UIColor) {
        let clearImage = UIImage().imageWithColor(color: color)
        setBackgroundImage(clearImage, for: .normal, barMetrics: .default)
        setBackgroundImage(clearImage, for: .selected, barMetrics: .default)
        setDividerImage(clearImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
}

public extension UIImage {
        func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        guard let context = UIGraphicsGetCurrentContext() else { return UIImage()}
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}



extension String {

func convertFormatTime() -> String {
    
    let components: Array = self.components(separatedBy: ":")

    let hours = Int(components[0]) ?? 0
    let minutes = Int(components[1]) ?? 0
    let seconds = Int(components[2]) ?? 0
    
    if Int(components[1]) ?? 0 < 1{
        return "\(seconds) sec"
    }
    else if Int(components[0]) ?? 0 < 1 {
        return "\(minutes) min"
    }
    else {
        return "\(hours)h \(minutes)m"
    }
}
}



extension Calendar {

    typealias WeekBoundary = (startOfWeek: Date?, endOfWeek: Date?)

    func currentWeekBoundary() -> WeekBoundary? {
        return weekBoundary(for: Date())
    }
    
    
    func weekBoundary(for date: Date) -> WeekBoundary? {
        let components = dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        
        guard let startOfWeek = self.date(from: components) else {
            return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        
        let endOfWeekOffset = weekdaySymbols.count - 1
        let endOfWeekComponents = DateComponents(day: endOfWeekOffset, hour: 23, minute: 59, second: 59)
        guard let endOfWeek = self.date(byAdding: endOfWeekComponents, to: startOfWeek) else {
            return nil
        }
        return (startOfWeek, endOfWeek)
    }
}
    
extension Date {
    
    func firstDateOfMonth() -> Date {
        
        let calendar = Calendar.current
        var startDate = Date()
        var interval: TimeInterval = 0
        _ = calendar.dateInterval(of: .month, start: &startDate, interval: &interval, for: self)
        return startDate
    }
    
    func lastDateOfMonth() -> Date {
        
        let calendar = Calendar.current
        let dayRange = calendar.range(of: .day, in: .month, for: self)!
        let dayLength = dayRange.upperBound
        var components = calendar.dateComponents([.year, .month, .day], from: self)
        components.day = dayLength
        
        return calendar.date(from: components)!
    }
    
    func firstDateOfYear() -> Date {
    
        let year = Calendar.current.component(.year, from: Date())
        
        
        guard let firstDayOfYear = Calendar.current.date(from: DateComponents(year: year, month: 1, day: 1)) else {return Date()}
        
//        let calendar = Calendar.current
//        var startDate = Date()
//        var interval: TimeInterval = 0
//        _ = calendar.dateInterval(of: .year, start: &startDate, interval: &interval, for: self)
//
//        return startDate
        return firstDayOfYear
    }
    
    func lastDateOfYear() -> Date {
        var components = Calendar.current.dateComponents([.year], from: Date())
        components.year = 1
        components.day = -1
        guard let lastDateOfYear = Calendar.current.date(byAdding: components, to: firstDateOfYear()) else { return Date()}
        return lastDateOfYear
    }
    
}

extension UIView {
    func fadeTransition(_ duration: CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}

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
