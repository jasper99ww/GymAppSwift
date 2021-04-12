//
//  EditWorkoutCell.swift
//  GymLog
//
//  Created by Barbara Podgórska on 24/03/2021.
//

import UIKit

protocol EditWorkoutCellDelegate {
    func saveNewFields(indexPath: IndexPath)
    
}


class EditWorkoutCell: UITableViewCell, UITextFieldDelegate {
    
    var cellDelegate: EditWorkoutCellDelegate?
    var index: IndexPath?
    
    
    @IBOutlet weak var view: EditWorkoutCell!
    @IBOutlet weak var retrievedNumber: UILabel!
    @IBOutlet weak var editableExercise: UITextField!
    @IBOutlet weak var editableKG: UITextField!
    @IBOutlet weak var editableSets: UITextField!
    @IBOutlet weak var editableReps: UITextField!
    
    
    @IBOutlet weak var checkBox: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        retrievedNumber?.setRoundEdge()
        checkBox?.isHidden = true
     
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func checkBoxTapped(_ sender: Any) {
        cellDelegate?.saveNewFields(indexPath: index!)
        checkBox.isHidden = true
            editableExercise.isUserInteractionEnabled = false
               editableExercise.alpha = 1
                
                editableKG.isUserInteractionEnabled = false
                editableKG.alpha = 1
                
                editableSets.isUserInteractionEnabled = false
                editableSets.alpha = 1
                
                editableReps.isUserInteractionEnabled = false
                editableReps.alpha = 1
        
        editableKG.becomeFirstResponder()
        
    }
    

    
    
}

 

