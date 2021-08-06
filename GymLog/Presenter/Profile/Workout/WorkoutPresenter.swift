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

protocol WorkoutPresenterControllersState: class {
    func getControllersStates(workoutControllersModel: WorkoutControllersModel)
}

class WorkoutPresenter {
    
    typealias WorkoutServiceProtocols = DataInHistoryServiceProtocol & DataInCalendarServiceProtocol
    let workoutSettingsService: WorkoutServiceProtocols = WorkoutSettingsService()
    
    weak var workoutPresenterDelegateForView: WorkoutPresenterDelegateForView?
    weak var workoutPresenterControllersState: WorkoutPresenterControllersState?
    
    var workoutModel: WorkoutModel
    var workoutControllersModel = WorkoutControllersModel()
    
    init(workoutmodel: WorkoutModel, workoutPresenterDelegateForView: WorkoutPresenterDelegateForView, workoutPresenterControllersState: WorkoutPresenterControllersState) {
        self.workoutModel = workoutmodel
        self.workoutPresenterDelegateForView = workoutPresenterDelegateForView
        self.workoutPresenterControllersState = workoutPresenterControllersState

    }
    
    func getModel() {
        workoutModel.getWorkoutSettingsLabels { [weak self] workoutModels in
            self?.workoutPresenterDelegateForView?.getWorkoutModel(workoutModel: workoutModels)
        }
    }
    
    func getControllersStates() {
        getSegmentedControlStateUnit()
        getSegmentedControlStatePlaceholderValue()
        getSwitchState()
        workoutPresenterControllersState?.getControllersStates(workoutControllersModel: workoutControllersModel)
    }
    
    func getSegmentedControlStateUnit() {
        
        if UserDefaults.standard.string(forKey: "unit") == "kg" {
            workoutControllersModel.unitSegmentedController = 0
        } else {
            workoutControllersModel.unitSegmentedController = 1
        }
    }
    
    func getSegmentedControlStatePlaceholderValue() {
        
        if UserDefaults.standard.bool(forKey: "placeholderConstantValue") {
            workoutControllersModel.placeholderValueSegmentedController = 1
        } else {
            workoutControllersModel.placeholderValueSegmentedController = 0
        }
    }
    
    func getSwitchState() {
        if UserDefaults.standard.bool(forKey: "vibrations") {
            workoutControllersModel.vibrationSwitcherController = true
        } else {
            workoutControllersModel.vibrationSwitcherController = false
        }
    }
    
    
    // FIREBASE

    func changeUnitFromKGtoLBInHistory() {
        workoutSettingsService.changeUnitFromKGtoLBInCalendar()
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

    //USER DEFAULTS
    
    func saveSelectedUnitInMemory(unit: String) {
        UserDefaults.standard.setValue(unit, forKey: "unit")
    }
    
    func setPlaceholderValueInTraining(value: Bool) {
        UserDefaults.standard.setValue(value, forKey: "placeholderConstantValue")
    }
    
    func saveSwitchState(state: Bool) {
        UserDefaults.standard.setValue(state, forKey: "vibrations")
    }
    
    func updateChangesLimitSegmentedControl(limitExhausted: Bool) {
        UserDefaults.standard.setValue(limitExhausted, forKey: "changesLimit")
        
    }
    
    func getSelectedUnit() -> Int {
        if UserDefaults.standard.string(forKey: "unit") == "kg" {
            return 0
        } else {
            return 1
        }
    }
    
    func checkLimitChanges() -> Bool {
        let limitExhausted = UserDefaults.standard.bool(forKey: "changesLimit")
        return limitExhausted
    }
}
