//
//  BodyWeightCalories.swift
//  GymLog
//
//  Created by Kacper P on 05/07/2021.
//

import UIKit

class BodyWeightCalories: UIViewController {

    
    
    @IBOutlet weak var heightView: UIView!
    @IBOutlet weak var heightSlider: UISlider!
    @IBOutlet weak var heightValueLabel: UILabel!
    
    
    @IBOutlet weak var weightView: UIView!
    @IBOutlet weak var weightSlider: UISlider!
    @IBOutlet weak var weightValueLabel: UILabel!
    var weightUnit: String {
        UserDefaults.standard.string(forKey: "unit") ?? "kg"
    }
    
    @IBOutlet weak var ageView: UIView!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var ageMinusButton: UIButton!
    @IBOutlet weak var agePlusButton: UIButton!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activityPicker: UIPickerView!
    
    @IBOutlet weak var manGenderView: UIView!
    @IBOutlet weak var manGender: UIImageView!
    
    
    @IBOutlet weak var womanGenderView: UIView!
    @IBOutlet weak var womanGender: UIImageView!
    let color = UIColor.init(red: 236/255, green: 240/255, blue: 241/255, alpha: 1)
    
    var gender = String()
    var height = Int()
    var weight = Int()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    makeTintImages()
    buttonsCorneRadius()
        
        heightSlider.setValue(170, animated: true)
        weightSlider.setValue(80, animated: true)
    }
    
    
    //MARK:- GENDER VIEWS
    
    func genderViewsButton() {
        let maleButton = UITapGestureRecognizer(target: self, action: #selector(maleButtonTapped))
        manGenderView.addGestureRecognizer(maleButton)
        
        let femaleButton = UITapGestureRecognizer(target: self, action: #selector(femaleButtonTapped))
        womanGenderView.addGestureRecognizer(femaleButton)
    }
    
   @objc func maleButtonTapped() {
        gender = "male"
    }
    
    @objc func femaleButtonTapped() {
        gender = "female"
    }
    
    
    //MARK:- SLIDERS
    
    @IBAction func heightSliderChanged(_ sender: UISlider) {
        height = Int(sender.value)
        var heightInInch = String(format: "%.2f", (sender.value / 0.39370))
        heightValueLabel.text = "\(String(height))cm (\(heightInInch)\"\")"
    }
    
    @IBAction func weightSliderChanged(_ sender: UISlider) {
        weight = Int(sender.value)
        weightValueLabel.text = "\(String(weight))\(weightUnit)"
    }
    

    //MARK:- UI SET UP
    func buttonsCorneRadius() {
        let greenColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
        
        ageMinusButton.layer.cornerRadius = ageMinusButton.frame.width / 2
        ageMinusButton.layer.masksToBounds = true
        ageMinusButton.layer.borderColor = greenColor
        ageMinusButton.layer.borderWidth = 1
        agePlusButton.layer.cornerRadius = agePlusButton.frame.width / 2
        agePlusButton.layer.masksToBounds = true
        agePlusButton.layer.borderColor = greenColor
        agePlusButton.layer.borderWidth = 1
    }
    
    func makeTintImages() {
        guard let manGenderImage = UIImage(named: "manGender") else { return }
        let tintManImage = manGenderImage.withRenderingMode(.alwaysTemplate)
        manGender.image = tintManImage
        manGender.tintColor = .darkGray
        manGenderView.layer.cornerRadius = 15
        
        guard let womanGenderImage = UIImage(named: "womanGender") else { return }
        let tintWomanGender = womanGenderImage.withRenderingMode(.alwaysTemplate)
        womanGender.image = tintWomanGender
        womanGender.tintColor = .darkGray
        womanGenderView.layer.cornerRadius = 15
        
        heightView.layer.cornerRadius = 15
        weightView.layer.cornerRadius = 15
        ageView.layer.cornerRadius = 15
        activityView.layer.cornerRadius = 15
        
    }


}
