//
//  ProfileWorkoutTableViewCell.swift
//  GymLog
//
//  Created by Kacper P on 18/06/2021.
//

import UIKit

class ProfileWorkoutTableViewCell: UITableViewCell {

    let notificationClass = NotificationNamesClass()
    let unitClass = WorkoutSettingsService()
    let workoutPresenter = WorkoutPresenter(workoutmodel: WorkoutModel(), workoutPresenterDelegateForView: ProfileWorkoutViewController(), workoutPresenterControllersState: ProfileWorkoutViewController())
    
    @IBOutlet weak var mainLabel:  UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        segmentedControlTitle()

    }
    
    func alertBeforeChangeUnit() {
//        Alert.showBasicAlert(on: ProfileWorkoutViewController(), with: "WARNING", message: "You are able to change units on your account only once. Make sure that you really need it!", handler: nil)
        
    }
    
    @IBAction func segmentedControlChange(_ sender: UISegmentedControl) {
        
        switch sender.tag {
        case 0:
            if sender.selectedSegmentIndex == 0 {
                let name = Notification.Name(rawValue: "segmentedControlUnitSelected")
                NotificationCenter.default.post(name: name, object: nil)
                segmentedControl.setEnabled(false, forSegmentAt: 0)
                segmentedControl.setEnabled(false, forSegmentAt: 1)
//                alertBeforeChangeUnit()
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
                workoutPresenter.setPlaceholderValueInTraining(value: false)
            } else {
                workoutPresenter.setPlaceholderValueInTraining(value: true)
            }
        default:
        break
            }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)        
    }
    
    func segmentedControlTitle() {
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
    }
    
    func configureWithItem(item: WorkoutSettingsDataModel) {
        mainLabel.text = item.mainLabelSetting
        secondLabel.text = item.secondLabelSetting
        segmentedControl.setTitle(item.segmentedControlFirstSegmentTitle, forSegmentAt: 0)
        segmentedControl.setTitle(item.segmentedControlSecondSegmentTitle, forSegmentAt: 1)
    }
    
    func selectSegmentState(index: Int, controllerItem: WorkoutControllersModel) {
      
        switch index {
        case 0:
            segmentedControl.selectedSegmentIndex = controllerItem.unitSegmentedController
        case 1:
            segmentedControl.selectedSegmentIndex = controllerItem.placeholderValueSegmentedController
        default:
            segmentedControl.selectedSegmentIndex = 0
        }
        }
    }
