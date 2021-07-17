//
//  BmiViewModel.swift
//  GymLog
//
//  Created by Kacper P on 15/07/2021.
//

import Foundation

//protocol BmiCalculatorDelegate: class {
//    func getBmi(bmi: BMI)
//}

protocol BmiViewControllerDelegate: class {
    func getCalculatedBMI(newBmi: BMI)
}

protocol BmiViewModelDelegate: class {
    func sendValue(height: Float?, weight: Float?)
}

class BmiViewModel: BmiViewModelDelegate {
 
    var bmiModel = BmiCalculator()
    
    var bmi: BMI?
    
    weak var delegateVC: BmiViewControllerDelegate?
    
    
//    init(bmi: BMI) {
//        self.bmi = bmi
//    }

    
    func sendValue(height: Float?, weight: Float?) {
        
        guard let height = height, let weight = weight else { return }
        calculateBmi(height: height, weight: weight)

    
    }
    
    func calculateBmi(height: Float, weight: Float) {
        
        let bmiValue = weight / pow(height, 2)
    
        if bmiValue < 18.5 {
            bmi = BMI(value: bmiValue, advice: "You should eat more calories", color: .red, diagnosis: "Underweight")
            delegateVC?.getCalculatedBMI(newBmi: bmi!)
        } else if bmiValue < 24.9 {
            bmi = BMI(value: bmiValue, advice: "Your weight is great! Keep it up!", color: .green, diagnosis: "")
            delegateVC?.getCalculatedBMI(newBmi: bmi!)
        } else {
            bmi = BMI(value: bmiValue, advice: "You should eat less calories", color: .red, diagnosis: "Overweight")
            delegateVC?.getCalculatedBMI(newBmi: bmi!)
        }
    }
}
    
    
    
    
    
    
    
    
//    if segue.identifier == "toCalculatedBMI" {
//        let destinationViewController = segue.destination as! BMIResultViewController
//        
////            destinationViewController.bmiValue = bmiCalcualtor.getBMIValue()
////            print("value \(bmiCalcualtor.getBMIValue())")
////            destinationViewController.advice = bmiCalculator.getAdvice()
////            destinationViewController.diagnosis = bmiCalculator.getDiagnosis()
////            destinationViewController.color = bmiCalculator.getColor()
//        
//    }
    



