//
//  BmiResultPresenter.swift
//  GymLog
//
//  Created by Kacper P on 17/07/2021.
//

import Foundation
import UIKit


protocol BmiResultPresenterDelegate: class {
    func setBmiValue(value: String)
    func setBmiAdvice(advice: String)
    func setBmiDiagnosis(diagnosis: String)
    func setColor(color: UIColor)
    
}

class BmiResultPresenter {
    
    weak private var bmiResultPresenterDelegate: BmiResultPresenterDelegate?
    
    private var bmiValueOneDecimalPlace: String  {
        return String(format: "%.1f", bmiModel.bmi.value)
    }
    
    let bmiModel: BMIModel
    
    init(bmi: BMIModel) {
      
        self.bmiModel = bmi
    
    }
    
    func getModel() {
        bmiResultPresenterDelegate?.setBmiAdvice(advice: bmiModel.bmi.advice)
        bmiResultPresenterDelegate?.setBmiValue(value: bmiValueOneDecimalPlace)
        bmiResultPresenterDelegate?.setColor(color: bmiModel.bmi.color)
        bmiResultPresenterDelegate?.setBmiDiagnosis(diagnosis: bmiModel.bmi.diagnosis)
      
    }
    
    func setViewDelegate(bmiResultPresenterDelegate: BmiResultPresenterDelegate?) {
        self.bmiResultPresenterDelegate = bmiResultPresenterDelegate
    }
   
}
