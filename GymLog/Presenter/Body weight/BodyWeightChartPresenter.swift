//
//  BodyWeightChartPresenter.swift
//  GymLog
//
//  Created by Kacper P on 28/07/2021.
//

import Foundation

protocol BodyWeightChartPresenterDelegate: class {
    
    func setData(data: [BodyWeightCalendarModel])
}

class BodyWeightChartPresenter {
    
//    let bodyWeightModel: BodyWeightCalendarModel
    weak var bodyWeightChartPresenterDelegate: BodyWeightChartPresenterDelegate?

    init(bodyWeightChartPresenterDelegate: BodyWeightChartPresenterDelegate) {
        self.bodyWeightChartPresenterDelegate = bodyWeightChartPresenterDelegate
    }
    
    func setData(data: [BodyWeightCalendarModel]) {
        bodyWeightChartPresenterDelegate?.setData(data: data)
    }
}
