//
//  BodyWeightChartViewController.swift
//  GymLog
//
//  Created by Kacper P on 28/07/2021.
//

import UIKit
import Charts

class BodyWeightChartViewController: UIViewController, ChartViewDelegate {
    
    lazy var bodyWeightChartPresenter = BodyWeightChartPresenter(bodyWeightChartPresenterDelegate: self)
    
    @IBOutlet weak var tableViewUnderChart: UITableView!
    @IBOutlet weak var weightChart: LineChartView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    var bodyWeightChartData: [BodyWeightCalendarModel] = [] {
        didSet {
            bodyWeightChartPresenter.doDataEntries(data: bodyWeightChartData)
            bodyWeightChartPresenter.sortArray(dataToSort: bodyWeightChartData)
        }
    }
    
    var dataTableView = [BodyWeightCalendarModel]() {
        didSet {
            DispatchQueue.main.async {
                self.tableViewUnderChart.reloadData()
            }
        }
    }
            
    override func viewDidLoad() {
        super.viewDidLoad()

        bodyWeightChartPresenter.getBodyWeightChartData()
        weightChart.delegate = self
        self.tableViewUnderChart.delegate = self
        self.tableViewUnderChart.dataSource = self
        tableViewUnderChart.rowHeight = 90
        
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
        weightChart.xAxis.avoidFirstLastClippingEnabled = false
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

        segmentedControl.selectedSegmentTintColor = Colors.strongGreenColor
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

        let dateInData = dataTableView[indexPath.row].date
        
        cell.dateWithTime = bodyWeightChartPresenter.formatDateWithTime(dateWithTime: dateInData)
        cell.todayDate = bodyWeightChartPresenter.formatTodayDate()
        cell.dateWithoutTime = bodyWeightChartPresenter.formatDateWithoutTime(dateWithoutTime: dateInData)
 
        cell.weight = String(dataTableView[indexPath.row].weight)
        
        //Hide progress parameters if first row selected and set values for other rows
        if indexPath.row == dataTableView.count - 1 {
            cell.hideProgressParameters(bool: true)
        } else {
            cell.hideProgressParameters(bool: false)
            cell.progressValue = dataTableView[indexPath.row].weight - dataTableView[indexPath.row + 1].weight
            cell.setProgressParameteres()
        }

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
        print("new data ")
    }
}
