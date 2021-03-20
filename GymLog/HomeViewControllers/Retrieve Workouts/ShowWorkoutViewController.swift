//
//  ShowWorkoutViewController.swift
//  GymLog
//
//  Created by Barbara Podgórska on 12/03/2021.
//

import UIKit
import Firebase

class ShowWorkoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    var titleValue: String = ""
    var dayOfWorkoutString: String = ""
    @IBOutlet weak var daysOfWorkout: UILabel!
    
    let user = Auth.auth().currentUser
    
    var db = Firestore.firestore()
 
    var models: [DataCell] = []
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationItem.title = titleValue
        self.navigationController?.navigationBar.backgroundColor = UIColor.init(red: 24/255, green: 24/255, blue: 24/255, alpha: 1)
        self.tableView.contentInsetAdjustmentBehavior = .never
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.init(red: 24/255, green: 24/255, blue: 24/255, alpha: 1)
        daysOfWorkout.text = dayOfWorkoutString
        retrieveWorkouts()
        

    }
    
    func retrieveWorkouts() {
        
        db.collection("users").document("\(user!.uid)").collection("Workouts").whereField("workoutName", isEqualTo: "\(titleValue)").order(by: "Number").getDocuments { (querySnapshot, error) in
            if let error = error
                       {
                           print("\(error.localizedDescription)")
                       }
                       else {
                           if let snapshotDocuments = querySnapshot?.documents {
                               for doc in snapshotDocuments {
           
                                   let data = doc.data()
                                   if let numberDb = data["Number"] as? String, let exerciseDb = data["Exercise"] as? String, let kgDb = data["kg"] as? String, let setsDb = data["Sets"] as? String, let repsDb = data["Reps"] as? String, let workoutName = data["workoutName"] as? String {
           
                                       print("data is \(data)")
                                       let newModel = DataCell(Number: numberDb, Exercise: exerciseDb, kg: kgDb, sets: setsDb, reps: repsDb, workoutName: workoutName)
           
                                       self.models.append(newModel)
           
                                       }
                                   self.tableView.reloadData()
           
           
                                   }
                               }
                           }
        
    }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "retrieveWorkoutCell", for: indexPath) as! RetrieveWorkoutCell
        
        cell.retrievedNumber?.text = models[indexPath.row].Number
        cell.retrievedExercise?.text = models[indexPath.row].Exercise
        cell.retrievedKG?.text = models[indexPath.row].kg
        cell.retrievedSets?.text = models[indexPath.row].sets
        cell.retrievedReps?.text = models[indexPath.row].reps
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108
    }
    
    
        
        
    }



