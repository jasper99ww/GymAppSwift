//
//  DateSelection.swift
//  GymLog
//
//  Created by Kacper P on 03/06/2021.
//

import Foundation
import UIKit

class DateSelection {
    
    let group1 = DispatchGroup()
    let group2 = DispatchGroup()
    let group3 = DispatchGroup()
    let calendar = Calendar(identifier: .iso8601)
    var newByExercise: [DoneExercise] = []
    var newByMaxValue: [String: [RetrievedWorkoutMax]] = [:]
    var newByVolume: [String: [DoneWorkoutInformation]] = [:]
    
    
    //MARK: -LOOPS FOR findByExercise
    
    func loopForWeekByExercise(data: [DoneExercise], completionHandler: ([DoneExercise]) -> Void)  {
        
        newByExercise = []
        
        for value in data where value.date >= (calendar.currentWeekBoundary()?.startOfWeek)! && value.date <= (calendar.currentWeekBoundary()?.endOfWeek)!  {
            newByExercise.append(value)
        }
        completionHandler(newByExercise)
    }
    
    func loopForMonthByExercise(data: [DoneExercise], completionHandler: ([DoneExercise]) -> Void) {
        
        newByExercise = []
        
        for value in data where value.date >= Date().firstDateOfMonth() && value.date <= Date().lastDateOfMonth() {
            newByExercise.append(value)
        }
        completionHandler(newByExercise)
    }
    
    
    //MARK: -LOOPS FOR findMaxValue
    
    func loopForWeekByMaxValue(data: [String: [RetrievedWorkoutMax]], completionHandler: ([String: [RetrievedWorkoutMax]]) -> Void) {
        newByMaxValue = [:]
        for (key,value) in data {
            for values in value where values.date >= (calendar.currentWeekBoundary()?.startOfWeek)! && values.date <= (calendar.currentWeekBoundary()?.endOfWeek)!
            {
                newByMaxValue[key, default: []].append(values)
            }
        }
        completionHandler(newByMaxValue)
    }
    
    func loopForMonthByMaxValue(data: [String: [RetrievedWorkoutMax]], completionHandler: ([String: [RetrievedWorkoutMax]]) -> Void) {
        newByMaxValue = [:]
        for (key,value) in data {
            for values in value where values.date >= Date().firstDateOfMonth() && values.date <= Date().lastDateOfMonth()
            {
                newByMaxValue[key, default: []].append(values)
            }
        }
        completionHandler(newByMaxValue)
    }
    
    
    //MARK: -LOOPS FOR findTrainingVolume
    
    func loopForWeekVolume(data: [String: [DoneWorkoutInformation]], completionHandler: ([String: [DoneWorkoutInformation]]) -> Void) {
        newByVolume = [:]
        for (key,value) in data {
            for values in value where values.date >= (calendar.currentWeekBoundary()?.startOfWeek)! && values.date <= (calendar.currentWeekBoundary()?.endOfWeek)!
            {
                newByVolume[key, default: []].append(values)
            }
        }
        completionHandler(newByVolume)
        
    }
    
    func loopForMonthVolume(data: [String: [DoneWorkoutInformation]], completionHandler: ([String: [DoneWorkoutInformation]]) -> Void) {
        newByVolume = [:]
        for (key,value) in data {
            for values in value where values.date >= Date().firstDateOfMonth() && values.date <= Date().lastDateOfMonth()
            {
                newByVolume[key, default: []].append(values)
            }
        }
        completionHandler(newByVolume)
        
        
        
    }
}
