//
//  BodyWeightCaloriesPresent.swift
//  GymLog
//
//  Created by Kacper P on 05/08/2021.
//


protocol BodyWeightCaloriesPresenterDelegate: class {
    func calculateHeight(height: String)
    func calculateWeight(weight: String)
    func minusButtonTapped(value: String)
    func plusButtonTapped(value: String)
    func showAlertIncompleteData()
    func performSegueAfterCalculation()
}

protocol BodyWeightCaloriesPickerDelegate: class {
    func updatePickerData(data: [ActivityLevels])
}

import Foundation

class BodyWeightCaloriesPresenter {
    
    var age = 25
    var gender: String?
    var weightInt: Int?
    var heightInt: Int?
    var activityIndex: Double?
    var caloriesRequirement = Int()
    let caloriesPickerController = CaloriesPickerController()
    let bodyWeightCaloriesModel = BodyWeightCaloriesModel()
    
    var ageString: String {
        return String(age)
    }
    
    var weightUnit: String {
        UserDefaults.standard.string(forKey: "unit") ?? "kg"
    }
    
    weak var bodyWeightCaloriesPresenterDelegate: BodyWeightCaloriesPresenterDelegate?
    weak var bodyWeightCaloriesPickerDelegate: BodyWeightCaloriesPickerDelegate?
    
//    init(bodyWeightCaloriesPresenterDelegate: BodyWeightCaloriesPresenterDelegate) {
//        self.bodyWeightCaloriesPresenterDelegate = bodyWeightCaloriesPresenterDelegate
//    }
    
    func getPickerData() {
       let pickerData = bodyWeightCaloriesModel.getActivityLevels()
        bodyWeightCaloriesPickerDelegate?.updatePickerData(data: pickerData)
    }
    
    func alertIncompleteData() {
        bodyWeightCaloriesPresenterDelegate?.showAlertIncompleteData()
    }
    
    func calculateCalories() {

        guard let weightValue = weightInt, let heightValue = heightInt, let activityIndexValue = activityIndex, let genderValue = gender else { return alertIncompleteData() }
    
        if genderValue == "male" {
        caloriesRequirement = Int((66.47 + 13.75 * Double(weightValue) + 5.03 * Double(heightValue) - 6.7550 * Double(age)) * activityIndexValue)
        } else {
            caloriesRequirement = Int((665.09 + 8.56 * Double(weightValue) + 1.84 * Double(heightValue) - 4.67 * Double(age)) * activityIndexValue)
        }
        
        bodyWeightCaloriesPresenterDelegate?.performSegueAfterCalculation()
    }
    
    func activityIndexSelected(activity index: String) {
        
        switch index {
        case "Sedentary":
            activityIndex = 1.2
        case "Low":
            activityIndex = 1.3
        case "Moderately":
            activityIndex = 1.4
        case "Active":
            activityIndex = 1.5
        case "Very active":
            activityIndex = 1.7
        default:
            activityIndex = 1.4
            print("activity index is not chossen")
        }
    }
    
    func plusButton() {
        guard age >= 1 else { return }
        age += 1
        bodyWeightCaloriesPresenterDelegate?.plusButtonTapped(value: ageString)
    }
    
    func minusButton() {
        guard age >= 1 else { return }
        age -= 1
        bodyWeightCaloriesPresenterDelegate?.minusButtonTapped(value: ageString)
    }
    
    func calculateHeight(height: Float) {
        let heightInCm = valueToIntToString(height)
        heightInt = Int(height)
        let heightInInch = cmToFootAndInches(Double(height))
        let heightLabelText = heightInCm + "cm (\(heightInInch))"
        bodyWeightCaloriesPresenterDelegate?.calculateHeight(height: heightLabelText)
    }
    
    func calculateWeight(weight: Float) {
        let weightString = valueToIntToString(weight)
        weightInt = Int(weight)
        let weightLabelText = weightString + "\(weightUnit)"
        bodyWeightCaloriesPresenterDelegate?.calculateWeight(weight: weightLabelText)
    }
    
    func valueToIntToString(_ value: Float) -> String {
        let valueInt = Int(value)
        let valueString = String(valueInt)
        return valueString
    }
    
    func cmToFootAndInches(_ cm: Double) -> String {
        
        let feet = cm * 0.0328084
        let feetFloor = Int(floor(feet))
        let feetRest: Double = ((feet * 100).truncatingRemainder(dividingBy: 100) / 100)
        let inches = Int(floor(feetRest * 12))
        
        return "\(feetFloor)' \(inches)\""
    }
}

