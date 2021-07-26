//
//  BodyWeightCalendarPresenter.swift
//  GymLog
//
//  Created by Kacper P on 23/07/2021.
//

import Foundation

protocol BodyWeightCalendarPresenterDelegate: class {
    func passBodyWeightCalendarData(data: [BodyWeightCalendarModel])
}

class BodyWeightCalendarPresenter {
    
    var bodyWeightService: BodyWeightServiceProtocol = BodyWeightService()
    weak var bodyWeightCalendarPresenterDelegate: BodyWeightCalendarPresenterDelegate?
    
    init(bodyWeightCalendarPresenterDelegate: BodyWeightCalendarPresenterDelegate) {
        self.bodyWeightCalendarPresenterDelegate = bodyWeightCalendarPresenterDelegate
    }
    
    func getBodyWeightCalendarData() {
        bodyWeightService.getData { [weak self] data in
            guard let self = self else { return }
            self.bodyWeightCalendarPresenterDelegate?.passBodyWeightCalendarData(data: data)
        }
    }
    
    func saveNewWeight(newWeight: String) {
        bodyWeightService.saveNewWeight(weight: newWeight)
    }
    
    
//    func getData() {
//        bodyWeightService.getData { (data) in
//            self.arrayWithWeight = data
//        }
//    }
//
//    func saveInDatabase(completion: () -> Void) {
//
//        if let weightValue = weightTextField.text {
//
//            if weightValue.contains("kg") == true {
//
//                let weightAfterDropLast = String(weightValue.dropLast(2).trimmingCharacters(in: .whitespaces))
//
//                bodyWeightService.saveNewWeight(weight: weightAfterDropLast)
//
//            } else {
//                bodyWeightService.saveNewWeight(weight: weightValue.trimmingCharacters(in: .whitespaces))
//
//            }
//            completion()
//        }
//    }
}
