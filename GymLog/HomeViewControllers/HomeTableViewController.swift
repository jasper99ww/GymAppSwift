//
//  HomeTableViewController.swift
//  GymLog
//
//  Created by Barbara Podgórska on 27/02/2021.
//

import UIKit
import Firebase

class HomeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WorkoutTableCellDelegate {
   
    @IBOutlet weak var addWorkoutButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    var workoutsName: [String] = []
    
    var workouts: [WorkoutsTitle] = []
    
    let db = Firestore.firestore()
    
    let user = Auth.auth().currentUser
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.backgroundColor = UIColor.init(red: 18/255, green: 18/255, blue: 18/255, alpha: 1)
        retrieveWorkouts()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.init(red: 18/255, green: 18/255, blue: 18/255, alpha: 1)
        
       
    }
    override func viewWillDisappear(_ animated: Bool) {
        sendDataToCalendar()
    }
    
    
    func retrieveWorkouts() {
        
        db.collection("users").document("\(user!.uid)").collection("WorkoutsName").getDocuments(completion: { (querySnapshot, error) in
            self.workouts = []
            if let error = error
                       {
                           print("\(error.localizedDescription)")
                       }
                       else {
                           if let snapshotDocuments = querySnapshot?.documents {
                               for doc in snapshotDocuments {
           
                                   let data = doc.data()
                                   if let workoutTitle = data["workoutTitle"] as? String, let workoutDay = data["workoutDay"] as? String {
           
                                    let newTitle = WorkoutsTitle(workoutTitle: workoutTitle, workoutDay: workoutDay)
           
                                        self.workouts.append(newTitle)
                                    self.workoutsName.append(workoutTitle)
                           
                                       }
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                 print("Success")
            
                                }
                               
                                   }
                               }
                       }
        })
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return workouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutFirstCell", for: indexPath) as! WorkoutTableCell
        
        cell.workoutField?.setTitle(workouts[indexPath.row].workoutTitle, for: .normal)
        cell.index = indexPath
        cell.cellDelegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func sendDataToCalendar() {
        
        UserDefaults.standard.set(workoutsName.distinct(), forKey: "workoutsName")
      
    }
}
extension HomeTableViewController  {
    func onClickCell(index: Int) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "optionsVC") as? OptionsViewController else { return }
            vc.titleValue = workouts[index].workoutTitle
            vc.dayOfWorkout = workouts[index].workoutDay
        navigationController?.pushViewController(vc, animated: true)
        }
    }

extension Array where Element: Hashable {
    func distinct() -> Array<Element> {
        var set = Set<Element>()
        return filter {
            guard !set.contains($0) else { return false }
            set.insert($0)
            return true
        }
    }
}


