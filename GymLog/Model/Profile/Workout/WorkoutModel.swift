//
//  WorkoutModel.swift
//  GymLog
//
//  Created by Kacper P on 19/07/2021.
//

import Foundation

struct WorkoutSettingsDataModel {

    let mainLabelSetting: String
    let secondLabelSetting: String
    let segmentedControlFirstSegmentTitle: String?
    let segmentedControlSecondSegmentTitle: String?
    
}

class WorkoutModel {

    func getWorkoutSettingsLabels(callBack: ([WorkoutSettingsDataModel]) -> Void) {
        let workoutModels = [WorkoutSettingsDataModel(mainLabelSetting: "Units", secondLabelSetting: "Select Unit", segmentedControlFirstSegmentTitle: "KG", segmentedControlSecondSegmentTitle: "LB"),
        WorkoutSettingsDataModel(mainLabelSetting: "Progression", secondLabelSetting: "Prompt values: from last training or constant value", segmentedControlFirstSegmentTitle: "LAST", segmentedControlSecondSegmentTitle: "CONSTANT"),
        WorkoutSettingsDataModel(mainLabelSetting: "Vibrations", secondLabelSetting: "Vibrations when pause is finished", segmentedControlFirstSegmentTitle: nil, segmentedControlSecondSegmentTitle: nil)]
        
        callBack(workoutModels)
    }
}

struct WorkoutControllersModel {
    var unitSegmentedController: Int
    var placeholderValueSegmentedController: Int
    var vibrationSwitcherController: Bool
    
    init() {
        self.unitSegmentedController = 0
        self.placeholderValueSegmentedController = 0
        self.vibrationSwitcherController = false
    }
}
