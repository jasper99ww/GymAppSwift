//
//  BMIResultViewController.swift
//  GymLog
//
//  Created by Kacper P on 24/06/2021.
//

import UIKit

class BMIResultViewController: UIViewController {
  
    lazy var bmiResultPresenter = BmiResultPresenter(bmi: BMIModel())
    
    @IBOutlet weak var diagnosisLabel: UILabel!
    @IBOutlet weak var bmiValueLabel: UILabel!
    @IBOutlet weak var adviceLabel: UILabel!
    var color: UIColor?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bmiResultPresenter.setViewDelegate(bmiResultPresenterDelegate: self)
        bmiResultPresenter.getModel()
    }

    @IBAction func recalculateButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
    extension BMIResultViewController: BmiResultPresenterDelegate {
        
    func setBmiValue(value: String) {
        bmiValueLabel.text = value
    }
    
    func setBmiAdvice(advice: String) {
        adviceLabel.text = advice
    }
    
    func setBmiDiagnosis(diagnosis: String) {
        diagnosisLabel.text = diagnosis
    }
    
    func setColor(color: UIColor) {
        diagnosisLabel.textColor = color
        bmiValueLabel.textColor = color
    }
}
