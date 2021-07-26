//
//  AccountTableViewCell.swift
//  GymLog
//
//  Created by Kacper P on 15/06/2021.
//

import UIKit

class AccountTableViewCell: UITableViewCell {
    static let identifier = "accountCell"
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var editImage: UIButton!
    
    let accessoryImage = UIImageView(image: UIImage(systemName: "pencil", withConfiguration: UIImage.SymbolConfiguration(scale: .large)))
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureWithItem(item: AccountModelData) {
        mainLabel.text = item.mainLabel
        secondLabel.text = item.secondLabel
        self.accessoryView = accessoryImage
    }
    
    func hideEditImage(indexPath: IndexPath) {
        if indexPath.row == 2 {
            self.accessoryView?.isHidden = true
        }
    }
}
