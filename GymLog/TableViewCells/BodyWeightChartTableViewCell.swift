//
//  BodyWeightTableViewCellChart.swift
//  GymLog
//
//  Created by Kacper P on 01/07/2021.
//

import UIKit

class BodyWeightChartTableViewCell: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weightValue: UILabel!
    @IBOutlet weak var weightProgress: UILabel!
    @IBOutlet weak var arrowProgress: UIImageView!
    
    var weightUnit: String {
        UserDefaults.standard.string(forKey: "unit") ?? "kg"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

//        let color = contentView.backgroundColor
//        let selectedColor = color?.withAlphaComponent(0.8)
        let colorX = UIColor.init(red: 20/255, green: 20/255, blue: 20/255, alpha: 1)
        
        if selected {
            self.contentView.backgroundColor = colorX
        } else {
            self.contentView.backgroundColor = .clear
        }
    }
    
    func hideProgressParameters(bool: Bool) {
        if bool {
        arrowProgress.isHidden = true
        weightProgress.isHidden = true
        } else {
        arrowProgress.isHidden = false
        weightProgress.isHidden = false
        }
    }
    
    func setProgressParameteres(positive: Bool) {
        if positive {
            arrowProgress.image = UIImage(systemName: Images.arrowUp)
            arrowProgress.tintColor = .green
            weightProgress.textColor = .green
        } else {
            arrowProgress.image = UIImage(systemName: Images.arrowDown)
            arrowProgress.tintColor = .red
            weightProgress.textColor = .red
        }
    }
    
    func configureCell(tableViewData: [BodyWeightCalendarModel], indexPath: IndexPath) {
        
        //formatted retrieved date
        let formattedDateTime = tableViewData[indexPath.row].date.getFormattedDate(format: DateFormats.formatDayMonthTime)
        
        let formattedDate = tableViewData[indexPath.row].date.getFormattedDate(format: DateFormats.formatYearMonthDay)
        
        let weight = String(tableViewData[indexPath.row].weight)
        
        let progressValue = tableViewData[indexPath.row].weight - tableViewData[indexPath.row + 1].weight
        
        let progressValueString = String(format: "%.1f", progressValue)
        
        weightValue.text = "\(weight) \(weightUnit)"
        
        //Hide progress parameters if first row selected
        if indexPath.row == tableViewData.count - 1 {
            hideProgressParameters(bool: true)
        } else {
            hideProgressParameters(bool: false)
        }
            
        weightProgress.text = ("\(progressValueString) kg")
            
        //Check if progression is on + or -
        if progressValue > 0 {
                setProgressParameteres(positive: true)
        } else {
                setProgressParameteres(positive: false)
        }
            
        // Check if last record is from today
        let todayDate = Date().getFormattedDate(format: DateFormats.formatYearMonthDay)
            
        if formattedDate == todayDate {
               dayLabel.text = "Today"
        } else {
               dayLabel.text = formattedDateTime
            }
        }
    
}
    
