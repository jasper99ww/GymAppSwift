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
    private var statesOfControllers = WorkoutControllersModel() {
        didSet {
            print("USTAWIONO")
//            tableView.reloadData()
        }
    }
    
    var segmentedControlSelectedIndex: Int = 0
  
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        workoutPresenter.getControllersStates()
        workoutPresenter.getModel()
        tableView.register(UINib(nibName: "ProfileWorkoutOtherSettings", bundle: nil), forCellReuseIdentifier: "workoutOtherSettings")
        tableView.dataSource = self
        tableView.delegate = self
        createObserver()
    }
    
    func createObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(alertBeforeChangeUnit), name: NSNotification.Name(rawValue: "segmentedControlUnitSelected"), object: nil)
    }
 
     @objc func alertBeforeChangeUnit() {
        Alert.showBasicAlert(on: self, with: "WARNING", message: "You are able to change units on your account only once. Make sure that you really need it!", handler: nil)
        
    }
    
//    @IBAction func segmentedControlChange(_ sender: UISegmentedControl) {
//        
//        switch sender.tag {
//        case 0:
//            if sender.selectedSegmentIndex == 0 {
//                workoutPresenter.saveSelectedUnitInMemory(unit: "kg")
//                workoutPresenter.changeUnitFromLBtoKGInCalendar()
//                workoutPresenter.changeUnitFromLBtoKGInHistory()
//                
//            } else {
//                workoutPresenter.saveSelectedUnitInMemory(unit: "lb")
//                workoutPresenter.changeUnitFromKGtoLBInCalendar()
//                workoutPresenter.changeUnitFromKGtoLBInHistory()
//            }
//        case 1:
//            if sender.selectedSegmentIndex == 0 {
//                workoutPresenter.setPlaceholderValueInTraining(value: false)
//            } else {
//                workoutPresenter.setPlaceholderValueInTraining(value: true)
//            }
//        default:
//        break
//            }
//    }
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

