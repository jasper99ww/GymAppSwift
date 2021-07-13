//
//  BMIViewController.swift
//  GymLog
//
//  Created by Kacper P on 24/06/2021.
//

import UIKit

class BMIViewController: UIViewController {

    var bmiCalculator = BmiCalculator()
    
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var heightSlider: UISlider!
    
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var weightSlider: UISlider!
  
    @IBOutlet weak var calculateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        heightSlider.value = 1.5
        weightSlider.value = 80
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
        
        bmiCalculator.calculateBmi(height: height, weight: weight)
        self.performSegue(withIdentifier: "toCalculatedBMI", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toCalculatedBMI" {
            let destinationViewController = segue.destination as! BMIResultViewController
            destinationViewController.bmiValue = bmiCalculator.getBMIValue()
            destinationViewController.advice = bmiCalculator.getAdvice()
            destinationViewController.diagnosis = bmiCalculator.getDiagnosis()
            destinationViewController.color = bmiCalculator.getColor()
            
        }
    }
}
