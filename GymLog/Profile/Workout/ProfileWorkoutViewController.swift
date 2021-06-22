//
//  ProfileWorkoutViewController.swift
//  GymLog
//
//  Created by Kacper P on 18/06/2021.
//

import UIKit

class ProfileWorkoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    var constantValueInPlaceholder: Bool = false

    
    let unitClass = UnitClass()
    let start = StartViewController()
    @IBOutlet weak var tableView: UITableView!
    var arrayOfSettings = ["Units", "Progression", "Vibrations"]
    var arrayOfSecondLabels = ["Select unit", "Prompt values: from last training or constant value", "Vibrations when pause is finished"]
    var segmentedControlFirstSegment = ["KG", "LAST"]
    var segmentedControlSecondSegment = ["LB", "CONSTANT"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ProfileWorkoutOtherSettings", bundle: nil), forCellReuseIdentifier: "workoutOtherSettings")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfSettings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < 2 {
            
        let customCell = self.tableView.dequeueReusableCell(withIdentifier: "workoutSettings", for: indexPath) as! ProfileWorkoutTableViewCell
            customCell.mainLabel.text = arrayOfSettings[indexPath.row]
            customCell.secondLabel.text = arrayOfSecondLabels[indexPath.row]
            customCell.segmentedControl.setTitle(segmentedControlFirstSegment[indexPath.row], forSegmentAt: 0)
            customCell.segmentedControl.setTitle(segmentedControlSecondSegment[indexPath.row], forSegmentAt: 1)
            customCell.segmentedControl.tag = indexPath.row
        return customCell
            
        }
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "workoutOtherSettings", for: indexPath) as! ProfileWorkoutOtherSettings
        cell.mainLabel.text = arrayOfSettings[indexPath.row]
        cell.secondLabel.text = arrayOfSecondLabels[indexPath.row]
        
        return cell
    }
    
  
    @IBAction func segmentedControlChange(_ sender: UISegmentedControl) {
        
        switch sender.tag {
        case 0:
            if sender.selectedSegmentIndex == 0 {
//                NotificationCenter.default.post(name: NotificationNamesClass.nameKG, object: nil)
//            self.unitClass.changeUnitFromLBtoKGInCalendar()
//            self.unitClass.changeUnitFromLBtoKGInHistory()
                print("selected KG")
            } else {
                // LB UNIT SELECTED
//                NotificationCenter.default.post(name: NotificationNamesClass.nameLB, object: nil)
//                self.unitClass.changeUnitFromKGtoLBInCalendar()
//                self.unitClass.changeUnitFromKGtoLBInHistory()
                print("selected LB")
            }
        case 1:
            if sender.selectedSegmentIndex == 0 {
                placeholderConstantValue(value: false)
                print("selected LAST")
            } else {
                placeholderConstantValue(value: true)
                print("selected CONSTANT")
            }
        default:
        break
            }
    }
    
    func placeholderConstantValue(value: Bool) {
        UserDefaults.standard.setValue(value, forKey: "placeholderConstantValue")
    }


}
