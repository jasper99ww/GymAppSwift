//
//  AddWorkoutCell.swift
//  GymLog
//
//  Created by Barbara Podgórska on 27/02/2021.
//

import UIKit

class AddWorkoutCell: UITableViewCell {

    
    @IBOutlet weak var view: UIView!
    
    
    @IBOutlet weak var Number: UITextField!
    
    @IBOutlet weak var Exercise: UITextField!
    
    @IBOutlet weak var kg: UITextField!
    
    @IBOutlet weak var Sets: UITextField!
    
    @IBOutlet weak var Reps: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
      setUpElements()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpElements() {
        
        UnderlinedTextField.awakeFromNib()
    }
}
