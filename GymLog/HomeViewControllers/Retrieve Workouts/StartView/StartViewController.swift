//
//  StartViewController.swift
//  GymLog
//
//  Created by Barbara Podgórska on 05/04/2021.
//

import UIKit
import Firebase

class StartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, StartViewCellDelegate {
    
    let startService = StartService()
    var lastTrainingData: [String: [LastTraining]] = [:]
   
    
    var weightArraySend = [String?]()
    var setsArraySend = [Int]()
    var repsArraySend = [String?]()
    
    var volumeArray: Int = 0
    
    @IBOutlet weak var workoutName: UILabel!
    
    @IBOutlet weak var timerClock: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    var timer:Timer = Timer()
    var count:Int = 0
    let currentDateTime = Date()
    let timeStruct = TimerStruct()
    @IBOutlet weak var nextButton: UIButton!
    var titleValue: String = ""
    
    var dayOfWorkout: String = ""
    
    var exerciseNumber: Int = 0
    
    var models: [DataCell] = []
    
    let user = Auth.auth().currentUser
    
    var db = Firestore.firestore()
    
    var constantValueInPlaceholder = Bool()
    var arrayOfTitleDocuments: [String: [String]] = [:]
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.navigationBar.backgroundColor = UIColor.init(red: 24/255, green: 24/255, blue: 24/255, alpha: 1)
        
        if #available(iOS 13.0, *) {
            let navBarApperance = UINavigationBarAppearance()
            navBarApperance.configureWithOpaqueBackground()
            navBarApperance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarApperance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navBarApperance.backgroundColor = UIColor.init(red: 18/255, green: 18/255, blue: 18/255, alpha: 1)
            navigationController?.navigationBar.standardAppearance = navBarApperance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarApperance
        }
        
//        let app = UINavigationBarAppearance()
//        app.backgroundColor = UIColor.init(red: 24/255, green: 24/255, blue: 24/255, alpha: 1)
//        self.navigationController?.navigationBar.scrollEdgeAppearance = app
        nextButton.titleLabel?.adjustsFontSizeToFitWidth = true
        placeholderValue()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        retrieveDocumentsArray()
        getLastTraining()
     
        progressView?.transform = progressView.transform.scaledBy(x: 1, y: 3)
        
        tableView?.delegate = self
        tableView?.dataSource = self
        retrieveWorkouts()
        startTimers(isEnded: false)
