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
    
    @IBOutlet weak var weightChart: LineChartView!
    var bodyWeightService = BodyWeightService()
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var arrayWithEntries: [Weight] = []
    var referenceTimeInterval: TimeInterval = 0
    let dateFormatter = DateFormatter()
    let color = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
    var weightUnit: String {
        UserDefaults.standard.string(forKey: "unit") ?? "kg"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        weightChart.delegate = self
        
        setChartProperties()
        getData()
        self.tableViewUnderChart.delegate = self
        self.tableViewUnderChart.dataSource = self
        tableViewUnderChart.rowHeight = 90
        controlSegmentSetUp()
    }
    
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        
        
    }
    
    func setChartProperties() {
 
//        viewChart.layer.cornerRadius = 20
        weightChart.backgroundColor = .clear
        
  
        weightChart.rightAxis.enabled = false
        weightChart.scaleXEnabled = true
        
        let yAxis = weightChart.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 8)
        yAxis.setLabelCount(6, force: false)
        yAxis.axisMinimum = 0
        yAxis.labelTextColor = .white
        yAxis.axisLineColor = .clear
        yAxis.labelPosition = .outsideChart
        yAxis.drawGridLinesEnabled = true
       
        weightChart.xAxis.setLabelCount(8, force: false)
      
        weightChart.xAxis.labelPosition = .bottom
        weightChart.xAxis.avoidFirstLastClippingEnabled = true
        weightChart.xAxis.granularity = 1
    
        weightChart.xAxis.labelFont = .systemFont(ofSize: 12)

        weightChart.xAxis.axisLineColor = .white
        weightChart.xAxis.labelTextColor = .white
        weightChart.xAxis.drawGridLinesEnabled = false
        
        weightChart.legend.enabled = false
    }
    
    func setDataSetProperties(set: LineChartDataSet) {
        
        set.setColor(color)
        set.mode = .cubicBezier
        set.drawCirclesEnabled = true
        set.circleColors = set.colors
        set.drawCircleHoleEnabled = false
        set.circleRadius = 2
        set.lineWidth = 3
        set.drawHorizontalHighlightIndicatorEnabled = false
        set.highlightColor = .red
        
        let colorLocations: [CGFloat] = [0.0, 1.0]
       
        let gradColors = [color.cgColor, UIColor.clear.cgColor]
        if let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradColors as CFArray, locations: colorLocations) {
            set.fill = Fill(linearGradient: gradient, angle: 90.0)
        }
        set.drawFilledEnabled = true
        
    }
    
    func getData() {
        bodyWeightService.getData { (data) in
            self.arrayWithEntries = data
            self.doDataEntries()
            self.sortArray()
            print("array is \(self.arrayWithEntries)")
            DispatchQueue.main.async {
                self.tableViewUnderChart.reloadData()
            }
        }
    }
    
    func doDataEntries() {
        
        let dispatchGroup = DispatchGroup()
        convertDateForAxis()
        var lineChartEntries = [ChartDataEntry]()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        weightChart.xAxis.valueFormatter = ChartXAxisFormatter(referenceTimeInterval: referenceTimeInterval, dateFormatter: dateFormatter)
 
        for value in arrayWithEntries {
            dispatchGroup.enter()
            
            let date = value.date
            
            let timeInterval = date.timeIntervalSince1970
            let xValue = (timeInterval - referenceTimeInterval) / (3600 * 24)
            
            lineChartEntries.append(ChartDataEntry(x: xValue, y: Double(value.weight)))
            print("line chart is \(lineChartEntries))")
            dispatchGroup.leave()
        }
        
        let set = LineChartDataSet(entries: lineChartEntries)
        setDataSetProperties(set: set)
        let data = LineChartData(dataSet: set)
        self.weightChart.data = data
        
        
    }
    
    func sortArray() {
        arrayWithEntries.sort { (a, b) -> Bool in
            a.date > b.date
        }
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

        return arrayWithEntries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewUnderChart.dequeueReusableCell(withIdentifier: "bodyWeightCellChart", for: indexPath) as! BodyWeightTableViewCellChart
        
        //formatted retrieved date
        let dateFromArray = arrayWithEntries[indexPath.row].date
        dateFormatter.dateFormat = "dd.MM, HH:mm"
        let dateFormatted = dateFormatter.string(from: dateFromArray)
     
        //formatted date without HH:mm
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateFormatWithoutTime = dateFormatter.string(from: dateFromArray)
        
        //Retrieve weight value
        let weight = String(arrayWithEntries[indexPath.row].weight)
        cell.weightValue.text = "\(weight) \(weightUnit)"
     
       // if last row, hide progression parameteres
        if indexPath.row == arrayWithEntries.count - 1 {
            cell.arrowProgress.isHidden = true
            cell.weightProgress.isHidden = true
        } else {
            cell.arrowProgress.isHidden = false
            cell.weightProgress.isHidden = false
            
            let progressValue = arrayWithEntries[indexPath.row].weight - arrayWithEntries[indexPath.row + 1].weight
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
        
        
        return cell
    }
}

