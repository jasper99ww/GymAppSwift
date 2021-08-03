//
//  BodyWeightChartViewController.swift
//  GymLog
//
//  Created by Kacper P on 28/07/2021.
//

import UIKit
import Charts

class BodyWeightChartViewController: UIViewController, ChartViewDelegate {
    
    lazy var bodyWeightChartPresenter = BodyWeightChartPresenter(dataPresenter: bodyWeightChartData)
    
    let periodSelection = ChartPeriodSelection()
    
    var bodyWeightChartData: [BodyWeightCalendarModel] = [] {
        didSet {
            bodyWeightChartPresenter.sortArray(dataToSort: bodyWeightChartData)
        }
    }
    
    @IBOutlet weak var tableViewUnderChart: UITableView!
    @IBOutlet weak var weightChart: LineChartView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var dataTableView = [BodyWeightCalendarModel]() {
        didSet {
            DispatchQueue.main.async {
                self.tableViewUnderChart?.reloadData()
            }
        }
    }
    
    var arrayWithSelectedPeriod: [BodyWeightCalendarModel] = []

    var referenceTimeInterval: TimeInterval = 0
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        weightChart.delegate = self
        bodyWeightChartPresenter.bodyWeightChartPresenterDelegate = self
        self.tableViewUnderChart.delegate = self
        self.tableViewUnderChart.dataSource = self
        tableViewUnderChart.rowHeight = 90
        bodyWeightChartPresenter.doDataEntries(data: bodyWeightChartData)
        controlSegmentSetUp()
    }
  
    override func viewWillDisappear(_ animated: Bool) {

        guard let viewControllers: [UIViewController] = self.navigationController?.viewControllers else {return}

        guard let previousViewControllerTitle = navigationController?.previousViewController?.title else {return}
     
        if  previousViewControllerTitle == "bodyWeightCalendarViewController" {
            self.navigationController?.popToViewController(viewControllers[viewControllers.count - 2], animated: true)
        }
    }

    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        bodyWeightChartPresenter.segmentedControlSelect(selectedIndex: sender.selectedSegmentIndex)
    }

    func setChartProperties() {
        
        weightChart.backgroundColor = .clear
        weightChart.rightAxis.enabled = false
        weightChart.scaleXEnabled = true

        let yAxis = weightChart.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
        yAxis.setLabelCount(6, force: false)
        yAxis.axisMinimum = 0
        yAxis.labelTextColor = .white
        yAxis.axisLineColor = .clear
        yAxis.labelPosition = .outsideChart
        yAxis.drawGridLinesEnabled = true

        weightChart.xAxis.labelFont = .systemFont(ofSize: 12)
        weightChart.xAxis.setLabelCount(8, force: false)
        weightChart.xAxis.labelTextColor = .white
        weightChart.xAxis.axisLineColor = .white
        weightChart.xAxis.labelPosition = .bottom
        weightChart.xAxis.drawGridLinesEnabled = false
        weightChart.xAxis.avoidFirstLastClippingEnabled = true
        weightChart.xAxis.granularity = 1
        weightChart.xAxis.labelRotationAngle = -45
     
        weightChart.legend.enabled = false
    }

    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {

        guard let dataSet = chartView.data?.dataSets[highlight.dataSetIndex] else { return }

        let indexOfEntry : Int = ((self.tableViewUnderChart.numberOfRows(inSection: 0) - 1 ) - dataSet.entryIndex(entry: entry))
        
        let indexPath = IndexPath(row: indexOfEntry, section: 0)

        self.tableViewUnderChart.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
    }
    
    func setDataSetProperties(set: LineChartDataSet) {

        set.setColor(UIColor.systemGreen)
        set.mode = .horizontalBezier
        set.drawCirclesEnabled = false
        set.lineWidth = 2
        set.drawHorizontalHighlightIndicatorEnabled = false
        set.highlightColor = .red
        set.drawValuesEnabled = false
        set.drawFilledEnabled = true
   
        setColor(set: set)
        setChartProperties()
    }
    
    func setColor(set: LineChartDataSet) {
        let colorLocations: [CGFloat] = [0.0, 1.0]
        let gradColors = [UIColor.systemGreen.cgColor, UIColor.clear.cgColor]
        
        if let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradColors as CFArray, locations: colorLocations) {
            set.fill = Fill(linearGradient: gradient, angle: 90.0)
        }
    }
    
    func controlSegmentSetUp() {

        segmentedControl.selectedSegmentTintColor = Colors.chartColor
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
    }
}

