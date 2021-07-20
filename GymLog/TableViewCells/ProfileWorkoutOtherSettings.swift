//
//  ProfileWorkoutOtherSettings.swift
//  GymLog
//
//  Created by Kacper P on 19/06/2021.
//

import UIKit

class ProfileWorkoutOtherSettings: UITableViewCell {
    
    let presenter = WorkoutPresenter(workoutmodel: WorkoutModel(), workoutPresenterDelegateForView: ProfileWorkoutViewController(), workoutPresenterControllersState: ProfileWorkoutViewController())

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var switcher: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        
        if sender.isOn == true {
            presenter.saveSwitchState(state: true)
        } else {
            presenter.saveSwitchState(state: false)
        }
    }
    
    func configureCell(item: WorkoutSettingsDataModel) {
        mainLabel.text = item.mainLabelSetting
        secondLabel.text = item.secondLabelSetting
    }
    
    func getSwitchState(index: Int, controllerItem: WorkoutControllersModel) {
        switcher.isOn = controllerItem.vibrationSwitcherController
    }
}
