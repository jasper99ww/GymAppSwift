//
//  BodyWeightTableViewCell.swift
//  GymLog
//
//  Created by Kacper P on 24/06/2021.
//

import UIKit


class BodyWeightTableViewCell: UITableViewCell {

    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    let accesoryImage = UIImageView(image: UIImage(systemName: "chevron.right"))

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func cellConfigure(item: BodyWeightModel) {
        mainLabel.text = item.mainLabel
        secondLabel.text = item.secondLabel
        self.accessoryView = accesoryImage
    }
}
