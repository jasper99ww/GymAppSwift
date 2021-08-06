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
    
    var todayDate = String()
    var dateWithTime = String()
    var dateWithoutTime = String() {
        didSet {
            if dateWithoutTime == todayDate {
                dayLabel.text = "Today"
            } else {
                dayLabel.text = dateWithTime
            }
        }
    }

    var weight: String = "" {
        didSet {
            weightValue.text = "\(weight) \(weightUnit)"
        }
    }
    
    var progressValue: Float = 0 {
        didSet {
            let progressValueString = String(format: "%.1f", progressValue)
            weightProgress.text = ("\(progressValueString) \(weightUnit)")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        let colorForSelectedRow = UIColor.init(red: 20/255, green: 20/255, blue: 20/255, alpha: 1)
        
        if selected {
            self.contentView.backgroundColor = colorForSelectedRow
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
    
    func setProgressParameteres() {
        if progressValue > 0 {
                   arrowProgress.image = UIImage(systemName: Images.arrowUp)
                   arrowProgress.tintColor = .green
                   weightProgress.textColor = .green
               } else {
                   arrowProgress.image = UIImage(systemName: Images.arrowDown)
                   arrowProgress.tintColor = .red
                   weightProgress.textColor = .red
        }
    }
    
//    func configureCell(tableViewData: [BodyWeightCalendarModel], indexPath: IndexPath) {
//
////        dateWithoutTime = tableViewData[indexPath.row].date
////        dateWithTime = tableViewData[indexPath.row].date
//
//        weight = String(tableViewData[indexPath.row].weight)
//
//        //Hide progress parameters if first row selected
//        if indexPath.row == tableViewData.count - 1 {
//            hideProgressParameters(bool: true)
//        } else {
//            hideProgressParameters(bool: false)
//            progressValue = tableViewData[indexPath.row].weight - tableViewData[indexPath.row + 1].weight
//            setProgressParameteres()
//        }
//    }
}
    
