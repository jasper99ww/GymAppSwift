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

}
