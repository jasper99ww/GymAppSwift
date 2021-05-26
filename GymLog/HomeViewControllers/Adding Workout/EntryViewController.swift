//
//  EntryViewController.swift
//  GymLog
//
//  Created by Barbara Podgórska on 01/03/2021.
//

import UIKit
import Firebase

class EntryViewController: UIViewController {
    
    @IBOutlet weak var Number: UITextField!
    
    @IBOutlet weak var Exercise: UITextField!
    
    @IBOutlet weak var kg: UITextField!
    
    @IBOutlet weak var Sets: UITextField!
    
    @IBOutlet weak var Reps: UITextField!
    
    let addWorkoutViewController = AddWorkoutViewController()
    
    
    public var completion: ((String, String, String, String, String, String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        endEditing()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))
    }
    
    @objc func didTapSave() {
        if let number = Number.text, !number.isEmpty, let exercise = Exercise.text, !exercise.isEmpty, let Kg = kg.text, !Kg.isEmpty, let sets = Sets.text, !sets.isEmpty, let reps = Reps.text, !reps.isEmpty, let workoutName = addWorkoutViewController.workoutName.text {
            
            completion?(number, exercise, Kg, sets, reps, workoutName)
            
            
            let user = Auth.auth().currentUser
            
            if let numberDb = Number.text, let exerciseDb = Exercise.text, let kgDb = kg.text, let setsDb = Sets.text, let repsDb = Reps.text, let workoutName = addWorkoutViewController.workoutName.text {
                
                addWorkoutViewController.db.collection("users").document("\(user!.uid)").collection("Workouts").document().setData(["Number": numberDb, "Exercise": exerciseDb, "kg": kgDb, "Sets": setsDb, "Reps": repsDb, "uid": user!.uid, "workoutName": workoutName ]) { (error) in
                    if let e = error {
                        print("There was an issue saving data to firestore, \(e)")
                    } else {
                        print("Succesfully saved data.")

                    }
                }
            }
            
            if let numberDb = Number.text, let exerciseDb = Exercise.text, let kgDb = kg.text, let setsDb = Sets.text, let repsDb = Reps.text, let workoutName = addWorkoutViewController.workoutName.text {
                
//                let docData: [String: Any] = [
//                    "Number" : numberDb,
//                    "Exercise": exerciseDb,
//                    "kg": kgDb,
//                    "Sets": setsDb,
//                    "Reps": repsDb,
//                    "uid": user!.uid,
//                    "workoutName": workoutName
//                ]
                
                addWorkoutViewController.db.collection("users").document("\(user!.uid)").collection("WorkoutsName").document("\(workoutName)").collection("Exercises").document("\(exerciseDb)").setData(["Number": numberDb, "Exercise": exerciseDb, "kg": kgDb, "Sets": setsDb, "Reps": repsDb, "uid": user!.uid, "workoutName": workoutName ]) { (error) in
                    if let e = error {
                        print("There was an issue saving data to firestore, \(e)")
                    } else {
                        print("Succesfully saved data.")
                    }
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

