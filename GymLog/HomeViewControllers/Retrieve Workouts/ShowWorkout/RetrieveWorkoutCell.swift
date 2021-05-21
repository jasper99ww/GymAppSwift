//
//  RetrieveWorkoutCell.swift
//  GymLog
//
//  Created by Barbara Podgórska on 13/03/2021.
//

import UIKit

class RetrieveWorkoutCell: UITableViewCell {
    
    @IBOutlet weak var view: RetrieveWorkoutCell!
    
    
    @IBOutlet weak var retrievedNumber: UILabel!
    @IBOutlet weak var retrievedExercise: UILabel!
    @IBOutlet weak var retrievedKG: UILabel!
    @IBOutlet weak var retrievedSets: UILabel!
    @IBOutlet weak var retrievedReps: UILabel!
    //    @IBOutlet weak var retrievedNumber: UILabel!
//    @IBOutlet weak var retrievedNumber: UITextField!
//    @IBOutlet weak var retrievedExercise: UITextField!
//    @IBOutlet weak var retrievedKG: UITextField!
//    @IBOutlet weak var retrievedSets: UITextField!
//    @IBOutlet weak var retrievedReps: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        retrievedNumber?.setRoundEdge()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//      
//        if(selected) {
//            view.backgroundColor = UIColor.red
//        }
        
    }
    
//    func animate() {
//        UIView.animate(withDuration: 0.5, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseIn, animations: () -> Void)
//           
//        
//      
//    }
    
   
    }
 

extension UILabel {
    
    func setRoundEdge() {
    let myColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
       
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = self.frame.size.width/2
        
        self.layer.borderColor = myColor
        self.textColor = UIColor.white
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
}
