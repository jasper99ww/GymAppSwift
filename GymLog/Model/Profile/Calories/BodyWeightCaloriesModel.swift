//
//  BodyWeightCaloriesModel.swift
//  GymLog
//
//  Created by Kacper P on 05/08/2021.
//

import Foundation

struct ActivityLevels {
    let levelOfActivity: String
    let descriptionOfActivity: String
}

class BodyWeightCaloriesModel {
    
    func getActivityLevels() -> [ActivityLevels] {
        
        let activityIndexes = [ActivityLevels(levelOfActivity: "Sedentary", descriptionOfActivity: "mostly sitting, no exercise"),
            ActivityLevels(levelOfActivity: "Low", descriptionOfActivity: "short walks, exercise 1-3 times/week"),
            ActivityLevels(levelOfActivity: "Moderately", descriptionOfActivity: "exercises 2-3 times/week"),
            ActivityLevels(levelOfActivity: "Active", descriptionOfActivity: "mostly walking, exercise more than 3 times/week"),
            ActivityLevels(levelOfActivity: "Very active", descriptionOfActivity: "hard workouts every day")]
        
        return activityIndexes
    }
}
