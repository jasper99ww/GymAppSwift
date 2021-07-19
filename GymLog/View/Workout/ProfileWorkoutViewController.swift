//
//  ProfileWorkoutViewController.swift
//  GymLog
//
//  Created by Kacper P on 18/06/2021.
//

import UIKit

class ProfileWorkoutViewController: UIViewController {
    
    lazy var workoutPresenter = WorkoutPresenter(workoutmodel: WorkoutModel(), workoutPresenterDelegateForView: self)
    
    @IBOutlet weak var tableView: UITableView!

    private var arrayOfSettings = [WorkoutSettingsDataModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        workoutPresenter.getModel()
        
        tableView.register(UINib(nibName: "ProfileWorkoutOtherSettings", bundle: nil), forCellReuseIdentifier: "workoutOtherSettings")
        tableView.dataSource = self
        tableView.delegate = self

    }
    
    @IBAction func segmentedControlChange(_ sender: UISegmentedControl) {
        
        switch sender.tag {
        case 0:
            
            if sender.selectedSegmentIndex == 0 {
                workoutPresenter.saveSelectedUnitInMemory(unit: "kg")
                workoutPresenter.changeUnitFromLBtoKGInCalendar()
                workoutPresenter.changeUnitFromLBtoKGInHistory()
                
            } else {
                workoutPresenter.saveSelectedUnitInMemory(unit: "lb")
                workoutPresenter.changeUnitFromKGtoLBInCalendar()
                workoutPresenter.changeUnitFromKGtoLBInHistory()
            }
        case 1:
            if sender.selectedSegmentIndex == 0 {
                workoutPresenter.placeholderConstantValue(value: false)
            } else {
                workoutPresenter.placeholderConstantValue(value: true)
            }
        default:
        break
            }
    }
}

extension ProfileWorkoutViewController: WorkoutPresenterDelegateForView {
    func getWorkoutModel(workoutModel: [WorkoutSettingsDataModel]) {
        arrayOfSettings = workoutModel
    }
}

extension ProfileWorkoutViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfSettings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dataModel = arrayOfSettings[indexPath.row]

        if indexPath.row < 2 {
            
        let customCell = self.tableView.dequeueReusableCell(withIdentifier: "workoutSettings", for: indexPath) as! ProfileWorkoutTableViewCell
                       
            customCell.mainLabel.text = dataModel.mainLabelSetting
            customCell.secondLabel.text = dataModel.secondLabelSetting
            customCell.segmentedControl.setTitle(dataModel.segmentedControlFirstSegmentTitle, forSegmentAt: 0)
            customCell.segmentedControl.setTitle(dataModel.segmentedControlSecondSegmentTitle, forSegmentAt: 1)
            customCell.segmentedControl.tag = indexPath.row
            return customCell
            
        }
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "workoutOtherSettings", for: indexPath) as! ProfileWorkoutOtherSettings
        cell.mainLabel.text = dataModel.mainLabelSetting
        cell.secondLabel.text = dataModel.secondLabelSetting
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

