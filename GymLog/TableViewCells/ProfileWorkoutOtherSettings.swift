//
//  ProfileWorkoutOtherSettings.swift
//  GymLog
//
//  Created by Kacper P on 19/06/2021.
//

import UIKit

class ProfileWorkoutOtherSettings: UITableViewCell {

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
        
        var vibrationON: Bool = false
        
        if sender.isOn == true {
            vibrationON = true
        } else {
            vibrationON = false
        }
        UserDefaults.standard.setValue(vibrationON, forKey: "vibrations")
    }
}
