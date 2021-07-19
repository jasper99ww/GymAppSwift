//
//  WorkoutPresenter.swift
//  GymLog
//
//  Created by Kacper P on 19/07/2021.
//

import Foundation

protocol WorkoutPresenterDelegateForView: class {
    func getWorkoutModel(workoutModel: [WorkoutSettingsDataModel])
}

protocol WorkoutPresenterUserDefaults: class {
    func saveSelectedUnitInMemory(unit: String)
    func setPlaceholderValueInTraining(value: Bool)
}

protocol WorkoutPresenterDataChange: class {
   func changeUnitFromKGtoLBInCalendar()
   func changeUnitFromKGtoLBInHistory()
   func changeUnitFromLBtoKGInCalendar()
   func changeUnitFromLBtoKGInHistory()
}

class WorkoutPresenter {
    
    weak var workoutPresenterDelegateForView: WorkoutPresenterDelegateForView?
    
    var constantValueInPlaceholder: Bool = false
    
    let workoutSettingsService = WorkoutSettingsService()
    
    var workoutModel: WorkoutModel
    
    init(workoutmodel: WorkoutModel, workoutPresenterDelegateForView: WorkoutPresenterDelegateForView) {
        self.workoutModel = workoutmodel
        self.workoutPresenterDelegateForView = workoutPresenterDelegateForView
    }
    
    func getModel() {
        workoutModel.getWorkoutSettingsLabels { [weak self] workoutModels in
            self?.workoutPresenterDelegateForView?.getWorkoutModel(workoutModel: workoutModels)
        }
    }
    
    func placeholderConstantValue(value: Bool) {
        UserDefaults.standard.setValue(value, forKey: "placeholderConstantValue")
    }
}

extension WorkoutPresenter: WorkoutPresenterDataChange {
    
    func changeUnitFromKGtoLBInHistory() {
        workoutSettingsService.changeUnitFromKGtoLBInHistory()
    }
    
    func changeUnitFromLBtoKGInHistory() {
        workoutSettingsService.changeUnitFromLBtoKGInHistory()
    }
    
    func changeUnitFromKGtoLBInCalendar() {
        workoutSettingsService.changeUnitFromKGtoLBInCalendar()
    }
    
    func changeUnitFromLBtoKGInCalendar() {
        workoutSettingsService.changeUnitFromLBtoKGInCalendar()
    }
}

extension WorkoutPresenter: WorkoutPresenterUserDefaults {
    func saveSelectedUnitInMemory(unit: String) {
        UserDefaults.standard.setValue(unit, forKey: "unit")
    }
    
    func setPlaceholderValueInTraining(value: Bool) {
        UserDefaults.standard.setValue(value, forKey: "placeholderConstantValue")
    }
}
