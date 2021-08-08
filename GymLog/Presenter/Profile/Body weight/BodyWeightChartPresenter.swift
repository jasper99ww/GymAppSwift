//
//  BodyWeightChartPresenter.swift
//  GymLog
//
//  Created by Kacper P on 28/07/2021.
//

import Foundation
import Charts

protocol BodyWeightChartPresenterDelegate: class {
    
    func setData(data: [BodyWeightCalendarModel])
    func doDataEntries(chartData: LineChartData,  chartDataSet: LineChartDataSet)
    func sortArray(sortedData: [BodyWeightCalendarModel])
    func setAxisFormatter(axisFormatter: ChartXAxisFormatter)
}


class BodyWeightChartPresenter {
    
    let bodyWeightService = BodyWeightService()
    let periodSelection = ChartPeriodSelection()
    var dateFormatter = DateFormatter()
    var referenceTimeInterval: TimeInterval = 0
    var dataPresenter = [BodyWeightCalendarModel]()
    var lineChartEntries = [ChartDataEntry]()
    
    
    var weekData: [BodyWeightCalendarModel] {
        return periodSelection.valuesForWeek(data: dataPresenter)
    }
    
    var monthData: [BodyWeightCalendarModel] {
        return periodSelection.valuesForMonth(data: dataPresenter)
    }
        
    weak var bodyWeightChartPresenterDelegate: BodyWeightChartPresenterDelegate?

    init(bodyWeightChartPresenterDelegate: BodyWeightChartPresenterDelegate) {
        
        self.bodyWeightChartPresenterDelegate = bodyWeightChartPresenterDelegate
//        self.dataPresenter = dataPresenter
    }
    
    // GETTING DATA
    
    func getBodyWeightChartData() {
        bodyWeightService.getData { [weak self] data in
            guard let self = self else { return }
            self.bodyWeightChartPresenterDelegate?.setData(data: data)
            self.dataPresenter = data
//            self.bodyWeightCalendarModel = data
        }
    }
    
    // TABLE VIEW CELL
    
    func formatTodayDate() -> String {
        let todayDate = Date().getFormattedDate(format: DateFormats.formatYearMonthDay)
        return todayDate
    }
    
    func formatDateWithTime(dateWithTime: Date) -> String {
        let dateWithTimeFormatted = dateWithTime.getFormattedDate(format: DateFormats.formatYearMonthDayTime)
        return dateWithTimeFormatted
    }
    
    func formatDateWithoutTime(dateWithoutTime: Date) -> String {
        let dateWithoutTime = dateWithoutTime.getFormattedDate(format: DateFormats.formatYearMonthDay)
        return dateWithoutTime
    }
    
    
    // TABLE VIEW CONTROLLER
    
    func sortArray(dataToSort: [BodyWeightCalendarModel]) {
        let newArray =  dataToSort.sorted { (a, b) -> Bool in
              a.date > b.date
          }
        bodyWeightChartPresenterDelegate?.sortArray(sortedData: newArray)
    }
    
    func convertDateForAxis() {
        if let minTimeInterval = dataPresenter.compactMap({$0.date}).min() {
            referenceTimeInterval = minTimeInterval.timeIntervalSince1970
        }
    }
    
    func setAxisFormatter() {
        dateFormatter.dateFormat = DateFormats.formatYearMonthDay
        let axisFormatter = ChartXAxisFormatter(referenceTimeInterval: referenceTimeInterval, dateFormatter: dateFormatter)
        bodyWeightChartPresenterDelegate?.setAxisFormatter(axisFormatter: axisFormatter)
    }
    
    func doDataEntries(data: [BodyWeightCalendarModel]) {
        
        let dispatchGroup = DispatchGroup()
        lineChartEntries.removeAll()
        convertDateForAxis()
        setAxisFormatter()

        for value in data {
            dispatchGroup.enter()

            let date = value.date
            let timeInterval = date.timeIntervalSince1970
            let xValue = (timeInterval - referenceTimeInterval) / (3600 * 24)

            lineChartEntries.append(ChartDataEntry(x: xValue, y: Double(value.weight)))

            dispatchGroup.leave()
        }

        let set = LineChartDataSet(entries: lineChartEntries)

        let chartData = LineChartData(dataSet: set)
        
        bodyWeightChartPresenterDelegate?.doDataEntries(chartData: chartData, chartDataSet: set)
    }
    
    func segmentedControlSelect(selectedIndex: Int) {
        if selectedIndex == 0 {
            doDataEntries(data: weekData)
        } else if selectedIndex == 1 {
            doDataEntries(data: monthData)
        } else {
            doDataEntries(data: dataPresenter)
        }
    }
}
