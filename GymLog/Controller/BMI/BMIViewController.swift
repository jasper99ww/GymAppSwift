//
//  BMIViewController.swift
//  GymLog
//
//  Created by Kacper P on 24/06/2021.
//

import UIKit

protocol BmiViewControllerSegueData: class {
    func prepareBmiDataForSegue(bmiData: BMI)
}

class BMIViewController: UIViewController {
    
    var bmiViewModel = BmiViewModel()

    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var heightSlider: UISlider!
    
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var weightSlider: UISlider!
  
    @IBOutlet weak var calculateButton: UIButton!
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bmiViewModel.delegateVC = self
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
        bmiViewModel.sendValue(height: height, weight: weight)
//        self.performSegue(withIdentifier: "toCalculatedBMI", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    
        if segue.identifier == "toCalculatedBMI" {
            let destinationViewController = segue.destination as! BMIResultViewController
            
//            destinationViewController.bmiValue = bmiCalcualtor.getBMIValue()
//            print("value \(bmiCalcualtor.getBMIValue())")
//            destinationViewController.advice = bmiCalculator.getAdvice()
//            destinationViewController.diagnosis = bmiCalculator.getDiagnosis()
//            destinationViewController.color = bmiCalculator.getColor()
            
        }
    }
}

extension BMIViewController: BmiViewControllerDelegate {
    func getCalculatedBMI(newBmi: BMI) {
        print("value \(newBmi.value)")
        let bmiResult = BMIResultViewController()
        bmiResult.bmiValue = String(newBmi.value)
        bmiResult.advice = newBmi.advice
        bmiResult.diagnosis = newBmi.diagnosis
        bmiResult.color = newBmi.color
    }
    
//    func getCalculatedBMI(handledHeight: Float?, handledWeight: Float?, advice: String) {
//        print("height BOOOOOM \(handledHeight), weight \(handledWeight), advice \(advice)")
//    }
}

//
//class BMIViewController: UIViewController {
//
//    var bmiCalculator = BmiCalculator()
//
//    @IBOutlet weak var heightLabel: UILabel!
//    @IBOutlet weak var heightSlider: UISlider!
//
//    @IBOutlet weak var weightLabel: UILabel!
//    @IBOutlet weak var weightSlider: UISlider!
//
//    @IBOutlet weak var calculateButton: UIButton!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        heightSlider.value = 1.5
//        weightSlider.value = 80
//    }
//
//    @IBAction func heightSliderChanged(_ sender: UISlider) {
//
//        let height = String(format: "%.2f", sender.value)
//        heightLabel.text = "\(height)m"
//    }
//
//    @IBAction func weightSliderChanged(_ sender: UISlider) {
//
//        let weight = String(format: "%.0f", sender.value)
//        weightLabel.text = "\(weight)kg"
//    }
//
//    @IBAction func calculateButtonTapped(_ sender: UIButton) {
//        let height = heightSlider.value
//        let weight = weightSlider.value
//
//        bmiCalculator.calculateBmi(height: height, weight: weight)
//        self.performSegue(withIdentifier: "toCalculatedBMI", sender: self)
//    }
//
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if segue.identifier == "toCalculatedBMI" {
//            let destinationViewController = segue.destination as! BMIResultViewController
//            destinationViewController.bmiValue = bmiCalculator.getBMIValue()
//            destinationViewController.advice = bmiCalculator.getAdvice()
//            destinationViewController.diagnosis = bmiCalculator.getDiagnosis()
//            destinationViewController.color = bmiCalculator.getColor()
//
//        }
//    }
//}
