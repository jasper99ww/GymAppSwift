//
//  BodyWeightTableViewCell.swift
//  GymLog
//
//  Created by Kacper P on 24/06/2021.
//

import UIKit


class BodyWeightTableViewCell: UITableViewCell {

    weak var delegate: TitleOfSelectedRow?
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func bodyWeightTableViewTapped(_ sender: UIButton) {
        delegate?.didTapButton(with: mainLabel.text ?? "Error")
    }
    
}
