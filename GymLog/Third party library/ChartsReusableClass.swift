//
//  ChartsReusableClass.swift
//  GymLog
//
//  Created by Kacper P on 28/07/2021.
//

import Foundation
import Charts
//
//protocol ChartReusableClassDelegate: class {
//    func convertDateForAxis()
////    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight)
//    func createDataEntry()
//}
//
//class ChartsReusableClass: ChartViewDelegate {
//    
//    weak var chartReusableClassDelegate: ChartReusableClassDelegate?
//    var chartView: LineChartView
//    var tableView = UITableView()
//    var lineChartEntries = [ChartDataEntry]()
//    var delegate: ChartViewDelegate
//    
//    init(chartReusableClassDelegate: ChartReusableClassDelegate, chartView: LineChartView, entries: [ChartDataEntry], delegate: ChartViewDelegate) {
//        
//        self.chartReusableClassDelegate = chartReusableClassDelegate
//        self.chartView = chartView
//        self.lineChartEntries = entries
//        self.delegate = delegate
//        doDataEntries(period: "year")
//      
//    }
//    
//    
//    func setChartProperties() {
//print("SETTING CHART")
////        viewChart.layer.cornerRadius = 20
//        
//        chartView.backgroundColor = .clear
//
//        chartView.rightAxis.enabled = false
//        chartView.scaleXEnabled = true
//
//        let yAxis = chartView.leftAxis
//        yAxis.labelFont = .boldSystemFont(ofSize: 12)
//        yAxis.setLabelCount(6, force: false)
//        yAxis.axisMinimum = 0
//        yAxis.labelTextColor = .white
//        yAxis.axisLineColor = .clear
//        yAxis.labelPosition = .outsideChart
//        yAxis.drawGridLinesEnabled = true
//
////        chartView.xAxis.setLabelCount(arrayWithSelectedPeriod.count, force: false)
//
//        chartView.xAxis.labelPosition = .bottom
//        chartView.xAxis.avoidFirstLastClippingEnabled = true
//        chartView.xAxis.granularity = 1
//
//        chartView.xAxis.labelFont = .systemFont(ofSize: 14)
//
//        chartView.xAxis.axisLineColor = .white
//        chartView.xAxis.labelTextColor = .white
//        chartView.xAxis.drawGridLinesEnabled = false
//        chartView.legend.enabled = false
//
//        self.chartView.animate(xAxisDuration: 0.04 * Double(self.lineChartEntries.count), easingOption: .linear)
////        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
////            if let lineChartX = self.lineChartEntries.last?.x, let lineChartY = self.lineChartEntries.last?.y {
////                self.weightChart.highlightValue(x: lineChartX, y: lineChartY, dataSetIndex: 0)
//////            }
////        }
//    }
//    
////    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
////        
////        chartReusableClassDelegate?.chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight)
//
////        guard let dataSet = chartView.data?.dataSets[highlight.dataSetIndex] else { return }
////
////        let indexOfEntry : Int = ((self.tableView.numberOfRows(inSection: 0) - 1 ) - dataSet.entryIndex(entry: entry))
////
////        let indexPath = IndexPath(row: indexOfEntry, section: 0)
////
////
////        self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
//
//    
//    
//    func setDataSetProperties(set: LineChartDataSet) {
//
//        set.setColor(Colors.greenColor)
//        set.mode = .cubicBezier
//        set.drawCirclesEnabled = true
//        set.circleColors = set.colors
//        set.drawCircleHoleEnabled = true
//        set.circleRadius = 6
//        set.circleHoleRadius = 4
////        set.circleHoleColor = view.backgroundColor
//        set.lineWidth = 4
//        set.drawHorizontalHighlightIndicatorEnabled = false
//        set.highlightColor = .red
//        set.drawValuesEnabled = false
//
//        let colorLocations: [CGFloat] = [0.0, 1.0]
//
//        let gradColors = [Colors.greenColor.cgColor, UIColor.clear.cgColor]
//        if let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradColors as CFArray, locations: colorLocations) {
//            set.fill = Fill(linearGradient: gradient, angle: 90.0)
//        }
//        set.drawFilledEnabled = true
//
////        setChartProperties()
//    }
//    
//    func convertDateForAxis() {
//        chartReusableClassDelegate?.convertDateForAxis()
////        if let minTimeInterval = arrayWithEntries.compactMap({$0.date}).min() {
////            referenceTimeInterval = minTimeInterval.timeIntervalSince1970
////        }
//    }
//    
//        func doDataEntries(period: String) {
//    
////            let group = DispatchGroup()
//    
////            arrayWithSelectedPeriod = []
//            
//            chartReusableClassDelegate?.createDataEntry()
//    
////            if period == "year" {
////
////                arrayWithSelectedPeriod = []
////                group.enter()
////              arrayWithSelectedPeriod = arrayWithEntries
////                convertDateForAxis()
////                group.leave()
////            } else if period == "month" {
////
////                group.enter()
////                periodSelection.loopForMonth(data: arrayWithEntries) { (data) in
////                    arrayWithSelectedPeriod = data
////                }
////              group.leave()
////            }
////             else if period == "week" {
////
////                group.enter()
////                periodSelection.loopForWeek(data: arrayWithEntries) { (data) in
////                   arrayWithSelectedPeriod = data
////                }
////                group.leave()
////            } else {
////                print("No weight measurement in this week")
////            }
////
////            let dispatchGroup = DispatchGroup()
////    //        convertDateForAxis()
////            lineChartEntries = []
////            dateFormatter.dateFormat = "yyyy-MM-dd"
////
////            weightChart.xAxis.valueFormatter = ChartXAxisFormatter(referenceTimeInterval: referenceTimeInterval, dateFormatter: dateFormatter)
////
////            for value in arrayWithSelectedPeriod {
////                dispatchGroup.enter()
////
////                let date = value.date
////
////                let timeInterval = date.timeIntervalSince1970
////                let xValue = (timeInterval - referenceTimeInterval) / (3600 * 24)
////
////                lineChartEntries.append(ChartDataEntry(x: xValue, y: Double(value.weight)))
////
////                dispatchGroup.leave()
////            }
////
////
////            let set = LineChartDataSet(entries: lineChartEntries)
////
////            let data = LineChartData(dataSet: set)
////            setDataSetProperties(set: set)
////
////            self.weightChart.data = data
////
//        }
//}
//
//

