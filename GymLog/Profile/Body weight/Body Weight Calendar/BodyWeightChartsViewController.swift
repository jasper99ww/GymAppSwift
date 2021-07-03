//
//  BodyWeightChartsViewController.swift
//  GymLog
//
//  Created by Kacper P on 28/06/2021.
//

import UIKit
import Charts

class BodyWeightChartsViewController: UIViewController, ChartViewDelegate {

    @IBOutlet weak var tableViewUnderChart: UITableView!
    let periodSelection = BodyWeightPeriodSelection()
    
    @IBOutlet weak var weightChart: LineChartView!
    var bodyWeightService = BodyWeightService()
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var lineChartEntries = [ChartDataEntry]()
    var arrayWithEntries: [Weight] = []
    var arrayForTableView: [Weight] = []
    var arrayWithSelectedPeriod: [Weight] = []
    
    var referenceTimeInterval: TimeInterval = 0
    let dateFormatter = DateFormatter()
    let color = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
    var weightUnit: String {
        UserDefaults.standard.string(forKey: "unit") ?? "kg"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        weightChart.delegate = self
        
        getData()
        self.tableViewUnderChart.delegate = self
        self.tableViewUnderChart.dataSource = self
        tableViewUnderChart.rowHeight = 90
        controlSegmentSetUp()
        checking()
    }
    
    func checking() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
//        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 1], animated: false)
        print(" vc \(viewControllers[viewControllers.count - 2])")
        }
    
    

    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        
        if parent == nil {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 2], animated: false)
        }
    }
  

    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            let storyboard = UIStoryboard(name: "Profile", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "bodyWeightTableViewController")
            self.present(vc, animated: true)
//            doDataEntries(period: "week")
        } else if sender.selectedSegmentIndex == 1 {
            doDataEntries(period: "month")
          
        } else if sender.selectedSegmentIndex == 2 {
            doDataEntries(period: "year")
          
        }
        
    }
    
    func setChartProperties() {
 
//        viewChart.layer.cornerRadius = 20
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
       
        weightChart.xAxis.setLabelCount(arrayWithSelectedPeriod.count, force: false)
      
        weightChart.xAxis.labelPosition = .bottom
        weightChart.xAxis.avoidFirstLastClippingEnabled = true
        weightChart.xAxis.granularity = 1
    
        weightChart.xAxis.labelFont = .systemFont(ofSize: 14)

        weightChart.xAxis.axisLineColor = .white
        weightChart.xAxis.labelTextColor = .white
        weightChart.xAxis.drawGridLinesEnabled = false
        weightChart.legend.enabled = false
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
//            if let lineChartX = self.lineChartEntries.last?.x, let lineChartY = self.lineChartEntries.last?.y {
//                self.weightChart.highlightValue(x: lineChartX, y: lineChartY, dataSetIndex: 0)
////            }
//        }
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        guard let dataSet = chartView.data?.dataSets[highlight.dataSetIndex] else { return }
        
        let indexOfEntry : Int = ((self.tableViewUnderChart.numberOfRows(inSection: 0) - 1 ) - dataSet.entryIndex(entry: entry))
      
        let indexPath = IndexPath(row: indexOfEntry, section: 0)
    
        
        self.tableViewUnderChart.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
    
    }
    
    

    
    func setDataSetProperties(set: LineChartDataSet) {
        
        set.setColor(color)
        set.mode = .cubicBezier
        set.drawCirclesEnabled = true
        set.circleColors = set.colors
        set.drawCircleHoleEnabled = true
        set.circleRadius = 6
        set.circleHoleRadius = 4
        set.circleHoleColor = view.backgroundColor
        set.lineWidth = 4
        set.drawHorizontalHighlightIndicatorEnabled = false
        set.highlightColor = .red
        set.drawValuesEnabled = false
        
        let colorLocations: [CGFloat] = [0.0, 1.0]
       
        let gradColors = [color.cgColor, UIColor.clear.cgColor]
        if let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradColors as CFArray, locations: colorLocations) {
            set.fill = Fill(linearGradient: gradient, angle: 90.0)
        }
        set.drawFilledEnabled = true
        
        setChartProperties()
    }
    
    func getData() {
        bodyWeightService.getData { (data) in
            self.arrayWithEntries = data
        
            self.doDataEntries(period: "year")
            self.sortArray()
            DispatchQueue.main.async {
                self.tableViewUnderChart.reloadData()
            }
            
            self.setChartProperties()
        }
    }
    
    func doDataEntries(period: String) {
        
        let group = DispatchGroup()
     
        
        arrayWithSelectedPeriod = []
        
        if period == "year" {
        
            arrayWithSelectedPeriod = []
            group.enter()
          arrayWithSelectedPeriod = arrayWithEntries
            convertDateForAxis()
            group.leave()
        } else if period == "month" {
           
            group.enter()
            periodSelection.loopForMonth(data: arrayWithEntries) { (data) in
                arrayWithSelectedPeriod = data
            }
          group.leave()
        }
         else if period == "week" {
            
            group.enter()
            periodSelection.loopForWeek(data: arrayWithEntries) { (data) in
               arrayWithSelectedPeriod = data
            }
            group.leave()
        } else {
            print("No weight measurement in this week")
        }
        
        let dispatchGroup = DispatchGroup()
//        convertDateForAxis()
        lineChartEntries = []
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        weightChart.xAxis.valueFormatter = ChartXAxisFormatter(referenceTimeInterval: referenceTimeInterval, dateFormatter: dateFormatter)

        for value in arrayWithSelectedPeriod {
            dispatchGroup.enter()
            
            let date = value.date
            
            let timeInterval = date.timeIntervalSince1970
            let xValue = (timeInterval - referenceTimeInterval) / (3600 * 24)
            
            lineChartEntries.append(ChartDataEntry(x: xValue, y: Double(value.weight)))

            dispatchGroup.leave()
        }
  
     
        let set = LineChartDataSet(entries: lineChartEntries)
      
        let data = LineChartData(dataSet: set)
        setDataSetProperties(set: set)
       
        self.weightChart.data = data
    
    }
    
    func sortArray() {
       
//        arrayWithEntries.sort { (a, b) -> Bool in
//              a.date < b.date
//          }
//         arrayForTableView = arrayWithEntries
//          print("new array is \(newArray)")
      let newArray =  arrayWithEntries.sorted { (a, b) -> Bool in
            a.date > b.date
        }
       arrayForTableView = newArray
        print("new array is \(newArray)")
    }
    
    func convertDateForAxis() {
        if let minTimeInterval = arrayWithEntries.compactMap({$0.date}).min() {
            referenceTimeInterval = minTimeInterval.timeIntervalSince1970
        }
    }
    
    func controlSegmentSetUp() {
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)

