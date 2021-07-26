//
//  BodyWeightCalendarViewController.swift
//  GymLog
//
//  Created by Kacper P on 23/07/2021.
//

import UIKit
import JTAppleCalendar
import Firebase
import IQKeyboardManagerSwift

class BodyWeightCalendarViewController: UIViewController, UITextFieldDelegate {
    
    
    lazy var bodyWeightCalendarPresenter = BodyWeightCalendarPresenter(bodyWeightCalendarPresenterDelegate: self)

    @IBOutlet weak var unitLabel: UILabel!
    
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
  
    lazy var jtappleCalendar = CalendarReusableClass(calendarDelegate: self)
    
    var arrayWithWeight = [BodyWeightCalendarModel]()
    
    let formatter = DateFormatter()
    var weight: Float = 80
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    var weightUnit: String {
        UserDefaults.standard.string(forKey: "unit") ?? "kg"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpCalendar()
//        jtappleCalendar.setUpCalendar(calendar: calendarBodyWeight)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.calendarBodyWeight.calendarDataSource = self.jtappleCalendar
        self.calendarBodyWeight.calendarDelegate = self.jtappleCalendar
        instructIfFirstOpen()
        bodyWeightCalendarPresenter.getBodyWeightCalendarData()

        calendarBodyWeight.scrollToDate(Date(), animateScroll: false)
        viewForCalendar.layer.cornerRadius = 20
        
        weightTextField.delegate = self
        selectCurrentDate()
        keyboardObservers()
        setUpButtons()
    }
    
    func instructIfFirstOpen() {
        if UserDefaults.standard.bool(forKey: "hasRunBefore") == false {
            weightTextField.text = "Tap to add weight"
            unitLabel.isHidden = true
        }
    }
    
    func valueForWeight() -> Float {
        
        let placeholder = weightTextField.placeholder
        if  placeholder?.isEmpty == true {
            return 80
        } else {
            let placeholderFloat = Float(placeholder!)!
            return placeholderFloat
        }
    }
    
    func selectCurrentDate() {
        calendarBodyWeight.selectDates([Date()])
        calendarBodyWeight.allowsMultipleSelection = false
    }
    
    @IBAction func backwardMonthButtonTapped(_ sender: UIButton) {
        calendarBodyWeight.scrollToSegment(.previous)
    }
    
    @IBAction func forwardMonthButtonTapped(_ sender: UIButton) {
        calendarBodyWeight.scrollToSegment(.next)
    }
    
    
    //MARK: - TEXT FIELD
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let currentText = weightTextField.text else { return false }

        let newLength = currentText.count + string.count
      
        return newLength < 6
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        unitLabel.isHidden = false
        let newPosition = weightTextField.beginningOfDocument
        weightTextField.selectedTextRange = weightTextField.textRange(from: newPosition, to: newPosition)
      
        unitLabel.textColor = .white
        unitLabel.isHidden = false
        weightTextField.text = ""
    }
    
    //MARK: - PLUS MINUS BUTTONS
    
    @IBAction func plusButtonTapped(_ sender: UIButton) {
        unitLabel.textColor = .white
        weight += 0.1
        let newWeight = String(format: "%.1f", weight)
        weightTextField.text = "\(newWeight)"
        
    }
    
    @IBAction func minusButtonTapped(_ sender: UIButton) {
        unitLabel.textColor = .white
        weight -= 0.1
        let newWeight = String(format: "%.1f", weight)
        weightTextField.text = "\(newWeight)"
    }
    
    func setUpButtons() {
        
        minusButton.isUserInteractionEnabled = true
        minusButton.layer.cornerRadius = minusButton.frame.width / 2
        minusButton.layer.masksToBounds = true
        minusButton.layer.borderColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
        minusButton.layer.borderWidth = 1
        
        plusButton.isUserInteractionEnabled = true
        plusButton.layer.cornerRadius = plusButton.frame.width / 2
        plusButton.layer.masksToBounds = true
        plusButton.layer.borderColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
        plusButton.layer.borderWidth = 1
      
        saveButton.layer.cornerRadius = 20
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        guard let weightTextValue = weightTextField.text else { return Alert.showAlertBeforeChange(on: self, with: "Empty weight field", message: "Please enter your weight", handler: nil)}
        
        let newWeightWithDot = String(format: "%.1f", weightTextValue.doubleValue)
        bodyWeightCalendarPresenter.saveNewWeight(newWeight: newWeightWithDot)
        performSegue(withIdentifier: "toBodyWeightChart", sender: self)

    }

    //MARK: - CALENDAR UI SET UP

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
    
    func keyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
          
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
   
    
    @objc func keyboardWillShow(notification: NSNotification) {
            
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           // if keyboard size is not available for some reason, dont do anything
           return
        }
        
      // move the root view up by the distance of keyboard height
        let heightToSubtract = keyboardSize.height - ((self.tabBarController?.tabBar.frame.size.height) ?? 0)
        self.view.frame.origin.y -= heightToSubtract
    }

    @objc func keyboardWillHide(notification: NSNotification) {
      // move back the root view origin to zero
      self.view.frame.origin.y = 0
    }

}

