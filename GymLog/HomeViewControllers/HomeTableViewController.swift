//
//  HomeTableViewController.swift
//  GymLog
//
//  Created by Barbara Podgórska on 27/02/2021.
//

import UIKit
import Firebase

class HomeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WorkoutTableCellDelegate {
   
    let service = Service()
    @IBOutlet weak var addWorkoutButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    var workoutsName: [String] = []
    
    var workouts: [WorkoutsTitle] = []
    
    var exercises: [String: [String]] = [:]
    
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
        saveWorkoutsTitleInMemory()
        saveExercisesInMemory()
    }
    
    func retrieveWorkouts() {
      
        workouts = []
        workoutsName = []
            self.service.retrieveWorkoutTitle { (a,b) in
           
            self.workouts = a
            self.workoutsName = b
      
            DispatchQueue.main.async {
                    self.tableView.reloadData()
            }
                self.getExercisesForWorkout()
        }
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
    
    func saveWorkoutsTitleInMemory() {
        
        UserDefaults.standard.set(workoutsName.distinct(), forKey: "workoutsName")
      
    }
    
    func saveExercisesInMemory() {
        UserDefaults.standard.set(exercises, forKey: "exercises")
        print("exercises are \(exercises)")
    }
    
    func getExercisesForWorkout() {
        
        service.getExercisesForWorkouts(arrayOfTitles: workoutsName) { (data) in
            self.exercises = data
            
            print("exercises to \(data)")
        }
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


