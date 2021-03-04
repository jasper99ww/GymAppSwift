//
//  AddWorkoutViewController.swift
//  GymLog
//
//  Created by Barbara Podgórska on 27/02/2021.
//

import UIKit

class AddWorkoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var workoutName: UITextField!
    @IBOutlet weak var daysOfWorkout: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
//    var models: [DataCell] = []
    var models: [(Number: String, Exercise: String, kg: String, sets: String, reps: String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        setUpElements()
        self.tableView.backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
//        tableView.register(AddWorkoutCell.self, forCellReuseIdentifier: "ReusableCell")
//
//
    }
    
    
    
    @IBAction func didTapNewExercise(_ sender: Any) {
        
        guard let vc = storyboard?.instantiateViewController(identifier: "new") as? EntryViewController else {
            return
        }

        vc.completion = { number, exercise, Kg, sets, reps in
            self.navigationController?.popToViewController(self, animated: true)
//            self.models.append(DataCell(number: number, Exercise: exercise, kg: Kg, sets: sets, reps: reps))
//
            self.models.append((number, exercise, Kg, sets, reps))
            self.tableView.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)
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
        cell.Reps?.text = models[indexPath.row].kg
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        

    }

    func setUpElements() {
        UnderlinedTextField.awakeFromNib()
    }

 
    }


