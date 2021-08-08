//
//  ChartPresenter.swift
//  GymLog
//
//  Created by Kacper P on 07/08/2021.
//

import Foundation
import Charts

protocol ChartPresenterDelegate: class {
    func setAxisFormatter(axisFormatter: ChartXAxisFormatter)
    func setData(dataSet: [LineChartDataSet])
}

class ChartPresenter {
    
    weak var chartPresenterDelegate: ChartPresenterDelegate?
    let dateFormatter = DateFormatter()
    var lineChartEntries = [ChartDataEntry]()
    var dataSets: [LineChartDataSet] = [LineChartDataSet]()
    
    init(chartPresenterDelegate: ChartPresenterDelegate) {
        self.chartPresenterDelegate = chartPresenterDelegate
    }
    
    let chartService = ChartService()
    let periodSelection = ChartPeriodSelection()
    let dispatchGroup = DispatchGroup()
    
    var sortedLineChartEntries: [ChartDataEntry] {
        let sortedArray = lineChartEntries.sorted(by: {$0.x < $1.x})
        return sortedArray
    }
    
    var arrayOfWorkoutTitles: [String] {
        guard let array =  UserDefaults.standard.object(forKey: "workoutsName") as? [String] else { return []}
        return array
    }
    
    var exercisesInWorkout: [String: [String]] {
        guard let exercises = UserDefaults.standard.object(forKey: "exercises") as? [String: [String]] else { return [:]}
        return exercises
    }
    
    var weightUnit: String {
        UserDefaults.standard.string(forKey: "unit") ?? "kg"
    }
    
    var referenceTimeInterval: TimeInterval = 0
    
    var exercisesForSelectedWorkout: [String] = []
    
    var allWorkouts: [String: [DoneWorkoutInformation]] = [:]
    
    var retrievedByExercise: [DoneExercise] = []
    
    var retrievedExerciseMax: [String: [RetrievedWorkoutMax]] = [:]
    
    
    //MARK: - CONNECTION WITH SERVICE
    
    func getExercisesForSelectedWorkout(workoutTitle: String) {
        //Set button title
        chartService.getDocumentForOneWorkout(workout: workoutTitle) { (result) in
            self.exercisesForSelectedWorkout = result
        }
    }

    func getDataByVolume(titles: [String]) {

        chartService.getDataByVolume(titles: titles) { (data) in
            self.allWorkouts = data
            self.newFindTrainingVolume(data: data)
            // self.changeLabelsForVolume()
            // self.lineChart.xAxis.spaceMax = 0.2
        }
    }
    
    func getDataByExercise(title: String, document: String) {
      
//        retrievedByExercise = []
        chartService.getDataByExercise(title: title, document: document) { (data) in
            self.retrievedByExercise = data
//            self.convertDateForAxis()
//            self.findByExercise(criteria: "Weight", period: "year")
        }
    }
    
    func getData(title: String) {
        
        chartService.getAllExercisesInWorkout(title: title, arrayOfDocuments: exercisesInWorkout) { (data) in
//            self.retrievedExerciseMax = data
//            self.convertDateForAxis()
//            self.findMaxValue(type: "Weight", period: "year")
//            print("TO BYLO WCZESNIEJ \(self.retrievedExerciseMax)")
        }
    }
    
    func convertDateForAxis() {
        
        if let minTimeInterval = (allWorkouts.compactMap({$0.value}).compactMap({$0.compactMap({$0.date})}).min(by: {$0[0].timeIntervalSince1970 < $1[0].timeIntervalSince1970}))?.min() {
            referenceTimeInterval = minTimeInterval.timeIntervalSince1970
        }
    }

    
    //MARK: -CHARTS
    
    func weekData<T: DateFieldForSelecton> (data: [String:[T]]) -> [String:[T]] {
        return periodSelection.valuesForWeekNEW(data: data)
    }
    
    func monthData<T: DateFieldForSelecton> (data: [T]) -> [T] {
        return periodSelection.valuesForMonth(data: data)
    }
    
    func newFindTrainingVolume<T: ChartDataProtocols> (data: [String: [T]]) {
   
      
        lineChartEntries = []
        dataSets = []
        convertDateForAxis()
        
        for (key, values) in data {
            
            dispatchGroup.enter()
            lineChartEntries = []
            
            for value in values {
                
                let date = value.date
                let timeInterval = date.timeIntervalSince1970
                let xValue = (timeInterval - referenceTimeInterval) / (3600 * 24)
                
                let volume = value.volume
                let highlightedValue = HighlightedExercise(sets: value.sets, reps: value.reps, time: "")
                
                lineChartEntries.append(ChartDataEntry(x: xValue, y: volume, data: highlightedValue))
            }
                
            let set = LineChartDataSet(entries: sortedLineChartEntries, label: "\(key)")
            dataSets.append(set)
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            self.chartPresenterDelegate?.setData(dataSet: self.dataSets)
        }
    }
    
    func findByExercise(criteria: String, period: String) {
        
        setAxisFormatter()
        lineChartEntries = []
        dataSets = []
        convertDateForAxis()

        var newData: [DoneExercise] = []
        
        let group2 = DispatchGroup()
        
        var titleOfExercise: String = ""
     
        for value in newData {
            group2.enter()
            let date = value.date
            
            let timeInterval = date.timeIntervalSince1970
            let xValue = (timeInterval - referenceTimeInterval) / (3600 * 24)
            
            let weight = value.weight
            let volume = value.volume
            
            let highlightedValue = HighlightedExercise(sets: value.sets ,reps: value.reps, time: "")
       
            titleOfExercise = value.exerciseTitle
            
            if criteria == "Weight" {
            lineChartEntries.append(ChartDataEntry(x: xValue, y: Double(weight), data: highlightedValue))
            }
            else {
                lineChartEntries.append(ChartDataEntry(x: xValue, y: Double(volume), data: highlightedValue))
            }
            group2.leave()
        }
       
        lineChartEntries.sort(by: { $0.x < $1.x})
        let set = LineChartDataSet(entries: lineChartEntry1, label: "\(titleOfExercise)")
        group2.notify(queue: .main) {
   
            self.dataSets.append(set)
//            self.setData2(entries: self.dataSets)
  
        }
    }

    
        
        func segmentedControlSelect(selectedIndex: Int) {
            if selectedIndex == 0 {
                newFindTrainingVolume(data: allWorkouts)
            } else if selectedIndex == 1 {
                newFindTrainingVolume(data: weekData(data: allWorkouts))
//                doDataEntries(data: monthData)
            } else {
//                doDataEntries(data: dataPresenter)
            }
        }
    
    func setAxisFormatter() {
        dateFormatter.dateFormat = DateFormats.formatYearMonthDay
        let axisFormatter = ChartXAxisFormatter(referenceTimeInterval: referenceTimeInterval, dateFormatter: dateFormatter)
        chartPresenterDelegate?.setAxisFormatter(axisFormatter: axisFormatter)
    }
}