//        if let viewColor = view.backgroundColor {
//        segmentedControl.clearBG(color: viewColor)
//        }
        let greenColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        segmentedControl.selectedSegmentTintColor = greenColor
    }
}

extension BodyWeightChartsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return arrayForTableView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewUnderChart.dequeueReusableCell(withIdentifier: "bodyWeightCellChart", for: indexPath) as! BodyWeightTableViewCellChart
        
        //formatted retrieved date
        let dateFromArray = arrayForTableView[indexPath.row].date
        dateFormatter.dateFormat = "dd.MM, HH:mm"
        let dateFormatted = dateFormatter.string(from: dateFromArray)
     
        //formatted date without HH:mm
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateFormatWithoutTime = dateFormatter.string(from: dateFromArray)
        
        //Retrieve weight value
        let weight = String(arrayForTableView[indexPath.row].weight)
        cell.weightValue.text = "\(weight) \(weightUnit)"
     
       // if last row, hide progression parameteres
        if indexPath.row == arrayWithEntries.count - 1 {
            cell.arrowProgress.isHidden = true
            cell.weightProgress.isHidden = true
        } else {
            cell.arrowProgress.isHidden = false
            cell.weightProgress.isHidden = false
            
            let progressValue = arrayForTableView[indexPath.row].weight - arrayForTableView[indexPath.row + 1].weight
            let progressValueString = String(format: "%.2f", progressValue)
            cell.weightProgress.text = ("\(progressValueString) kg")
            
            //Check if progression is on + or -
            if progressValue > 0 {
                cell.arrowProgress.image = UIImage(systemName: "arrow.up")
                cell.arrowProgress.tintColor = .green
                cell.weightProgress.textColor = .green
            } else {
                cell.arrowProgress.image = UIImage(systemName: "arrow.down")
                cell.arrowProgress.tintColor = .red
                cell.weightProgress.textColor = .red
            }
        }
        
        // Check if last record is from today
        let todayDate = Date().getFormattedDate(format: "yyy-MM-dd")
        if dateFormatWithoutTime == todayDate {
            cell.dayLabel.text = "Today"
        } else {
            cell.dayLabel.text = dateFormatted
        }
//        
////        let bgColorView = UIView()
////        bgColorView.backgroundColor = UIColor.red
////        cell.selectedBackgroundView = bgColorView
//        cell.selectionStyle = .blue
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  
//        let selectedCell: UITableViewCell = tableViewUnderChart.cellForRow(at: indexPath)!
//        selectedCell.contentView.backgroundColor = UIColor.darkGray
    }
}

