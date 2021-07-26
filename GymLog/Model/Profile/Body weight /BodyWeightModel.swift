//
//  BodyWeightModel.swift
//  GymLog
//
//  Created by Kacper P on 22/07/2021.
//

import Foundation

struct BodyWeightModel {

    var mainLabel: String?
    var secondLabel: String?
    
    
    func getBodyWeightModel(callBack: ([BodyWeightModel]) -> Void) {
        let bodyWeightModel = [BodyWeightModel(mainLabel: "Add new weight", secondLabel: "Update your weight calendar"), BodyWeightModel(mainLabel: "Body weight progress", secondLabel: "Check your body weight progress"), BodyWeightModel(mainLabel: "Calories", secondLabel: "Calculate your daily calorie requirement"), BodyWeightModel(mainLabel: "BMI", secondLabel: "Calculate your bmi")]
        callBack(bodyWeightModel)
    }
}
