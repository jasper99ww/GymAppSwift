//
//  BMIResultViewController.swift
//  GymLog
//
//  Created by Kacper P on 24/06/2021.
//

import UIKit

class BMIResultViewController: UIViewController {

    var bmiValue: String?
    var advice: String?
    var diagnosis: String?
    
    var color: UIColor?
    
    @IBOutlet weak var diagnosisLabel: UILabel!
    @IBOutlet weak var bmiValueLabel: UILabel!
    @IBOutlet weak var adviceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        diagnosisLabel.text = diagnosis
        bmiValueLabel.text = bmiValue
        adviceLabel.text = advice
    
        diagnosisLabel.textColor = color
        bmiValueLabel.textColor = color
        
    }

    @IBAction func recalculateButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
   
}
