//
//  WorkoutTableCell.swift
//  GymLog
//
//  Created by Barbara Podgórska on 09/03/2021.
//

import UIKit
import Firebase

protocol WorkoutTableCellDelegate {
    func onClickCell(index: Int)
}

class WorkoutTableCell: UITableViewCell {
    
    
    var cellDelegate:WorkoutTableCellDelegate?
    var index: IndexPath?
    var item = AllWorkoutsViewController().navigationItem.title
    
    
    @IBOutlet weak var workoutField: UIButton!
    
    let user = Auth.auth().currentUser
    
    let db = Firestore.firestore()
    
    var models: [DataCell] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpButtons()
        contentView.backgroundColor = UIColor.init(red: 18/255, green: 18/255, blue: 18/255, alpha: 1)
    }


    @IBAction func buttonTapped(_ sender: Any) {
        cellDelegate?.onClickCell(index: (index?.row)!)

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    
    }
    
    
    func setUpButtons() {
        workoutField.backgroundColor = UIColor.init(red: 24/255, green: 24/255, blue: 24/255, alpha: 1)
        workoutField.layer.cornerRadius = workoutField.frame.height / 5
     
        workoutField.layer.shadowColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 0.5).cgColor
        workoutField.layer.shadowRadius = 3
        workoutField.layer.shadowOpacity = 0.5
        workoutField.layer.shadowOffset = CGSize(width: 0, height: 0)
        workoutField.layer.borderWidth = 1
        workoutField.layer.borderColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 0.5).cgColor
        
    }
    
}
