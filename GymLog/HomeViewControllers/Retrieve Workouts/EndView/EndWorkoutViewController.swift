//
//  EndWorkoutViewController.swift
//  GymLog
//
//  Created by Barbara Podgórska on 19/04/2021.
//

import UIKit
import Firebase

class EndWorkoutViewController: UIViewController {
    
    var titleValue: String = ""
    var weightArray: Int = 0
    var setsArray: Int = 0
    var repsArray: Int = 0
    var endedTime = String()
    var volume: Int = 0
    
    let user = Auth.auth().currentUser
    var db = Firestore.firestore()
    let start = StartViewController()
    
    @IBOutlet weak var imageCup: UIImageView!
    @IBOutlet weak var totalWeight: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var totalSets: UILabel!
    @IBOutlet weak var sets: UILabel!
    @IBOutlet weak var totalReps: UILabel!
    @IBOutlet weak var reps: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var totalTime: UILabel!
    
    
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      getWeight()
        getSets()
        getReps()
        getTime()
        saveData()
    }
    
    @IBAction func continueButtonTapped(_ sender: UIButton) {
    
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popToRootViewController(animated: true)
    
    }
    

    func getWeight() {
      
        let totalLabel = weightArray
        weight.text = String(totalLabel)
        
    }
    
    func getSets() {
        let sumSets = setsArray
        sets.text = String(sumSets)
    }

    func getReps() {

        let sumRepsLabel = repsArray
        reps.text = String(sumRepsLabel)
    }
    
    func getTime() {
        totalTime.text! = endedTime
    }
    
    
    func saveData() {
       
        let date = Date()
        let formate = date.getFormattedDate(format: "yyyy-MM-dd HH:mm")
        
        let docData : [String: Any] = ["Weight" : weight.text!, "Reps" : reps.text!, "Time": endedTime, "Volume": volume]
        
        db.collection("users").document("\(user!.uid)").collection("WorkoutsName").document("\(titleValue)").collection("Calendar").document("\(formate)").setData(docData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
}
