//
//  ProfileWorkoutTableViewCell.swift
//  GymLog
//
//  Created by Kacper P on 18/06/2021.
//

import UIKit

class ProfileWorkoutTableViewCell: UITableViewCell {

    let workoutPresenter = WorkoutPresenter(workoutmodel: WorkoutModel(), workoutPresenterDelegateForView: ProfileWorkoutViewController(), workoutPresenterControllersState: ProfileWorkoutViewController())
    
    var parentVC: UIViewController?
    
    @IBOutlet weak var mainLabel:  UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var lastSelectedIndex: Int {
        return workoutPresenter.getSelectedUnit()
    }
    
    var limitChangeExhausted: Bool {
        return workoutPresenter.checkLimitChanges()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        segmentedControlTitle()

    }
    
    func setNotification() {
        // CHECK IF USER HAS GOT A POSSIBILITY OF CHANGE UNIT
       let newSelectedIndex = segmentedControl.selectedSegmentIndex

        if limitChangeExhausted == true {
            //Don't change selected segment index
            segmentedControl.selectedSegmentIndex = lastSelectedIndex
            
            Alert.showBasicAlert(on: parentVC!, with: "Limit exhausted", message: "Your limit changing unit is exhausted.", handler: nil)
           
        } else {
            //Don't change selected segment index until alert is not accepted
            segmentedControl.selectedSegmentIndex = lastSelectedIndex
            
            Alert.showAlertBeforeChange(on: parentVC!, with: "Alert", message: "You can change your unit only once. Are you sure you wanna do this?") { [weak self] action in
                
                guard let self = self else { return }
                
                //Changing segment index to selected index
                self.segmentedControl.selectedSegmentIndex = newSelectedIndex
                self.workoutPresenter.updateChangesLimitSegmentedControl(limitExhausted: true)
                
                if self.segmentedControl.selectedSegmentIndex == 0 {
                    self.workoutPresenterUnitKgFunctions()
                } else {
                    self.workoutPresenterUnitLbFunctions()
                }
            }
        }
    }
    
    func workoutPresenterUnitKgFunctions() {
        workoutPresenter.saveSelectedUnitInMemory(unit: "kg")
        workoutPresenter.changeUnitFromLBtoKGInCalendar()
        workoutPresenter.changeUnitFromLBtoKGInHistory()
    }
    
    func workoutPresenterUnitLbFunctions() {
        workoutPresenter.saveSelectedUnitInMemory(unit: "lb")
        workoutPresenter.changeUnitFromKGtoLBInCalendar()
        workoutPresenter.changeUnitFromKGtoLBInHistory()
    }
    
    @IBAction func segmentedControlChange(_ sender: UISegmentedControl) {
        
        switch sender.tag {
        case 0:
            setNotification()
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
