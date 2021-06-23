//
//  BodyWeightTableViewController.swift
//  GymLog
//
//  Created by Kacper P on 24/06/2021.
//

import UIKit

class BodyWeightTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
  
    @IBOutlet weak var tableView: UITableView!
    
    
    var arrayMain: [String] = ["Body weight calendar", "Calories", "BMI"]
    var arraySecond: [String] = ["Fill your body weight diary", "Calculate your daily calorie requirement", "Calculate your bmi"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMain.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bodyWeightCell", for: indexPath) as! BodyWeightTableViewCell
        
        cell.mainLabel.text = arrayMain[indexPath.row]
        cell.secondLabel.text = arraySecond[indexPath.row]
        
        
        return cell
    }
    
    
}
