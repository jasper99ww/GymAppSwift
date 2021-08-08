//
//  ChartModel.swift
//  GymLog
//
//  Created by Kacper P on 07/08/2021.
//

import Foundation

protocol ChartDataProtocol {
//    var date: Date { get }
    var weight: Double { get }
    var reps: Int { get }
    var volume: Double { get }

}

protocol ChartDataProtocolSetExtension {
    var sets: Int { get }
}

typealias ChartDataProtocols = DateFieldForSelecton & ChartDataProtocol & ChartDataProtocolSetExtension

struct DoneExercise: ChartDataProtocols {
    
    let exerciseTitle: String
    let sets: Int
    let weight: Double
    let reps: Int
    let date: Date
    let volume: Double

}

struct RetrievedWorkoutMax: ChartDataProtocols {
  
    let workoutTitle: String
    let exerciseTitle: String
    let sets: Int
    let weight: Double
    let reps: Int
    let date: Date
    let volume: Double
   
}

struct HighlightedExercise {
    
    let sets: Int
    let reps: Int
    let time: String
    
}

struct DoneWorkoutInformation: ChartDataProtocols {
    var sets: Int
    let reps: Int
    let time: String
    let volume: Double
    let weight: Double
    let date: Date
}

//
//struct DoneExercise: DateFieldForSelecton {
//
//    let sets: Int
//    let exerciseTitle: String
//    let maxWeight: Int
//    let maxReps: Int
//    let date: Date
//    let volume: Int
//
//
//}
//
//struct RetrievedWorkoutMax: DateFieldForSelecton {
//
//    let sets: Int
//    let workoutTitle: String
//    let exerciseTitle: String
//    let maxWeight: Double
//    let maxReps: Int
//    let date: Date
//    let volume: Int
//
//
//}
//
//struct HighlightedExercise {
//
//    let sets: Int
//    let reps: Int
//    let time: String
//
//
//}
//
//struct DoneWorkoutInformation: DateFieldForSelecton {
//    let reps: Int
//    let time: String
//    let volume: Double
//    let weight: Double
//    let date: Date
//}
