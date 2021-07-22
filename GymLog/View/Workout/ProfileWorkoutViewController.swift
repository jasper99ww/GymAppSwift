//
//  ProfileWorkoutViewController.swift
//  GymLog
//
//  Created by Kacper P on 18/06/2021.
//

import UIKit

class ProfileWorkoutViewController: UIViewController {
    
    lazy var workoutPresenter = WorkoutPresenter(workoutmodel: WorkoutModel(), workoutPresenterDelegateForView: self, workoutPresenterControllersState: self)
    
    @IBOutlet weak var tableView: UITableView!
    var savedSegmentState: Int = 0
    
    private var arrayOfSettings = [WorkoutSettingsDataModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    private var statesOfControllers = WorkoutControllersModel()

    var segmentedControlSelectedIndex: Int = 0
  
    override func viewDidLoad() {
        super.viewDidLoad()
        workoutPresenter.getControllersStates()
        workoutPresenter.getModel()
        tableView.register(UINib(nibName: "ProfileWorkoutOtherSettings", bundle: nil), forCellReuseIdentifier: "workoutOtherSettings")
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension ProfileWorkoutViewController: WorkoutPresenterControllersState {
    func getControllersStates(workoutControllersModel: WorkoutControllersModel) {
        statesOfControllers = workoutControllersModel
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
        
        if indexPath.row < 2 {
            
        let cellWithSegmentedControllers = self.tableView.dequeueReusableCell(withIdentifier: "workoutSettings", for: indexPath) as! ProfileWorkoutTableViewCell
                       
            cellWithSegmentedControllers.configureWithItem(item: arrayOfSettings[indexPath.row])
            cellWithSegmentedControllers.selectSegmentState(index: indexPath.row, controllerItem: statesOfControllers)
            cellWithSegmentedControllers.segmentedControl.tag = indexPath.row
            cellWithSegmentedControllers.parentVC = self
            return cellWithSegmentedControllers
        }
        else {
            
        let cellWithUISwitch = self.tableView.dequeueReusableCell(withIdentifier: "workoutOtherSettings", for: indexPath) as! ProfileWorkoutOtherSettings
        cellWithUISwitch.configureCell(item: arrayOfSettings[indexPath.row])
        cellWithUISwitch.getSwitchState(index: indexPath.row, controllerItem: statesOfControllers)
        return cellWithUISwitch
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

