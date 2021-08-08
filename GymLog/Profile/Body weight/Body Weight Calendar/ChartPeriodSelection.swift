//
//  BodyWeightPeriodSelection.swift
//  GymLog
//
//  Created by Kacper P on 02/07/2021.
//

import Foundation
import UIKit

struct PeriodTime {
    static let week = "week"
    static let month = "month"
    static let year = "year"
}

protocol DateFieldForSelecton {
    var date: Date { get }
}

class ChartPeriodSelection {
    
    let group = DispatchGroup()
    let calendar = Calendar(identifier: .iso8601)

    func valuesForWeek<T: DateFieldForSelecton> (data: [T]) -> [T]  {
     
        var arrayForWeek: [T] = []

        for value in data where value.date >= (calendar.currentWeekBoundary()?.startOfWeek)! && value.date <= (calendar.currentWeekBoundary()?.endOfWeek)!  {
            arrayForWeek.append(value)
        }
       return arrayForWeek
    }
    
    func valuesForWeekNEW<T: DateFieldForSelecton> (data: [String:[T]]) -> [String: [T]]  {
       
        var newByMaxValue = [String: [T]]()
        print("new data is \(data)")
        print("new by is \(newByMaxValue)")
        
            for (key,value) in data {
                group.enter()
                for values in value where values.date >= (calendar.currentWeekBoundary()?.startOfWeek)! && values.date <= (calendar.currentWeekBoundary()?.endOfWeek)!
                {
                    newByMaxValue[key, default: []].append(values)
                    group.leave()
                }
               
            }
//            completionHandler(newByMaxValue)
        group.notify(queue: .main) {
        print("YOLO")
        print("nowe \(newByMaxValue)")
    
        }
        return newByMaxValue
        }

    func valuesForMonth<T: DateFieldForSelecton> (data: [T]) -> [T]  {
        
        var arrayForMonth: [T] = []
        
        for value in data where value.date >= Date().firstDateOfMonth() && value.date <= Date().lastDateOfMonth()  {
            arrayForMonth.append(value)
        }
        return arrayForMonth
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
