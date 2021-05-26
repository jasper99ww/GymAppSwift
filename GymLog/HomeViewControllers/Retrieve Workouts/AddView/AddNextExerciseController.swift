//
//  AddNextExerciseController.swift
//  GymLog
//
//  Created by Barbara Podgórska on 28/03/2021.
//

import UIKit
import Firebase

class AddNextExerciseController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addNextExerciseButton: UIButton!
    
    @IBOutlet weak var saveButton: UIButton!
    
    var titleValue: String = ""
    var dayOfWorkoutString: String = ""
    
    let user = Auth.auth().currentUser
    
    var db = Firestore.firestore()
 
    var models: [DataCell] = []
    
    var modelsBefore: [DataCell] = []
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationItem.title = "Add exercise in \(titleValue)"
        self.navigationController?.navigationBar.backgroundColor = UIColor.init(red: 24/255, green: 24/255, blue: 24/255, alpha: 1)
        self.tableView.contentInsetAdjustmentBehavior = .never
        retrieveWorkouts()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.init(red: 24/255, green: 24/255, blue: 24/255, alpha: 1)
        
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(did))
      
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addNextExerciseCell", for: indexPath) as! NextExerciseCell
        
        cell.newNumber?.text = String(indexPath.row + 1)
        cell.newExercise?.text = models[indexPath.row].Exercise
        cell.newKG?.text = models[indexPath.row].kg
        cell.newSets?.text = models[indexPath.row].sets
        cell.newReps?.text = models[indexPath.row].reps
        
        
        if indexPath.row == models.count - 1 && cell.newExercise.text?.isEmpty == true {

            cell.newNumber.isUserInteractionEnabled = true
            cell.newExercise.isUserInteractionEnabled = true
            cell.newKG.isUserInteractionEnabled = true
            cell.newSets.isUserInteractionEnabled = true
            cell.newReps.isUserInteractionEnabled = true
            print("Button tapped")

        }

        return cell
    }
    
    @IBAction func nextExcerciseButtonTapped(_ sender: UIButton) {
        
        self.view.backgroundColor = UIColor.init(red: 24/255, green: 24/255, blue: 24/255, alpha: 0.6)
        
        self.performSegue(withIdentifier: "goToModal", sender: nil)
        tableView.dragInteractionEnabled = true
        tableView.isEditing = true
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
        if segue.identifier == "goToModal" {
            let vc = segue.destination as! ModalAddViewController
            vc.completionHandler = { newExercise, newKg, newSets, newReps in
    
                self.models.append(DataCell(Number: "\(self.models.count - 1)", Exercise: newExercise, kg: newKg, sets: newSets, reps: newReps, workoutName: "\(self.titleValue)"))
                self.tableView.reloadData()
            }
        }
    }
    
        
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        for index in 0...models.count - 1 {
        
        if let newNumber = self.models[index].Number as String?, let newExercise = self.models[index].Exercise as String?, let newKg = self.models[index].kg as String? , let newSets = self.models[index].sets as String?, let newReps = self.models[index].reps as String? {
            self.db.collection("users").document("\(self.user!.uid)").collection("WorkoutsName").document("\(self.titleValue)").collection("Exercises").document("\(newExercise)").setData(["Number": newNumber, "Exercise": newExercise, "kg": newKg, "Sets": newSets, "Reps": newReps, "uid": self.user!.uid, "workoutName":  "\(self.titleValue)"]) { error in
            if let e = error {
                print("There was an issue saving data to firestore, \(e)")
            } else {
                print("Succesfully saved data.")

            }
        }
        }
        }
    
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        models.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        
    }
    
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
 
    func retrieveWorkouts() {

        db.collection("users").document("\(user!.uid)").collection("WorkoutsName").document("\(titleValue)").collection("Exercises").whereField("workoutName", isEqualTo: "\(titleValue)").order(by: "Number").getDocuments { (querySnapshot, error) in
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
           
                                       self.modelsBefore.append(newModel)
                                        self.models.append(newModel)
           
                                       }
                                   self.tableView.reloadData()
           
           
                                   }
                               }
                           }
        
    }
    }
}


