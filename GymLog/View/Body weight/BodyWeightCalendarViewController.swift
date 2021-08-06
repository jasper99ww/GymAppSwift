//
//  BodyWeightCalendarViewController.swift
//  GymLog
//
//  Created by Kacper P on 23/07/2021.
//

import UIKit
import JTAppleCalendar

class BodyWeightCalendarViewController: UIViewController, UITextFieldDelegate {
    
    lazy var bodyWeightCalendarPresenter = BodyWeightCalendarPresenter(bodyWeightCalendarPresenterDelegate: self)
    lazy var jtappleCalendar = CalendarReusableClass(calendarDelegate: self, calendar: calendarBodyWeight, monthLabel: currentDisplayMonthLabel)
    
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var viewForCalendar: UIView!
    @IBOutlet weak var calendarBodyWeight: JTACMonthView!
    @IBOutlet weak var currentDisplayMonthLabel: UILabel!
    @IBOutlet weak var backwardMonthButton: UIButton!
    @IBOutlet weak var forwardMonthButton: UIButton!
    
    var bodyWeightCalendarData = [BodyWeightCalendarModel]()
    var weight: Float = 80
    
    let formatter = DateFormatter()
    
    var weightUnit: String {
        UserDefaults.standard.string(forKey: "unit") ?? "kg"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.removeKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.calendarBodyWeight.calendarDataSource = self.jtappleCalendar
        self.calendarBodyWeight.calendarDelegate = self.jtappleCalendar
        bodyWeightCalendarPresenter.getBodyWeightCalendarData()
        weightTextField.delegate = self
        instructIfFirstOpen()
        setUpButtons()
    }
    
    // If user hasn't opened app before, set guideline
    func instructIfFirstOpen() {
        if UserDefaults.standard.bool(forKey: "hasRunBefore") == false {
            weightTextField.text = "Tap to add weight"
            unitLabel.isHidden = true
        }
    }
    
    //MARK: - TEXT FIELD
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let currentText = weightTextField.text else { return false }
        let newLength = currentText.count + string.count
        
        return newLength < 6
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let newPosition = weightTextField.beginningOfDocument
        weightTextField.selectedTextRange = weightTextField.textRange(from: newPosition, to: newPosition)
        unitLabel.textColor = .white
        unitLabel.isHidden = false
        weightTextField.text = ""
    }
    
    //MARK: - Plus Minus Buttons
    
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
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        guard let weightTextValue = weightTextField.text, !weightTextValue.isEmpty else { return Alert.showAlertBeforeChange(on: self, with: "Empty weight field", message: "Please enter your weight", handler: nil)}
        
        let newWeightWithDot = String(format: "%.1f", weightTextValue.doubleValue)
        
        bodyWeightCalendarPresenter.saveNewWeight(newWeight: newWeightWithDot)
        
        performSegue(withIdentifier: "toBodyWeightChart", sender: self)
    }

    //MARK: - Buttons for calendar
    
    @IBAction func backwardMonthButtonTapped(_ sender: UIButton) {
        calendarBodyWeight.scrollToSegment(.previous)
    }
    
    @IBAction func forwardMonthButtonTapped(_ sender: UIButton) {
        calendarBodyWeight.scrollToSegment(.next)
    }
    
    
    //MARK: - UI Elements
    
    func setUpButtons() {
        
        minusButton.isUserInteractionEnabled = true
        minusButton.layer.cornerRadius = minusButton.frame.width / 2
        minusButton.layer.masksToBounds = true
        minusButton.layer.borderColor = Colors.greenColor.cgColor
        minusButton.layer.borderWidth = 1
        
        plusButton.isUserInteractionEnabled = true
        plusButton.layer.cornerRadius = plusButton.frame.width / 2
        plusButton.layer.masksToBounds = true
        plusButton.layer.borderColor = Colors.greenColor.cgColor
        plusButton.layer.borderWidth = 1
        
        saveButton.layer.cornerRadius = 20
    }
    
    func disableButtons() {
        plusButton.backgroundColor?.withAlphaComponent(0.1)
        plusButton.layer.borderColor = UIColor.clear.cgColor
        plusButton.isUserInteractionEnabled = false
        minusButton.backgroundColor?.withAlphaComponent(0.1)
        minusButton.layer.borderColor = UIColor.clear.cgColor
        minusButton.isUserInteractionEnabled = false
    }
}

extension BodyWeightCalendarViewController: BodyWeightCalendarPresenterDelegate {
    func checkIfEnableButtons(enable: Bool) {
        if enable == true {
            setUpButtons()
        } else {
            disableButtons()
        }
    }
    
    func updateIfSavedInSelectedDate(value: String) {
        weightTextField.text = value
        unitLabel.isHidden = false
        unitLabel.textColor = .white
    }
    
    func updateIfNoSaveInSelectedDate() {
        weightTextField.text = "No weight saved"
        unitLabel.isHidden = true
    }
    
    func passBodyWeightCalendarData(data: [BodyWeightCalendarModel]) {
        
        bodyWeightCalendarData = data
        
        guard let lastWeight = bodyWeightCalendarData.last?.weight else { return weightTextField.placeholder = "Enter weight"}
        
        let placeholderColor = NSAttributedString(string: "\(lastWeight)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
        weightTextField.attributedPlaceholder = placeholderColor
        
        weight = lastWeight
    }
}

extension BodyWeightCalendarViewController: CalendarReusableClassDelegate {
    
    func updateUIAfterSelection(selected date: Date) {
        weightTextField.text = ""
        unitLabel.isHidden = false
        unitLabel.textColor = .darkGray
        
        bodyWeightCalendarPresenter.checkIfSavedWeightSelectedDate(selectedDate: date)
        bodyWeightCalendarPresenter.informUserAboutNoSave(selectedDate: date)
        bodyWeightCalendarPresenter.updateButtonPropertiesAfterSelection(selectedDate: date)

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

extension BodyWeightCalendarViewController: KeyboardNotificationDelegate {
    
    func calculateKeyboardShowHeight(notification: NSNotification) -> CGFloat {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            // if keyboard size is not available for some reason, dont do anything
            return 0
        }
        
        // move the root view up by the distance of keyboard height
        let heightToSubtract = keyboardSize.height - ((self.tabBarController?.tabBar.frame.size.height) ?? 0)
        return heightToSubtract
    }
    
    func keyboardWillBeShown(notification: NSNotification) {

        self.view.frame.origin.y -= calculateKeyboardShowHeight(notification: notification)
    }
    
    func keyboardWillBeHidden(notification: NSNotification) {

        self.view.frame.origin.y += calculateKeyboardShowHeight(notification: notification)
    }
}