extension BodyWeightChartViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return dataTableView.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableViewUnderChart.dequeueReusableCell(withIdentifier: "bodyWeightCellChart", for: indexPath) as! BodyWeightChartTableViewCell

        cell.configureCell(tableViewData: dataTableView, indexPath: indexPath)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let selectedRow = tableViewUnderChart.numberOfRows(inSection: 0) - 1 - indexPath.row
        
        guard let weightChartData = weightChart.data?.dataSets[0], let newIndex = weightChartData.entryForIndex(selectedRow) else { return }
    
        weightChart.highlightValue(x: newIndex.x, dataSetIndex: 0)
    }
}

extension UINavigationController {
    var previousViewController: UIViewController? {
        viewControllers.count > 1 ? viewControllers[viewControllers.count - 1] : nil
    }
}

extension BodyWeightChartViewController: BodyWeightChartPresenterDelegate {
    
    func setAxisFormatter(axisFormatter: ChartXAxisFormatter) {
        weightChart.xAxis.valueFormatter = axisFormatter
    }
    
    func sortArray(sortedData: [BodyWeightCalendarModel]) {
        dataTableView = sortedData
    }
    
    func doDataEntries(chartData: LineChartData, chartDataSet: LineChartDataSet) {
        setDataSetProperties(set: chartDataSet)
        self.weightChart.data = chartData
        self.weightChart.animate(xAxisDuration: 0.04 * Double(chartDataSet.count), easingOption: .linear)
    }
    
    func setData(data: [BodyWeightCalendarModel]) {
        bodyWeightChartData = data
    }
}

//
//extension BodyWeightChartViewController: ChartReusableClassDelegate {
//
//    func convertDateForAxis() {
//        if let minTimeInterval = arrayWithEntries.compactMap({$0.date}).min() {
//                 referenceTimeInterval = minTimeInterval.timeIntervalSince1970
//            }
//    }
//
////    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
////        guard let dataSet = chartView.data?.dataSets[highlight.dataSetIndex] else { return }
////
////          let indexOfEntry : Int = ((self.tableViewUnderChart.numberOfRows(inSection: 0) - 1 ) - dataSet.entryIndex(entry: entry))
////
////          let indexPath = IndexPath(row: indexOfEntry, section: 0)
////
////
////          self.tableViewUnderChart.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
////
////    }
//
//    func createDataEntry() {
//
//        print("CREATE DATA ENTRY")
//
//
//                arrayWithSelectedPeriod = []
//
//
////                if period == "year" {
////
////                    arrayWithSelectedPeriod = []
////                    group.enter()
////                  arrayWithSelectedPeriod = arrayWithEntries
////                    convertDateForAxis()
////                    group.leave()
////                } else if period == "month" {
////
////                    group.enter()
////                    periodSelection.loopForMonth(data: arrayWithEntries) { (data) in
////                        arrayWithSelectedPeriod = data
////                    }
////                  group.leave()
////                }
////                 else if period == "week" {
////
////                    group.enter()
////                    periodSelection.loopForWeek(data: arrayWithEntries) { (data) in
////                       arrayWithSelectedPeriod = data
////                    }
////                    group.leave()
////                } else {
////                    print("No weight measurement in this week")
////                }
////
//                let dispatchGroup = DispatchGroup()
//        //        convertDateForAxis()
//                lineChartEntries = []
//                dateFormatter.dateFormat = "yyyy-MM-dd"
//
//                weightChart.xAxis.valueFormatter = ChartXAxisFormatter(referenceTimeInterval: referenceTimeInterval, dateFormatter: dateFormatter)
//
//                for value in arrayWithSelectedPeriod {
//                    dispatchGroup.enter()
//
//                    let date = value.date
//
//                    let timeInterval = date.timeIntervalSince1970
//                    let xValue = (timeInterval - referenceTimeInterval) / (3600 * 24)
//
//                    lineChartEntries.append(ChartDataEntry(x: xValue, y: Double(value.weight)))
//
//                    dispatchGroup.leave()
//                }
//
//
//                let set = LineChartDataSet(entries: lineChartEntries)
//
//                let data = LineChartData(dataSet: set)
//                setDataSetProperties(set: set)
//
//                self.weightChart.data = data
//    }
//
//}
