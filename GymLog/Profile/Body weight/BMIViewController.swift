//
//  BMIViewController.swift
//  GymLog
//
//  Created by Kacper P on 24/06/2021.
//

import UIKit

class BMIViewController: UIViewController {

    var bmiValue = "0.0"
    
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    @IBOutlet weak var heightSlider: UISlider!
    @IBOutlet weak var weightSlider: UISlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func heightSliderChanged(_ sender: UISlider) {
        
        let height = String(format: "%.2f", sender.value)
        heightLabel.text = "\(height)m"
    }
    
    @IBAction func weightSliderChanged(_ sender: UISlider) {
        
        let weight = String(format: "%.0f", sender.value)
        weightLabel.text = "\(weight)kg"
    }
    
    @IBAction func calculateButtonTapped(_ sender: UIButton) {
        let height = heightSlider.value
        let weight = weightSlider.value
        
        let bmi = weight / pow(height, 2)
      bmiValue = String(format: "%.1f", bmi)
       
        
        self.performSegue(withIdentifier: "toCalculatedBMI", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCalculatedBMI" {
            let destinationVC = segue.destination as! BMIResultViewController
            destinationVC.bmiValue = bmiValue
            
            if let bmi = Double(bmiValue) {
            if bmi < 18.5 {
                destinationVC.diagnosisText = "Underweight, you should eat more calories"
            } else if bmi < 24.9
                {
                destinationVC.diagnosisText = "Your weight is great! Keep it up!"
            } else {
                destinationVC.diagnosisText = "Overweight, you should eat less calories"
            }
        }
        }
    }
}
