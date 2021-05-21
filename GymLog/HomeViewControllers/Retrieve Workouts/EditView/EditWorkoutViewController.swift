//
//  EditWorkoutViewController.swift
//  GymLog
//
//  Created by Barbara Podgórska on 23/03/2021.
//

import UIKit
import Firebase


class EditWorkoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EditWorkoutCellDelegate{
 
    
  
    
    
    var titleValue: String = ""
    var dayOfWorkoutString: String = ""
    @IBOutlet weak var daysOfWorkout: UILabel!
    
    let user = Auth.auth().currentUser
    
    var db = Firestore.firestore()
 
    var models: [DataCell] = []
//    {
//        didSet {
//            tableView.reloadData()
//        }
//    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationItem.title = "Edit \(titleValue)"
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "editWorkoutCell", for: indexPath) as! EditWorkoutCell
      
       
        cell.retrievedNumber?.text = String(indexPath.row + 1)
        cell.editableExercise?.text = models[indexPath.row].Exercise
        cell.editableKG?.text = models[indexPath.row].kg
        cell.editableSets?.text = models[indexPath.row].sets
        cell.editableReps?.text = models[indexPath.row].reps
     
        updateAfterDelete(at: String(indexPath.row + 1), indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108
    }
  
    func deleteExercise(at indexPath: IndexPath, bool: Bool) {
        
        if bool == true {
        db.collection("users").document("\(user!.uid)").collection("WorkoutsName").document("\(titleValue)").collection("Exercises").whereField("Number", isEqualTo: "\((indexPath.row) + 1)").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    document.reference.delete()
                    self.tableView.reloadData()
            }
        }
            self.models.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .left)
    }
    }
        else {
            print("nie usuwamy nic")
        }
    }
    
    func updateAfterDelete(at cellNumber: String, indexPath: IndexPath) {
        
        db.collection("users").document("\(user!.uid)").collection("WorkoutsName").document("\(titleValue)").collection("Exercises").document("\(self.models[indexPath.row].Exercise)").updateData(["Number" : "\(cellNumber)"])

}
    
//    func tappedSavedCellButton(at indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath) as! EditWorkoutCell
//        cell.cellDelegate = self
//
////        cell.editableExercise.isUserInteractionEnabled = false
//        cell.editableExercise.alpha = 1
//
////        cell.editableKG.isUserInteractionEnabled = false
//        cell.editableKG.alpha = 1
//
////        cell.editableSets.isUserInteractionEnabled = false
//        cell.editableSets.alpha = 1
//
////        cell.editableReps.isUserInteractionEnabled = false
//        cell.editableReps.alpha = 1
//
//    }
    
    func saveEditedData(at indexPath: IndexPath) {

        let cell = tableView.cellForRow(at: indexPath) as! EditWorkoutCell

        if let newExercise = cell.editableExercise!.text, let newReps = cell.editableReps!.text, let newSets = cell.editableSets!.text, let newKg = cell.editableKG!.text {
        db.collection("users").document("\(user!.uid)").collection("WorkoutsName").document("\(titleValue)").collection("Exercises").document("\(self.models[indexPath.row].Exercise)").updateData(["Exercise": newExercise, "Reps": newReps, "Sets": newSets, "kg": newKg])
//
//        }
//
    }
    }
    
    func changedTextFieldProperties(at indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! EditWorkoutCell
        cell.editableExercise.isUserInteractionEnabled = true
        cell.editableExercise.alpha = 0.4
        
        cell.editableKG.isUserInteractionEnabled = true
        cell.editableKG.alpha = 0.4
        
        cell.editableSets.isUserInteractionEnabled = true
        cell.editableSets.alpha = 0.4
        
        cell.editableReps.isUserInteractionEnabled = true
        cell.editableReps.alpha = 0.4
        
    }
    

  
    // MARK: - Table View delegate
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // delete
        let delete = UIContextualAction(style: .normal, title: "Delete") { (action, view, completionHandler) in
            print("delete\(indexPath.row + 1)")
            completionHandler(true)
            self.deleteExercise(at: indexPath, bool: true)
        }
        delete.image = UIImage(named: "delete-icon")
        delete.backgroundColor = .red
        
        // edit
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
            print("edit\(indexPath.row + 1)")
            completionHandler(true)
            let cell = tableView.cellForRow(at: indexPath) as! EditWorkoutCell
            cell.checkBox.isHidden = false
            cell.index = indexPath
            self.changedTextFieldProperties(at: indexPath)
            cell.cellDelegate = self
            
            
        }
        edit.image = UIImage(systemName: "pencil")
        edit.backgroundColor = UIColor(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        
        // swipe actions
        let swipe = UISwipeActionsConfiguration(actions: [delete, edit])
        return swipe
        
    }
    
 

}


extension EditWorkoutViewController {
    func saveNewFields(indexPath: IndexPath) {
       saveEditedData(at: indexPath)
    }
}


extension UIView {
    func shake(bool: Bool) {
        if bool == true {
        let animation = CABasicAnimation(keyPath: "position")
                animation.duration = 0.05
                animation.repeatCount = 1000
                animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 2, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 2, y: self.center.y))
                self.layer.add(animation, forKey: "position")

    }
        else {
           return
}
}
}

    


