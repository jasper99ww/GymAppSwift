//
//  ProfileTableViewCell.swift
//  GymLog
//
//  Created by Kacper P on 24/06/2021.
//

import UIKit



class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var segueButton: UIButton!
    
    let accesoryImage = UIImageView(image: UIImage(systemName: "chevron.right"))
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