//        workoutName.text = titleValue
        tableView.sizeToFit()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        initialSelect()
    }
    
  
    
    func getLastTraining() {
        startService.getLastTraining(titleValue: titleValue, exercises: arrayOfTitleDocuments, completionHandler: { data in
            self.lastTrainingData = data
            self.tableView.reloadData()
        })
    }
    
    func retrieveDocumentsArray() {
        
        if let arrayTitleDocuments = UserDefaults.standard.object(forKey: "exercises") as? [String: [String]] {
            arrayOfTitleDocuments = arrayTitleDocuments
        }
    }
    
    func placeholderValue() {
        let placeholderConstantValueFromMemory = UserDefaults.standard.bool(forKey: "placeholderConstantValue")
        constantValueInPlaceholder = placeholderConstantValueFromMemory
    }
    
    func startTimers(isEnded: Bool) {

        timeStruct.startTimer()
        timeStruct.label = { timeLabel in
            
            self.timerLabel.text = timeLabel
        }
    }

    @IBAction func nextButtonPressed(_ sender: UIButton) {
      
        let check = checkIfButtonIsChecked()
        
        if check == true {
        afterNextButtonTapped()
        nextExercise()
        checkIfLast()
            
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateUI), userInfo: nil, repeats: false)
        DispatchQueue.main.async {
            self.initialSelect()
            self.tableView.reloadData()
        }
            }
        
        else {
            Alert.showBeforeNextExerciseAlert(on: self)
        }
    }
    
    @objc func updateUI() {
        progressView.progress = getProgress()
    }
    
    func getProgress() -> Float {
        return Float(exerciseNumber) / Float(models.count)
    }
  
    func nextExercise() {
        if exerciseNumber + 1 < models.count {
            exerciseNumber += 1
        }
        else {
            showEndWorkout()
        }
    }
    
    func checkIfLast() {
        
        guard exerciseNumber + 1 == models.count else {
            return
        }
        
        nextButton.setTitle("End", for: .normal)
//
//        if exerciseNumber + 1  == models.count {
//            nextButton.setTitle("End", for: .normal)
//        }

    }
    
    // MARK: - TABLE VIEW
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard !models.isEmpty else {return 0}
        return Int(models[exerciseNumber].sets)!
    }
    
    func initialSelect() {
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "startViewCell", for: indexPath) as! StartViewCell
        
        print("cnstant value \(constantValueInPlaceholder)")
        cell.setKg.text = ""
        cell.setReps.text = ""
        cell.setField?.text = String(indexPath.row + 1)
        exerciseLabel?.text = models[exerciseNumber].Exercise
        cell.checkmarkButton.isSelected = false
        cell.index = indexPath
        cell.cellDelegate = self
        
        if constantValueInPlaceholder {
            cell.setKg?.placeholder = models[indexPath.row].kg
            cell.setReps?.placeholder = models[indexPath.row].reps
          
        }
            else {
                for (key,values) in lastTrainingData {
                    if key == models[exerciseNumber].Exercise {
                            cell.setKg?.placeholder = values[indexPath.row].kg
                            cell.setReps?.placeholder = values[indexPath.row].reps
                        }
                    }
        }
        
        return cell
            
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    // MARK: - FIRESTORE

    func retrieveWorkouts() {

        db.collection("users").document("\(user!.uid)").collection("WorkoutsName").document("\(titleValue)").collection("Exercises").order(by: "Number").getDocuments { (querySnapshot, error) in
            if let error = error
                       {
                           print("\(error.localizedDescription)")
                       }
                       else {
                           if let snapshotDocuments = querySnapshot?.documents {
                               for doc in snapshotDocuments {
           
                                   let data = doc.data()
                                   if let numberDb = data["Number"] as? String, let exerciseDb = data["Exercise"] as? String, let kgDb = data["kg"] as? String, let setsDb = data["Sets"] as? String, let repsDb = data["Reps"] as? String, let workoutName = data["workoutName"] as? String {
           
                                       let newModel = DataCell(Number: numberDb, Exercise: exerciseDb, kg: kgDb, sets: setsDb, reps: repsDb, workoutName: workoutName)
           
                                       self.models.append(newModel)
           
                                       }
                                   self.tableView.reloadData()
           
           
                                   }
                               }
                           }
        
    }
    }

    func afterNextButtonTapped() {
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        df.timeZone = TimeZone.current
        let dateString = df.string(from: currentDateTime)
        
       let date = Date()
       let formate = date.getFormattedDate(format: "yyyy-MM-dd HH:mm")
        
        var docSets : [String : [String:String]] = [:]
        var docArray: [String:String] = [:]
        var maxValue = [String:Int]()
        weightArraySend = []
        repsArraySend = []
       
        for indexPath in tableView.indexPathsForVisibleRows! {

        let cell = tableView.cellForRow(at: indexPath) as? StartViewCell

            docArray["kg"] = cell?.setKg.text
            docArray["reps"] = cell?.setReps.text
            docSets["\(indexPath.row + 1)"] = docArray
//            docArray.append(["kg" : cell?.setKg.text, "reps" : cell?.setReps.text])
            weightArraySend.append(cell?.setKg.text)
            repsArraySend.append(cell?.setReps.text)
            setsArraySend.append(indexPath.row + 1)
            if let kg = cell?.setKg.text, let reps = cell?.setReps.text {
                let value = Int(kg)! * Int(reps)!
                volumeArray += value
            }
            
        }
        
            
        let intWeightArray = weightArraySend.compactMap { Int($0!)}
        let intRepsArray = repsArraySend.compactMap {Int($0!)}
        maxValue["weight"] = intWeightArray.max()!
        maxValue["doneReps"] = intRepsArray.max()!
        
        
        
        let docData : [String:Any] = ["Volume": volumeArray ,"Max": maxValue, "date" : dateString, "Sets": docSets]
   
        
        db.collection("users").document("\(user!.uid)").collection("WorkoutsName").document("\(titleValue)").collection("Exercises").document("\(exerciseLabel.text!)").collection("History").document("\(formate)").setData(docData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        }
    
    
        
    
    func checkIfButtonIsChecked() -> Bool {
        
        for indexPath in tableView.indexPathsForVisibleRows! {

            let cell = tableView.cellForRow(at: indexPath) as? StartViewCell
         
            if let kg = cell?.setKg.text, let reps = cell?.setReps.text, !kg.isEmpty, !reps.isEmpty && cell?.checkmarkButton.isSelected == true {
                
//                cell?.setKg.text = ""
//                cell?.setReps.text = ""
                
                return true
            }
        
        }
        return false
    }
 
    func tappedButton(indexPath: IndexPath) {
        let index = IndexPath(row: indexPath.row + 1, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! StartViewCell
        if let set = cell.setField.text, let kg = cell.setKg.text, let reps = cell.setReps.text, !set.isEmpty, !kg.isEmpty, !reps.isEmpty {
            self.tableView.deselectRow(at: indexPath, animated: true)
        self.tableView.selectRow(at: index, animated: true, scrollPosition: .none)
    }
        else {
            Alert.showIncompleteSetAlert(on: self)
        }
    }
    
    func showEndWorkout() {
        
        let view = storyboard?.instantiateViewController(identifier: "end") as! EndWorkoutViewController
        self.navigationController?.pushViewController(view, animated: true)
        
        let weightArraySendSum = weightArraySend.compactMap { Int($0!)}.reduce(0, +)
        let repsArraySendSum = repsArraySend.compactMap {Int($0!)}.reduce(0,+)
        let setsArraySendSum = setsArraySend.compactMap {Int($0)}.reduce(0,+)
        view.weightArray = weightArraySendSum
        view.repsArray = repsArraySendSum
        view.setsArray = setsArraySendSum
        view.volume = volumeArray
        
        timeStruct.timer.invalidate()
        view.endedTime = timerLabel.text!
        view.totalTime?.text = timerLabel.text
        view.titleValue = titleValue
    }
}

extension Date {
    func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
    
    
}
