//
//  AccountTableViewCell.swift
//  GymLog
//
//  Created by Kacper P on 15/06/2021.
//

import UIKit

protocol AccountTableViewCellDelegate: AnyObject {
    func didTapButton(with title: String, with value: String)
}

class AccountTableViewCell: UITableViewCell {

    weak var delegate: AccountTableViewCellDelegate?
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var editImage: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    @IBAction func editImageTapped(_ sender: UIButton) {
        delegate?.didTapButton(with: mainLabel.text!, with: secondLabel.text!)
    }
    
}
