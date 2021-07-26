//
//  BMI.swift
//  GymLog
//
//  Created by Kacper P on 13/07/2021.
//

import UIKit

struct BMI {
    let value: Float
    let advice: String
    let color: UIColor
    let diagnosis: String
}

class BMIModel {
    
    var weight: Float = 0 {
        didSet {
        calculateBMI()
        }
    }
    
    var height: Float = 0 {
        didSet {
        calculateBMI()
        }
    }
    
    var bmi: BMI
    
    init() {
        self.bmi = BMI(value: 0, advice: "You should eat more calories", color: .red, diagnosis: "Underweight")
    }
    
    private func calculateBMI() {
        
        let bmiValue = self.weight / pow(self.height, 2)
      
        
        if bmiValue < 18.5 {
            self.bmi = BMI(value: bmiValue, advice: "You should eat more calories", color: .red, diagnosis: "Underweight")
            print("Set 1")
        } else if bmiValue < 24.9 {
            self.bmi = BMI(value: bmiValue, advice: "Your weight is great! Keep it up!", color: .green, diagnosis: "")
            print("Set 2")
        } else {
            self.bmi = BMI(value: bmiValue, advice: "You should eat less calories", color: .red, diagnosis: "Overweight")
            print("Set 3")
        }
    }
}
