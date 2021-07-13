//
//  BmiCalculator.swift
//  GymLog
//
//  Created by Kacper P on 13/07/2021.
//

import UIKit

struct BmiCalculator {
    
    var bmi: BMI?
    
    
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
     
        if bmiValue < 18.5 {
            bmi = BMI(value: bmiValue, advice: "You should eat more calories", color: .red, diagnosis: "Underweight")
        } else if bmiValue < 24.9 {
            bmi = BMI(value: bmiValue, advice: "Your weight is great! Keep it up!", color: .green, diagnosis: "")
        } else {
            bmi = BMI(value: bmiValue, advice: "You should eat less calories", color: .red, diagnosis: "Overweight")
        }
    }
    
    
    
}
