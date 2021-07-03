//
//  BodyWeightCalendarViewController.swift
//  GymLog
//
//  Created by Kacper P on 26/06/2021.
//

import UIKit
import JTAppleCalendar
import Firebase

class BodyWeightCalendarViewController: UIViewController, UITextFieldDelegate {


    let date = Date()
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var viewForCalendar: UIView!
    @IBOutlet weak var calendarBodyWeight: JTACMonthView!
    @IBOutlet weak var currentDisplayMonthLabel: UILabel!
    @IBOutlet weak var backwardMonthButton: UIButton!
    @IBOutlet weak var forwardMonthButton: UIButton!
  
    var bodyWeightService = BodyWeightService()
    var arrayWithWeight: [Weight] = []
    
    
    let formatter = DateFormatter()
    var weight: Float = 80
    
    var weightUnit: String {
        UserDefaults.standard.string(forKey: "unit") ?? "kg"
    }
    
//    override func viewDidLayoutSubviews() {
//        setUpButtons()
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpCalendar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarBodyWeight.calendarDataSource = self
        calendarBodyWeight.calendarDelegate = self
        calendarBodyWeight.scrollToDate(Date(), animateScroll: false)
        viewForCalendar.layer.cornerRadius = 20
        saveButton.layer.cornerRadius = 20
        weightTextField.delegate = self
        calendarBodyWeight.selectDates([Date()])
        calendarBodyWeight.allowsMultipleSelection = false
        setUpButtons()
        getData()
    }
    
    func getData() {
        bodyWeightService.getData { (data) in
            self.arrayWithWeight = data
        }
    }
    
    @IBAction func backwardMonthButtonTapped(_ sender: UIButton) {
        calendarBodyWeight.scrollToSegment(.previous)
    }
    
    @IBAction func forwardMonthButtonTapped(_ sender: UIButton) {
        calendarBodyWeight.scrollToSegment(.next)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        guard let currentText = weightTextField.text else { return false }

        let lastPositionOfTextField = weightTextField.endOfDocument
        
        let nextToLastPositionOfTextField = weightTextField.position(from: weightTextField.endOfDocument, offset: -1)
        
        //Check if cursor is on last or next to last position (on kg letters)
        if weightTextField.selectedTextRange == weightTextField.textRange(from: lastPositionOfTextField, to: lastPositionOfTextField) || weightTextField.selectedTextRange == weightTextField.textRange(from: nextToLastPositionOfTextField ?? lastPositionOfTextField, to: nextToLastPositionOfTextField ?? lastPositionOfTextField) {
            return false
        }
        
        if currentText == "kg" && string == "" {
            return false
        }

        guard let textRange = Range(range, in: currentText) else { return false }

        let updatedText = currentText.replacingCharacters(in: textRange, with: string)

        return updatedText.count <= 7
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let newPosition = weightTextField.beginningOfDocument
        weightTextField.selectedTextRange = weightTextField.textRange(from: newPosition, to: newPosition)
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if weightTextField.text?.contains("kg") == true {
            guard let editedWeight = weightTextField.text?.dropLast(2) else { return }
            guard let editedWeightFloat = Float(editedWeight) else { return  }
                weight = editedWeightFloat
            }
        else {
            guard let editedWeight = weightTextField.text else { return  }
            guard let editedWeightFloat = Float(editedWeight) else { return }
                weight = editedWeightFloat
            }
        }
    
    @IBAction func plusButtonTapped(_ sender: UIButton) {
        weight += 0.1
        let newWeight = String(format: "%.1f", weight)
        weightTextField.text = "\(newWeight) kg"
    }
    
    @IBAction func minusButtonTapped(_ sender: UIButton) {
        weight -= 0.1
        let newWeight = String(format: "%.1f", weight)
        weightTextField.text = "\(newWeight) kg"
    }
    
    func setUpButtons() {
        
        minusButton.isUserInteractionEnabled = true
        plusButton.isUserInteractionEnabled = true
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

        saveInDatabase {
            performSegue(withIdentifier: "toBodyWeightChart", sender: self)
        }

    }
    
    func saveInDatabase(completion: () -> Void) {
        
        if let weightValue = weightTextField.text {
        
            if weightValue.contains("kg") == true {
              
                let weightAfterDropLast = String(weightValue.dropLast(2).trimmingCharacters(in: .whitespaces))
                
                bodyWeightService.saveNewWeight(weight: weightAfterDropLast)
               
            } else {
                bodyWeightService.saveNewWeight(weight: weightValue.trimmingCharacters(in: .whitespaces))

            }
            completion()
        }
    }


    func setUpCalendar() {
        calendarBodyWeight.minimumLineSpacing = 0
        calendarBodyWeight.minimumInteritemSpacing = 0
        
        calendarBodyWeight.visibleDates { (visibleDates) in
            self.setUpViewsOfCalendar(from: visibleDates)
        }
    }
    
    func setUpViewsOfCalendar(from visibleDates: DateSegmentInfo) {

        let date = visibleDates.monthDates.first!.date
        
        self.formatter.dateFormat = "MMMM"
        self.currentDisplayMonthLabel.text = self.formatter.string(from: date)

    }
    
    func handleCellTextColor(view: JTACDayCell?, cellState: CellState) {
        
        guard let validCell = view as? BodyWeightCalendarCell else { return }
        
        formatter.dateFormat = "yyyy-MM-dd"
        
        let todayDateString = formatter.string(from: Date())
        let monthDateString = formatter.string(from: cellState.date)
        
        if todayDateString == monthDateString {
            validCell.bodyWeightView.isHidden = false
            validCell.bodyWeightView.backgroundColor = .darkGray
            validCell.todayLabel.isHidden = false
        } else {
            validCell.todayLabel.isHidden = true
            validCell.bodyWeightView.backgroundColor = UIColor.init(red: 81/255, green: 134/255, blue: 87/255, alpha: 1)
        }

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

        let startDate = Date().firstDateOfYear()
        let endDate = formatter.date(from: "2021 12 12")!
        
        let firstDayOfWeek: DaysOfWeek = .monday
    
        let parameteres = ConfigurationParameters(startDate: startDate, endDate: endDate, firstDayOfWeek: firstDayOfWeek)
        
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
        let cell = cell as! BodyWeightCalendarCell


        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        
    }
    
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {

        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        
        // Check if selected value is in arrayWithWeight and when it's true, change textValue
        for value in arrayWithWeight {
            if value.date.getFormattedDate(format: "yyyy-MM-dd") == date.getFormattedDate(format: "yyyy-MM-dd") {
                weightTextField.text = "\(value.weight)kg"
            }
        }
        
        //Check if arrayWithWeight contains selectedValue, if it's true, inform a user that there is no save
        if !arrayWithWeight.contains(where: {$0.date.getFormattedDate(format: "yyyy-MM-dd") == date.getFormattedDate(format: "yyyy-MM-dd")}) {
            weightTextField.text = "No weight saved"
        }
        
        //Change buttons properties, if selected date is not today date
        if date.getFormattedDate(format: "yyyy-MM-dd") != Date().getFormattedDate(format: "yyyy-MM-dd") {
            plusButton.backgroundColor?.withAlphaComponent(0.1)
            plusButton.layer.borderColor = UIColor.clear.cgColor
            plusButton.isUserInteractionEnabled = false
            minusButton.backgroundColor?.withAlphaComponent(0.1)
            minusButton.layer.borderColor = UIColor.clear.cgColor
            minusButton.isUserInteractionEnabled = false
            print("it isnt today")
        } else {
            setUpButtons()
            print("its today")
        }
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
 
    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setUpViewsOfCalendar(from: visibleDates)
    }

}
