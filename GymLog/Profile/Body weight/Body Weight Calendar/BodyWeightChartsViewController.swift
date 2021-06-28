//
//  BodyWeightChartsViewController.swift
//  GymLog
//
//  Created by Kacper P on 28/06/2021.
//

import UIKit
import Charts

class BodyWeightChartsViewController: UIViewController, ChartViewDelegate {

    @IBOutlet weak var weightChart: LineChartView!
    var bodyWeightService = BodyWeightService()
    
    var arrayWithEntries: [Weight] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        weightChart.delegate = self
setChartProperties()
        getData()
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
        
        var entries = [ChartDataEntry]()
        
        for x in 0..<10 {
            entries.append(ChartDataEntry(x: Double(x), y: Double(x)))
        }
        
        let set = LineChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.material()
        let data = LineChartData(dataSet: set)
        weightChart.data = data
//
//        self.weightChart.animate(xAxisDuration: 0.04 * Double(self.lineChartEntry.count), easingOption: .linear)
       
    }
    
    func getData() {
        
        bodyWeightService.getData { (data) in
            self.arrayWithEntries = data
            print("data is \(data)")
        }

    }

}
