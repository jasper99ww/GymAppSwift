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
    var age = 25
    var newAge = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    makeTintImages()
    buttonsCorneRadius()
        genderViewsButton()
        heightSlider.setValue(170, animated: true)
        weightSlider.setValue(80, animated: true)
    }
    
    func makeTintImages() {
        guard let manGenderImage = UIImage(named: "manGender") else { return }
        let tintManImage = manGenderImage.withRenderingMode(.alwaysTemplate)
        manGender.image = tintManImage
        manGender.tintColor = .green
        manGenderView.layer.cornerRadius = 15
        
        guard let womanGenderImage = UIImage(named: "womanGender") else { return }
        let tintWomanGender = womanGenderImage.withRenderingMode(.alwaysTemplate)
        womanGender.image = tintWomanGender
        womanGender.tintColor = .systemPink
        womanGenderView.layer.cornerRadius = 15
        
        heightView.layer.cornerRadius = 15
        weightView.layer.cornerRadius = 15
        ageView.layer.cornerRadius = 15
        activityView.layer.cornerRadius = 15
        
    }
    
    //MARK:- GENDER VIEWS
    
    func genderViewsButton() {
        manGenderView.isUserInteractionEnabled = true
        let maleButton = UITapGestureRecognizer(target: self, action: #selector(maleButtonTapped))
        manGenderView.addGestureRecognizer(maleButton)
        
        let femaleButton = UITapGestureRecognizer(target: self, action: #selector(femaleButtonTapped))
        womanGenderView.addGestureRecognizer(femaleButton)
    }
    
   @objc func maleButtonTapped() {
    manGender.alpha = 0.5
        gender = "male"
    print("man tapped ")
    }
    
    @objc func femaleButtonTapped() {
        gender = "female"
        womanGenderView.alpha = 0.5
        print("women tapped")
    }
    
    
    //MARK:- SLIDERS
    
    func cmToFootAndInches(_ cm: Double) -> String {
        
        let feet = cm * 0.0328084
        let feetFloor = Int(floor(feet))
        let feetRest: Double = ((feet * 100).truncatingRemainder(dividingBy: 100) / 100)
        let inches = Int(floor(feetRest * 12))
        
        return "\(feetFloor)' \(inches)\""
    }
    
    @IBAction func heightSliderChanged(_ sender: UISlider) {
        height = Int(sender.value)
        print("height is \(sender.value / 2.54)")
        let heightInInch = cmToFootAndInches(Double(sender.value))
        heightValueLabel.text = "\(String(height))cm (\(heightInInch))"
        
      
    }
    
    @IBAction func weightSliderChanged(_ sender: UISlider) {
        weight = Int(sender.value)
        weightValueLabel.text = "\(String(weight))\(weightUnit)"
    }
    
    @IBAction func minusButtonTapped(_ sender: UIButton) {
        guard age >= 1 else { return print("za maly wiek")}
        age -= 1
        newAge = String(age)
        ageTextField.text = newAge
    }
    
    @IBAction func plusButtonTapped(_ sender: UIButton) {
        guard age >= 1 else { return print("za maly wiek")}
        age += 1
        newAge = String(age)
        ageTextField.text = newAge
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
    
   


}
