//
//  StartViewCell.swift
//  GymLog
//
//  Created by Barbara Podgórska on 05/04/2021.
//

import UIKit

protocol StartViewCellDelegate {
    func tappedButton(indexPath: IndexPath)
}

class StartViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var stackView: UIStackView!
    var cellDelegate: StartViewCellDelegate?
    var index: IndexPath?
    let startViewController = StartViewController()
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var setField: UITextField!
    
    @IBOutlet weak var setKg: UITextField!
    
    @IBOutlet weak var setReps: UITextField!

    @IBOutlet weak var checkmarkButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        setField.setPlaceHolderColor()
        setKg.setPlaceHolderColor()
        setReps.setPlaceHolderColor()
        disableInteraction()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            view.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 0.1)
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
            enableInteraction()
        } else {
            view.backgroundColor = contentView.backgroundColor
            view.layer.borderWidth = 0
            disableInteraction()
        }
        
    }
    
    func disableInteraction() {
        setField.isUserInteractionEnabled = false
        setReps.isUserInteractionEnabled = false
        setKg.isUserInteractionEnabled = false
    }
    
    func enableInteraction() {
        setField.isUserInteractionEnabled = true
        setReps.isUserInteractionEnabled = true
        setKg.isUserInteractionEnabled = true
    }

 
    @IBAction func checkmarkButtonTapped(_ sender: UIButton) {
        cellDelegate?.tappedButton(indexPath: index!)
        if let set = setField.text, let kg = setKg.text, let reps = setReps.text, !set.isEmpty, !kg.isEmpty, !reps.isEmpty  {
        if sender.isSelected {
            checkmarkButton.isSelected = false
        }
        else {
            sender.isSelected = true
        }
            
}
}
}

extension UITextField {
    
    func setPlaceHolderColor() {
        
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        
    }
    
    
}
    

