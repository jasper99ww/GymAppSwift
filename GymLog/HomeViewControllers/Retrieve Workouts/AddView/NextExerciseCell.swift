//
//  NextExerciseCell.swift
//  GymLog
//
//  Created by Barbara Podgórska on 28/03/2021.
//

import UIKit

protocol NextExerciseCellDelegate {
    func saveNewFields(indexPath: IndexPath)
    
}

class NextExerciseCell: UITableViewCell {
    
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var view: NextExerciseCell!
    @IBOutlet weak var newNumber: UILabel!
    @IBOutlet weak var newExercise: UITextField!
    @IBOutlet weak var newKG: UITextField!
    @IBOutlet weak var newSets: UITextField!
    @IBOutlet weak var newReps: UITextField!
    
 
    var cellDelegate: NextExerciseCellDelegate?
    var index: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        newNumber?.setRoundEdge()
        placeholdersColors()
        checkBoxButton.isHidden = true
  
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

     
    }
    
    @IBAction func checkBoxButtonTapped(_ sender: UIButton) {
        if newExercise.text!.isEmpty {
            print("PUSTA NAZWA")
        } else {
        cellDelegate?.saveNewFields(indexPath: index!)
        checkBoxButton.isHidden = true
        
    }
    }
    
    func changeColors(at indexPath: IndexPath) {
        newNumber.isUserInteractionEnabled = true
        newExercise.isUserInteractionEnabled = true
        newKG.isUserInteractionEnabled = true
        newSets.isUserInteractionEnabled = true
        newReps.isUserInteractionEnabled = true
    
    }

    func placeholdersColors() {
        
        let color = UIColor.lightGray.withAlphaComponent(0.1)
        newExercise.attributedPlaceholder = NSAttributedString(string: "Exercise", attributes: [NSAttributedString.Key.foregroundColor: color])
        newKG.attributedPlaceholder = NSAttributedString(string: "#", attributes: [NSAttributedString.Key.foregroundColor: color])
        newSets.attributedPlaceholder = NSAttributedString(string: "#", attributes: [NSAttributedString.Key.foregroundColor: color])
        newReps.attributedPlaceholder = NSAttributedString(string: "Exercise", attributes: [NSAttributedString.Key.foregroundColor: color])
     
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        switch textField {
        case newExercise:
            newExercise.placeholder = ""
        case newKG:
            newKG.placeholder = ""
        case newSets:
            newSets.placeholder = ""
        case newReps:
            newReps.placeholder = ""
        
        default:
            "#"
        }
        
    }
    
}

extension NextExerciseCell: UITextFieldDelegate {
    

   
}
