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
    static let identifier = "accountCell"
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var editImage: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configureWithItem(item: AccountModelData) {
        mainLabel.text = item.mainLabel
        secondLabel.text = item.secondLabel
    }
    
    func hideEditImage(indexPath: IndexPath) {
        if indexPath.row == 2 {
            editImage.isHidden = true
        }
    }

    @IBAction func editImageTapped(_ sender: UIButton) {
        delegate?.didTapButton(with: mainLabel.text!, with: secondLabel.text!)
    }
    
  
    
}
