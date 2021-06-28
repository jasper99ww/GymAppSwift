//
//  BodyWeightCalendarViewController.swift
//  GymLog
//
//  Created by Kacper P on 26/06/2021.
//

import UIKit
import JTAppleCalendar
import Firebase

class BodyWeightCalendarViewController: UIViewController {

    var bodyWeightService = BodyWeightService()
    let date = Date()
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var viewForCalendar: UIView!
    @IBOutlet weak var calendarBodyWeight: JTACMonthView!
    
    let formatter = DateFormatter()
    var weight: Float = 80
    
    var weightUnit: String {
        UserDefaults.standard.string(forKey: "unit") ?? "kg"
    }
    
    override func viewDidLayoutSubviews() {
        setUpButtons()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarBodyWeight.calendarDataSource = self
        calendarBodyWeight.calendarDelegate = self
        setUpCalendar()
        viewForCalendar.layer.cornerRadius = 20
        saveButton.layer.cornerRadius = 20
       
    }
    
    @IBAction func plusButtonTapped(_ sender: UIButton) {
        weight += 0.1
        let newWeight = String(format: "%.1f", weight)
        weightTextField.text = "\(newWeight)"
    }
    
    @IBAction func minusButtonTapped(_ sender: UIButton) {
        weight -= 0.1
        let newWeight = String(format: "%.1f", weight)
        weightTextField.text = "\(newWeight)"
    }
    
    
    
    func setUpButtons() {
        minusButton.layer.cornerRadius = minusButton.frame.width / 2
        minusButton.layer.masksToBounds = true
        minusButton.layer.borderColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
        minusButton.layer.borderWidth = 1
        plusButton.layer.cornerRadius = plusButton.frame.width / 2
        plusButton.layer.masksToBounds = true
        plusButton.layer.borderColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
        plusButton.layer.borderWidth = 1
      
    }

    
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        if let weightToSave = Float(String(format: "%.1f", weight)) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY MM dd"
        let dateString = dateFormatter.string(from: date)
        bodyWeightService.saveNewWeight(weight: weightToSave, date: dateString)
        }
    }
    

    func setUpCalendar() {
        calendarBodyWeight.minimumLineSpacing = 0
        calendarBodyWeight.minimumInteritemSpacing = 0
    }
    
    func handleCellTextColor(view: JTACDayCell?, cellState: CellState) {
        
        guard let validCell = view as? BodyWeightCalendarCell else { return }
        
        formatter.dateFormat = "yyyy-MM-dd"
        
//        let todayDateString = formatter.string(from: Date())
//        let monthDateString = formatter.string(from: cellState.date)
//
//
//
//        if todayDateString == monthDateString {
//            validCell.bodyWeightView.isHidden = false
//            validCell.bodyWeightView.backgroundColor = .darkGray
//            validCell.bodyWeightDateLabel.isHidden = false
//        } else {
//            validCell.bodyWeightDateLabel.isHidden = true
//            validCell.bodyWeightView.backgroundColor = UIColor.init(red: 81/255, green: 134/255, blue: 87/255, alpha: 1)
//        }

        if cellState.isSelected {
            validCell.bodyWeightDateLabel.textColor = .white
        }
     
        else {
            if cellState.dateBelongsTo == .thisMonth {
                validCell.bodyWeightDateLabel.textColor = .white
                
            } else {
                validCell.bodyWeightDateLabel.textColor = .lightGray
            }
        }
    }

    func handleCellSelected(view: JTACDayCell?, cellState: CellState) {
     
        guard let validCell = view as? BodyWeightCalendarCell else { return }
        
        if validCell.isSelected {
            validCell.bodyWeightView.isHidden = false
        } else {
            validCell.bodyWeightView.isHidden = true
            validCell.bodyWeightView.backgroundColor = UIColor.init(red: 81/255, green: 134/255, blue: 87/255, alpha: 1)
        }
}
    
}

extension BodyWeightCalendarViewController: JTACMonthViewDataSource {

    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = Date()
        let endDate = formatter.date(from: "2021 12 12")!

        let parameteres = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameteres
    }

}

extension BodyWeightCalendarViewController: JTACMonthViewDelegate {
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "bodyWeightCell", for: indexPath) as! BodyWeightCalendarCell
       
        cell.bodyWeightDateLabel.text = cellState.text
       
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        
        
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cell = cell as! DateCell
        cell.datelabel.text = cellState.text

        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        
    }
    
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {

        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        

    }
      

    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
     
    }

}
