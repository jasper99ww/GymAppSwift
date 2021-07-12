//
//  AddWorkoutViewController.swift
//  GymLog
//
//  Created by Barbara Podgórska on 27/02/2021.
//

import UIKit
import Firebase

class AddWorkoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var workoutName: UITextField!
    @IBOutlet weak var daysOfWorkout: UITextField!
    @IBOutlet weak var SaveButton: UIBarButtonItem!
    
    
    @IBOutlet weak var AddExercise: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let addWorkoutCell = AddWorkoutCell()
    
    let user = Auth.auth().currentUser
    
    let db = Firestore.firestore()
    
    var models: [DataCell] = []
    
    var days: [String] = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    var amPm: [String] = ["AM", "PM"]
    var index: Int = 0
//    var selectedDay = String()
//    var selected
    
    var pickerView = UIPickerView()
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.backgroundColor = UIColor.init(red: 24/255, green: 24/255, blue: 24/255, alpha: 1)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        pickerView.delegate = self
        pickerView.dataSource = self
       createToolBar()
        setUpElements()
        self.tableView.backgroundColor = UIColor.init(red: 24/255, green: 24/255, blue: 24/255, alpha: 1)
        endEditing()
    
    }

    func createToolBar() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
        toolBar.sizeToFit()
        let btnDone = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(pickerDoneButton))
        toolBar.setItems([btnDone], animated: true)
        daysOfWorkout.inputView = pickerView
        daysOfWorkout.inputAccessoryView = toolBar
        
    }
    
    @objc func pickerDoneButton() {
        view.endEditing(true)
        
       
        let selectedDay = days[pickerView.selectedRow(inComponent: 0)]
        let selectedHour = String(pickerView.selectedRow(inComponent: 1))
        let selectedMinute = String(pickerView.selectedRow(inComponent: 2))
        let selectedDateFormat = amPm[(pickerView.selectedRow(inComponent: 3))]
        daysOfWorkout.text = "\(selectedDay) \(selectedHour):\(selectedMinute) \(selectedDateFormat)"
    }
    
    
    @IBAction func didTapNewExercise(_ sender: Any) {
        
        if  workoutName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""  {
            Alert.showIncompleteFormAlert(on: self)
        } else {
            
        
        guard let vc = storyboard?.instantiateViewController(identifier: "new") as? EntryViewController else {
            return
        }
            vc.addWorkoutViewController.workoutName = workoutName
        vc.completion = { number, exercise, Kg, sets, reps, workoutName in
            self.navigationController?.popToViewController(self, animated: true)
            self.models.append(DataCell(Number: number, Exercise: exercise, kg: Kg, sets: sets, reps: reps, workoutName: workoutName))
            self.tableView.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addWorkoutCell", for: indexPath) as! AddWorkoutCell
        cell.Number?.text = models[indexPath.row].Number
        cell.Exercise?.text = models[indexPath.row].Exercise
        cell.kg?.text = models[indexPath.row].kg
        cell.Sets?.text = models[indexPath.row].sets
        cell.Reps?.text = models[indexPath.row].reps
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func setUpElements() {
        UnderlinedTextField.awakeFromNib()
        AddExercise.layer.cornerRadius = 5
        AddExercise.layer.borderWidth = 1
        AddExercise.layer.borderColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
   
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        guard let vcHome = storyboard?.instantiateViewController(identifier: "Home") as? HomeTableViewController else {
            print("failed to get vc from storyboard")
            return
        }
        saveWorkoutName()
        let homeTableViewController = HomeTableViewController()
        homeTableViewController.tableView?.reloadData()
        navigationController?.pushViewController(vcHome, animated: true)
    }

    func saveWorkoutName() {
        if let workoutTitle = workoutName.text, let workoutDay = daysOfWorkout.text {
            db.collection("users").document("\(user!.uid)").collection("WorkoutsName").document("\(workoutTitle)").setData(["workoutTitle": workoutTitle, "workoutDay": workoutDay]) { (error) in
                
                if let e = error {
                    print("There was an issue saving data to firestore, \(e)")
                } else {
                    print("Succesfully saved data.")
                
                }
                
            }
    }
    }
    
    
    func endEditing() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        
    }
    
    @objc
    private func hideKeyboard() {
        self.view.endEditing(true)
    }
}

extension AddWorkoutViewController: UIPickerViewDelegate, UIPickerViewDataSource {
   
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return days.count
        case 1:
            return 13
        case 2:
            return 61
        case 3:
            return amPm.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        index = row
        print("row is \(row)")
        switch component {
        case 0:
            let a = days[row]
            print("day is \(a)")
        case 1:
             print("to godzina \(row)")
        case 2:
            print("to minuta \(row)")
        case 3:
            print("to czas \(amPm[row])")
        default:
            print("DEFAULT")
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch component {
        case 0:
            return pickerView.frame.size.width * 0.3
        case 1:
            return pickerView.frame.size.width * 0.2
        case 2:
            return pickerView.frame.size.width * 0.2
        case 3:
            return pickerView.frame.size.width * 0.3
        default:
            return pickerView.frame.size.width / 4
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return days[row]
        case 1:
            return "\(row)"
        case 2:
            if row < 10 {
                return "0\(row)"
            }
                else {
                    return "\(row)"
                }
       
        case 3:
            return amPm[row]
        default:
            return ""
        }
    }
    
    
    
}
