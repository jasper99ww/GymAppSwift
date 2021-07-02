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

        let color = contentView.backgroundColor
        let selectedColor = color?.withAlphaComponent(0.8)
        let colorX = UIColor.init(red: 20/255, green: 20/255, blue: 20/255, alpha: 1)
        
        if selected {
            self.contentView.backgroundColor = colorX
        } else {
            self.contentView.backgroundColor = .clear
        }
        
//        let bgColorView = UIView()
//        bgColorView.backgroundColor = .red
//        self.selectedBackgroundView = bgColorView
        
    }

}
