//
//  BodyWeightPeriodSelection.swift
//  GymLog
//
//  Created by Kacper P on 02/07/2021.
//

import Foundation
import UIKit

class BodyWeightPeriodSelection {
    
    let group = DispatchGroup()
    let calendar = Calendar(identifier: .iso8601)
    
    var arrayForPeriod: [Weight] = []
    
    
    func loopForWeek(data: [Weight], completionHandler: ([Weight]) -> Void)  {
        
       arrayForPeriod = []
        
        for value in data where value.date >= (calendar.currentWeekBoundary()?.startOfWeek)! && value.date <= (calendar.currentWeekBoundary()?.endOfWeek)!  {
            arrayForPeriod.append(value)
        }
        completionHandler(arrayForPeriod)
    }
    
    func loopForMonth(data: [Weight], completionHandler: ([Weight]) -> Void)  {
        
       arrayForPeriod = []
        
        for value in data where value.date >= Date().firstDateOfMonth() && value.date <= Date().lastDateOfMonth()  {
            arrayForPeriod.append(value)
        }
        completionHandler(arrayForPeriod)
    }
    
}


extension UINavigationController {
    func replaceCurrentViewControllerWith(viewController: UIViewController, animated: Bool) {
        var controllers = viewControllers
        controllers.removeLast()
        controllers.append(viewController)
        setViewControllers(controllers, animated: animated)
    }
}
