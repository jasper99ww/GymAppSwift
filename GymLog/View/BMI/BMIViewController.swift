//
//  BMIViewController.swift
//  GymLog
//
//  Created by Kacper P on 24/06/2021.
//

import UIKit

class BMIViewController: UIViewController {
    
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var heightSlider: UISlider!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var weightSlider: UISlider!
    @IBOutlet weak var calculateButton: UIButton!
    
    
    lazy var presenter = BmiPresenter(bmiModel: BMIModel())
    
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
        presenter.getChosenBmiParameteres(height: height, weight: weight)
        
        self.performSegue(withIdentifier: "toCalculatedBMI", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == "toCalculatedBMI" {
            let destinationViewController = segue.destination as! BMIResultViewController
            destinationViewController.bmiResultPresenter = BmiResultPresenter(bmi: self.presenter.bmiModel)
        }
    }
}
