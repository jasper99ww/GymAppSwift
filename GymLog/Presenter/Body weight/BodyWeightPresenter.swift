//
//  BodyWeightPresenter.swift
//  GymLog
//
//  Created by Kacper P on 22/07/2021.
//

import Foundation

protocol BodyWeightPresenterDelegate: class {
    func getData(data: [BodyWeightModel])
}

class BodyWeightPresenter {
    
    weak var bodyWeightPresenterDelegate: BodyWeightPresenterDelegate?
    
    var bodyWeightModel = BodyWeightModel()
    
    init(bodyWeightPresenterDelegate: BodyWeightPresenterDelegate) {
        self.bodyWeightPresenterDelegate = bodyWeightPresenterDelegate
    }
    
    func getModel() {
        bodyWeightModel.getBodyWeightModel { (model) in
            bodyWeightPresenterDelegate?.getData(data: model)
        }
    }
    
}
