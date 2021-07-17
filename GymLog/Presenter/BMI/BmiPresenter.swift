//
//  BmiPresenter.swift
//  GymLog
//
//  Created by Kacper P on 17/07/2021.
//

import Foundation


struct BmiPresenter {
    
    let bmiModel: BMIModel
    
    func getChosenBmiParameteres(height: Float, weight: Float) {
        self.bmiModel.height = height
        self.bmiModel.weight = weight
    }
}
