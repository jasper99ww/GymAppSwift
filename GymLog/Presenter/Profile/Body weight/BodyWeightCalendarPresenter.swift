//
//  BodyWeightCalendarPresenter.swift
//  GymLog
//
//  Created by Kacper P on 23/07/2021.
//

import Foundation


protocol BodyWeightCalendarPresenterDelegate: class {
    func passBodyWeightCalendarData(data: [BodyWeightCalendarModel])
    func updateIfSavedInSelectedDate(value: String)
    func updateIfNoSaveInSelectedDate()
    func checkIfEnableButtons(enable: Bool)
}

class BodyWeightCalendarPresenter {
    
    var bodyWeightService: BodyWeightServiceProtocol = BodyWeightService()
    weak var bodyWeightCalendarPresenterDelegate: BodyWeightCalendarPresenterDelegate?
    var bodyWeightCalendarModel = [BodyWeightCalendarModel]()
    

    let todayDate = Date().getFormattedDate(format: DateFormats.formatYearMonthDay)
    
    init(bodyWeightCalendarPresenterDelegate: BodyWeightCalendarPresenterDelegate) {
        self.bodyWeightCalendarPresenterDelegate = bodyWeightCalendarPresenterDelegate
    }
    
    func getBodyWeightCalendarData() {
        bodyWeightService.getData { [weak self] data in
            guard let self = self else { return }
            self.bodyWeightCalendarPresenterDelegate?.passBodyWeightCalendarData(data: data)
            self.bodyWeightCalendarModel = data
        }
    }
    
    func saveNewWeight(newWeight: String) {
        bodyWeightService.saveNewWeight(weight: newWeight)
    }
    
    func checkIfSavedWeightSelectedDate(selectedDate: Date){
        
        let selectedDateString = selectedDate.getFormattedDate(format: DateFormats.formatYearMonthDay)

        if let selectedCell = bodyWeightCalendarModel.first(where: {$0.date.getFormattedDate(format: DateFormats.formatYearMonthDay) == selectedDateString}) {
            let selectedWeight = String(format: "%.1f", selectedCell.weight)
            bodyWeightCalendarPresenterDelegate?.updateIfSavedInSelectedDate(value: selectedWeight)
        }
    }
    
    func informUserAboutNoSave(selectedDate: Date) {
       // Check if arrayWithWeight contains selectedValue and selected cell is not today's cell, if it's false, inform a user that there is no save
        let selectedDateString = selectedDate.getFormattedDate(format: DateFormats.formatYearMonthDay)
        
        if !bodyWeightCalendarModel.contains(where: {$0.date.getFormattedDate(format: DateFormats.formatYearMonthDay) == selectedDateString}) && selectedDateString != todayDate {
            bodyWeightCalendarPresenterDelegate?.updateIfNoSaveInSelectedDate()
        }
    }
    
    func updateButtonPropertiesAfterSelection(selectedDate: Date) {
            //Change buttons properties, if selected date is not today date
        let selectedDateString = selectedDate.getFormattedDate(format: DateFormats.formatYearMonthDay)
        if selectedDateString != todayDate {
            bodyWeightCalendarPresenterDelegate?.checkIfEnableButtons(enable: false)
            } else {
                bodyWeightCalendarPresenterDelegate?.checkIfEnableButtons(enable: true)
            }
    }

}
