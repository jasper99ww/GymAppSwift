//
//  CalendarTableViewCell.swift
//  GymLog
//
//  Created by Kacper Podgórski on 01/05/2021.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {

    @IBOutlet weak var workoutCellLabel: UILabel!
    @IBOutlet weak var cellHourOfDoneTraining: UILabel!
    @IBOutlet weak var exercisesInWorkout: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }

}
