//
//  ProfileTableViewCell.swift
//  GymLog
//
//  Created by Kacper P on 24/06/2021.
//

import UIKit

protocol TitleOfSelectedRow: AnyObject {
    func didTapButton(with title: String)
}

class ProfileTableViewCell: UITableViewCell {

    weak var delegate: TitleOfSelectedRow?
   
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var segueButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func segueButton(_ sender: UIButton) {
        delegate?.didTapButton(with: label.text ?? "Error")
    }
    
}
