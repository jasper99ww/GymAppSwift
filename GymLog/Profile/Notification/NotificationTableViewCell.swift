//
//  NotificationTableViewCell.swift
//  GymLog
//
//  Created by Kacper P on 09/07/2021.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var notificationMainLabel: UILabel!
    @IBOutlet weak var notificationSecondLabel: UILabel!
    
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
