//
//  BMIResultViewController.swift
//  GymLog
//
//  Created by Kacper P on 24/06/2021.
//

import UIKit

class BMIResultViewController: UIViewController {

    var bmiValueResult: String?
    var diagnosisText: String?
    var resultDescriptionValue: String?
    
    var color: UIColor?
    
    @IBOutlet weak var resultDescription: UILabel!
    @IBOutlet weak var diagnosis: UILabel!
    
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var recalculateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        result.text = bmiValueResult
        diagnosis.text = diagnosisText
        resultDescription.text = resultDescriptionValue
        resultDescription.textColor = color
        result.textColor = color
        print("result is \(bmiValueResult)")
    }

    @IBAction func recalculateButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
