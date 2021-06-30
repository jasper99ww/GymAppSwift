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
    
    var arrayWithEntries: [Weight] = []
    var referenceTimeInterval: TimeInterval = 0
    let dateFormatter = DateFormatter()
    let color = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        weightChart.delegate = self
        tableViewUnderChart.rowHeight = 100
        setChartProperties()
        getData()
        self.tableViewUnderChart.delegate = self
        self.tableViewUnderChart.dataSource = self
    }
    
    func setChartProperties() {
 
//        viewChart.layer.cornerRadius = 20
        weightChart.backgroundColor = .clear
        weightChart.extraBottomOffset = 35
  
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
    
    func convertDateForAxis() {

        if let minTimeInterval = arrayWithEntries.compactMap({$0.date}).min() {
            referenceTimeInterval = minTimeInterval.timeIntervalSince1970
        }
    }
}

extension BodyWeightChartsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count is \(arrayWithEntries.count)")
        return arrayWithEntries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewUnderChart.dequeueReusableCell(withIdentifier: "bodyWeightCellChart", for: indexPath) as! BodyWeightTableViewCellChart
        
        let weight = String(arrayWithEntries[indexPath.row].weight)
        print("weight to to \(weight)")
//        let date = dateFormatter.string(from: arrayWithEntries[indexPath.row].date)
//        print("date is \(date)")
//        cell.dayLabel.text = date
        cell.weightProgress.text = weight
        
        
        
        return cell
    }
    
    
}

