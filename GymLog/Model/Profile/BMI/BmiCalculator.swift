//
//  BmiCalculator.swift
//  GymLog
//
//  Created by Kacper P on 13/07/2021.
//

import UIKit

protocol BmiCalculatorDelegate: class {
    func getBmi(bmi: BMI)
}

struct BmiCalculator {
    
    var bmi: BMI?
    
    weak var bmiCalculatorDelegate: BmiCalculatorDelegate?
    
    func getBMIValue() -> String {
        let bmiValueOneDecimalPlace = String(format: "%.1f", bmi?.value ?? 0.0)
        return bmiValueOneDecimalPlace
    }
    
    func getAdvice() -> String {
        return bmi?.advice ?? "No advice"
    }
    
    func getColor() -> UIColor {
        return bmi?.color ?? .white
    }
    
    func getDiagnosis() -> String {
        return bmi?.diagnosis ?? "No diagnosis"
    }
    
    mutating func calculateBmi(height: Float, weight: Float) {
        
        let bmiValue = weight / pow(height, 2)
     print("STARTED, bmiValue is \(bmiValue)")
        if bmiValue < 18.5 {
            bmi = BMI(value: bmiValue, advice: "You should eat more calories", color: .red, diagnosis: "Underweight")
          
            bmiCalculatorDelegate?.getBmi(bmi: bmi!)
            print("DONE")
        } else if bmiValue < 24.9 {
            bmi = BMI(value: bmiValue, advice: "Your weight is great! Keep it up!", color: .green, diagnosis: "")
           
            bmiCalculatorDelegate?.getBmi(bmi: bmi!)
        } else {
            bmi = BMI(value: bmiValue, advice: "You should eat less calories", color: .red, diagnosis: "Overweight")
        
            bmiCalculatorDelegate?.getBmi(bmi: bmi!)
        }
    }
    
    
    
}
