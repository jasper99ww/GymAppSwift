//
//  ProfileWorkoutTableViewCell.swift
//  GymLog
//
//  Created by Kacper P on 18/06/2021.
//

import UIKit

class ProfileWorkoutTableViewCell: UITableViewCell {

    let notificationClass = NotificationNamesClass()
    let unitClass = UnitClass()
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        segmentedControlTitle()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func segmentedControlTitle() {
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
    }

    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            // KG UNIT SELECTED
            NotificationCenter.default.post(name: NotificationNamesClass.nameKG, object: nil)
            unitClass.changeUnitFromLBtoKGInCalendar()
            unitClass.changeUnitFromLBtoKGInHistory()
            
        } else {
            // LB UNIT SELECTED
            NotificationCenter.default.post(name: NotificationNamesClass.nameLB, object: nil)
            unitClass.changeUnitFromKGtoLBInCalendar()
            unitClass.changeUnitFromKGtoLBInHistory()
        }
    }
}
