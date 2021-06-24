//
//  BMIResultViewController.swift
//  GymLog
//
//  Created by Kacper P on 24/06/2021.
//

import UIKit

class BMIResultViewController: UIViewController {

    var bmiValue: String?
    var diagnosisText: String?
    
    @IBOutlet weak var diagnosis: UILabel!
    
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var recalculateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        result.text = bmiValue
        diagnosis.text = diagnosisText
    }

    @IBAction func recalculateButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