extension BodyWeightCalendarViewController: BodyWeightCalendarPresenterDelegate {
    func passBodyWeightCalendarData(data: [BodyWeightCalendarModel]) {
        arrayWithWeight = data
        
        guard let lastWeight = arrayWithWeight.last?.weight else { return weightTextField.placeholder = "enter weight"}
        let placeholderColor = NSAttributedString(string: "\(lastWeight)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        weightTextField.attributedPlaceholder = placeholderColor
        weight = lastWeight
    }
}


extension String {
    static let numberFormatter = NumberFormatter()
    var doubleValue: Double {
        String.numberFormatter.decimalSeparator = "."
        if let result = String.numberFormatter.number(from: self) {
            return result.doubleValue
        } else {
            String.numberFormatter.decimalSeparator = ","
            if let result = String.numberFormatter.number(from: self) {
                return result.doubleValue
            }
        }
        return 0
    }
}

extension BodyWeightCalendarViewController: CalendarReusableClassDelegate {
    
    func updateUIAfterSelection(selected date: Date) {
        // Check if selected value is in arrayWithWeight and when it's true, change textValue
        for value in arrayWithWeight {
            if value.date.getFormattedDate(format: "yyyy-MM-dd") == date.getFormattedDate(format: "yyyy-MM-dd") {
                weightTextField.text = "\(value.weight)"
                print("selected")
                unitLabel.isHidden = false
                unitLabel.textColor = .white
            }
        }
        
//        Check if arrayWithWeight contains selectedValue, if it's false, inform a user that there is no save
        if !arrayWithWeight.contains(where: {$0.date.getFormattedDate(format: "yyyy-MM-dd") == date.getFormattedDate(format: "yyyy-MM-dd")}) && date.getFormattedDate(format: "yyyy-MM-dd") != Date().getFormattedDate(format: "yyyy-MM-dd") {

            weightTextField.text = "No weight saved"
            unitLabel.isHidden = true
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

    
    func handleCellSelected(view: JTACDayCell?, cellState: CellState) {
                guard let validCell = view as? DateCell else { return }
        
                if validCell.isSelected {
                    validCell.selectedView.isHidden = false
                } else {
                    validCell.selectedView.isHidden = true
                    validCell.selectedView.backgroundColor = UIColor.init(red: 81/255, green: 134/255, blue: 87/255, alpha: 1)
                }
    }
}




//
//    func handleCellTextColor(view: JTACDayCell?, cellState: CellState) {
//
//        guard let validCell = view as? BodyWeightCalendarCell else { return }
//
//        formatter.dateFormat = "yyyy-MM-dd"
//
//        let todayDateString = formatter.string(from: Date())
//        let monthDateString = formatter.string(from: cellState.date)
//
//        if todayDateString == monthDateString {
//            validCell.bodyWeightView.isHidden = false
//            validCell.bodyWeightView.backgroundColor = .darkGray
//            validCell.todayLabel.isHidden = false
//        } else {
//            validCell.todayLabel.isHidden = true
//            validCell.bodyWeightView.backgroundColor = UIColor.init(red: 81/255, green: 134/255, blue: 87/255, alpha: 1)
//        }
//
//        if cellState.isSelected {
//            validCell.bodyWeightDateLabel.textColor = .white
//        }
//        else {
//            if cellState.dateBelongsTo == .thisMonth {
//                validCell.bodyWeightDateLabel.textColor = .white
//
//            } else {
//                validCell.bodyWeightDateLabel.textColor = .lightGray
//            }
//        }
//    }
//
//    func handleCellSelected(view: JTACDayCell?, cellState: CellState) {
//
//        guard let validCell = view as? BodyWeightCalendarCell else { return }
//
//        if validCell.isSelected {
//            validCell.bodyWeightView.isHidden = false
//        } else {
//            validCell.bodyWeightView.isHidden = true
//            validCell.bodyWeightView.backgroundColor = UIColor.init(red: 81/255, green: 134/255, blue: 87/255, alpha: 1)
//        }
//    }
//}
//
//extension BodyWeightCalendarViewController: JTACMonthViewDataSource {
//
//    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
//        formatter.dateFormat = "yyyy MM dd"
//        formatter.timeZone = Calendar.current.timeZone
//        formatter.locale = Calendar.current.locale
//
//        let startDate = Date().firstDateOfYear()
//        let endDate = formatter.date(from: "2021 12 12")!
//
//        let firstDayOfWeek: DaysOfWeek = .monday
//
//        let parameteres = ConfigurationParameters(startDate: startDate, endDate: endDate, firstDayOfWeek: firstDayOfWeek)
//
//        return parameteres
//    }
//
//}
//
//extension BodyWeightCalendarViewController: JTACMonthViewDelegate {
//
//    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
//        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "bodyWeightCell", for: indexPath) as! BodyWeightCalendarCell
//
//        cell.bodyWeightDateLabel.text = cellState.text
//
//        handleCellSelected(view: cell, cellState: cellState)
//        handleCellTextColor(view: cell, cellState: cellState)
//
//        return cell
//    }
//
//    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
//        let cell = cell as! BodyWeightCalendarCell
//
//        handleCellSelected(view: cell, cellState: cellState)
//        handleCellTextColor(view: cell, cellState: cellState)
//    }
//
//
//    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
//
//        handleCellSelected(view: cell, cellState: cellState)
//        handleCellTextColor(view: cell, cellState: cellState)
//
//        // Check if selected value is in arrayWithWeight and when it's true, change textValue
//        for value in arrayWithWeight {
//            if value.date.getFormattedDate(format: "yyyy-MM-dd") == date.getFormattedDate(format: "yyyy-MM-dd") {
//                weightTextField.text = "\(value.weight)"
//                print("selected")
//                unitLabel.isHidden = false
//                unitLabel.textColor = .white
//            }
//        }
//
////        Check if arrayWithWeight contains selectedValue, if it's false, inform a user that there is no save
//        if !arrayWithWeight.contains(where: {$0.date.getFormattedDate(format: "yyyy-MM-dd") == date.getFormattedDate(format: "yyyy-MM-dd")}) && date.getFormattedDate(format: "yyyy-MM-dd") != Date().getFormattedDate(format: "yyyy-MM-dd") {
//
//            weightTextField.text = "No weight saved"
//            unitLabel.isHidden = true
//        }
//
//        //Change buttons properties, if selected date is not today date
//        if date.getFormattedDate(format: "yyyy-MM-dd") != Date().getFormattedDate(format: "yyyy-MM-dd") {
//            plusButton.backgroundColor?.withAlphaComponent(0.1)
//            plusButton.layer.borderColor = UIColor.clear.cgColor
//            plusButton.isUserInteractionEnabled = false
//            minusButton.backgroundColor?.withAlphaComponent(0.1)
//            minusButton.layer.borderColor = UIColor.clear.cgColor
//            minusButton.isUserInteractionEnabled = false
//            print("it isnt today")
//        } else {
//            setUpButtons()
//            print("its today")
//        }
