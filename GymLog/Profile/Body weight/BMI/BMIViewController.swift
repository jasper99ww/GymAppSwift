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
    
    @IBOutlet weak var calculateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heightSlider.setValue(1.5, animated: true)
        weightSlider.setValue(80, animated: true)
        calculateButton.layer.cornerRadius = 15
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
            destinationVC.bmiValueResult = bmiValue

            if let bmi = Double(bmiValue) {
            if bmi < 18.5 {
                destinationVC.diagnosisText = "You should eat more calories"
                destinationVC.resultDescriptionValue = "Underweight"
//                destinationVC.resultDescription.textColor = .red
                destinationVC.color = .red
            } else if bmi < 24.9
                {
                destinationVC.diagnosisText = "Your weight is great! Keep it up!"
                destinationVC.resultDescriptionValue = ""
//                destinationVC.resultDescription.textColor = .green
                destinationVC.color = .green
            } else {
                destinationVC.diagnosisText = "You should eat less calories"
                destinationVC.resultDescriptionValue = "Overweight"
                destinationVC.color = .red
               
            }
        }
        }
    }
}
