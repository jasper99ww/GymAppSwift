//
//  BodyWeightTableViewCellChart.swift
//  GymLog
//
//  Created by Kacper P on 01/07/2021.
//

import UIKit

class BodyWeightTableViewCellChart: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weightValue: UILabel!
    @IBOutlet weak var weightProgress: UILabel!
    @IBOutlet weak var arrowProgress: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
