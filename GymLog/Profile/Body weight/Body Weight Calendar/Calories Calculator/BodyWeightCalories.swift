//
//  BodyWeightCalories.swift
//  GymLog
//
//  Created by Kacper P on 05/07/2021.
//

import UIKit

class BodyWeightCalories: UIViewController {
    
    lazy var presenter = BodyWeightCaloriesPresenter()
  
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var activityButton: UIButton!
    
    @IBOutlet weak var heightView: UIView!
    @IBOutlet weak var heightSlider: UISlider!
    @IBOutlet weak var heightValueLabel: UILabel!
    
    @IBOutlet weak var weightView: UIView!
    @IBOutlet weak var weightSlider: UISlider!
    @IBOutlet weak var weightValueLabel: UILabel!
    
    @IBOutlet weak var ageView: UIView!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var ageMinusButton: UIButton!
    @IBOutlet weak var agePlusButton: UIButton!
    @IBOutlet weak var activityView: UIView!
   
    @IBOutlet weak var manGenderView: UIView!
    @IBOutlet weak var manGender: UIImageView!
    @IBOutlet weak var maleLabel: UILabel!
    
    @IBOutlet weak var womanGenderView: UIView!
    @IBOutlet weak var womanGender: UIImageView!
    @IBOutlet weak var femaleLabel: UILabel!

    var weightUnit: String {
        UserDefaults.standard.string(forKey: "unit") ?? "kg"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    presenter.bodyWeightCaloriesPresenterDelegate = self
    makeTintImages()
    buttonsCornerRadius()
    genderViewsButton()
    heightSlider.setValue(100, animated: true)
    weightSlider.setValue(80, animated: true)
        
    }
    
    
    //MARK:- PICKER VIEW
    
    @IBAction func activityButtonTapped(_ sender: UIButton) {
        
        let caloriesPickerController = CaloriesPickerController()
        caloriesPickerController.caloriesPickerDelegate = self
        caloriesPickerController.modalPresentationStyle = .overCurrentContext
        present(caloriesPickerController, animated: true, completion: nil)
        
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
    presenter.gender = "male"

    manGenderView.showAnimation {
        self.manGenderView.alpha = 1
        self.manGender.tintColor = Colors.strongGreenColor
        self.maleLabel.textColor = .white
        self.womanGender.tintColor = .darkGray
        self.femaleLabel.textColor = .lightGray
        self.womanGenderView.alpha = 0.5
    }
}
    
    @objc func femaleButtonTapped() {
        presenter.gender = "female"

        womanGenderView.showAnimation {
            self.womanGenderView.alpha = 1
            self.womanGender.tintColor = .systemPink
            self.femaleLabel.textColor = .white
            self.manGender.tintColor = .darkGray
            self.maleLabel.textColor = .lightGray
            self.manGenderView.alpha = 0.5
        }
    }
    
    
    //MARK:- SLIDERS
    
    @IBAction func heightSliderChanged(_ sender: UISlider) {
        presenter.calculateHeight(height: sender.value)
    }
    
    @IBAction func weightSliderChanged(_ sender: UISlider) {
        presenter.calculateWeight(weight: sender.value)
    }
    
    @IBAction func minusButtonTapped(_ sender: UIButton) {
        presenter.minusButton()
    }
    
    @IBAction func plusButtonTapped(_ sender: UIButton) {
        presenter.plusButton()
    }
    
    @IBAction func calculateButton(_ sender: UIButton) {
        presenter.calculateCalories()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCaloriesResult" {
            let caloriesResultDestination = segue.destination as? CaloriesResultViewController
            caloriesResultDestination?.calories = presenter.caloriesRequirement
        }
    }
    //MARK:- UI SET UP
    
    func makeTintImages() {
        
        guard let manGenderImage = UIImage(named: "manGender") else { return }
        let tintManImage = manGenderImage.withRenderingMode(.alwaysTemplate)
        manGender.image = tintManImage
        manGender.tintColor = Colors.strongGreenColor
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
    
    func buttonsCornerRadius() {
        
        let greenColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
        
        ageMinusButton.layer.cornerRadius = ageMinusButton.frame.width / 2
        ageMinusButton.layer.masksToBounds = true
        ageMinusButton.layer.borderColor = greenColor
        ageMinusButton.layer.borderWidth = 1
        agePlusButton.layer.cornerRadius = agePlusButton.frame.width / 2
        agePlusButton.layer.masksToBounds = true
        agePlusButton.layer.borderColor = greenColor
        agePlusButton.layer.borderWidth = 1
        
        calculateButton.layer.cornerRadius = 20
    }
}

extension BodyWeightCalories: CaloriesPickerControllerDelegate {
    func getActivityLevel(activity: String) {
        
        presenter.activityIndexSelected(activity: activity)
        
        activityButton.setTitle(activity, for: .normal)

        // "ACTIVE" is too short, and it looks better when its in center
        if activity == "Active" {
            activityButton.contentHorizontalAlignment = .center
        } else {
            activityButton.contentHorizontalAlignment = .right
        }
    }
}

extension BodyWeightCalories: BodyWeightCaloriesPresenterDelegate {
  
    func performSegueAfterCalculation(){
        performSegue(withIdentifier: "toCaloriesResult", sender: self)
    }
    
    func showAlertIncompleteData() {
        Alert.showBasicAlert(on: self, with: "Incomplete data", message: "Please configure all parameteres", handler: nil)
    }
    
    func plusButtonTapped(value: String) {
        ageTextField.text = value
    }
    
    func minusButtonTapped(value: String) {
        ageTextField.text = value
    }
    
    func calculateWeight(weight: String) {
        weightValueLabel.text = weight
    }
    
    func calculateHeight(height: String) {
        heightValueLabel.text = height
    }
}


//
//lazy var presenter = BodyWeightCaloriesPresenter(bodyWeightCaloriesPresenterDelegate: self)
//
//@IBOutlet weak var calculateButton: UIButton!
//
//@IBOutlet weak var activityButton: UIButton!
//
//@IBOutlet weak var heightView: UIView!
//@IBOutlet weak var heightSlider: UISlider!
//@IBOutlet weak var heightValueLabel: UILabel!
//
//
//@IBOutlet weak var weightView: UIView!
//@IBOutlet weak var weightSlider: UISlider!
//@IBOutlet weak var weightValueLabel: UILabel!
//
//var weightUnit: String {
//    UserDefaults.standard.string(forKey: "unit") ?? "kg"
//}
//
//@IBOutlet weak var ageView: UIView!
//@IBOutlet weak var ageTextField: UITextField!
//@IBOutlet weak var ageMinusButton: UIButton!
//@IBOutlet weak var agePlusButton: UIButton!
//@IBOutlet weak var activityView: UIView!
//
//
//@IBOutlet weak var manGenderView: UIView!
//@IBOutlet weak var manGender: UIImageView!
//@IBOutlet weak var maleLabel: UILabel!
//
//
//@IBOutlet weak var womanGenderView: UIView!
//@IBOutlet weak var womanGender: UIImageView!
//@IBOutlet weak var femaleLabel: UILabel!
//
//let color = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
//
//var gender: String?
//var height: Int?
//var weight: Int?
//var age = 25
//var newAge = String()
//var activityLabel = String()
//var activityIndex: Double?
//var caloriesRequirement = Int()
//
//override func viewDidLoad() {
//    super.viewDidLoad()
//
//makeTintImages()
//buttonsCornerRadius()
//genderViewsButton()
//heightSlider.setValue(100, animated: true)
//weightSlider.setValue(80, animated: true)
//
//}
//
//
////MARK:- PICKER VIEW
//
//@IBAction func activityButtonTapped(_ sender: UIButton) {
//
//    let caloriesPickerController = CaloriesPickerController()
//
//    caloriesPickerController.caloriesPickerDelegate = self
//
//    caloriesPickerController.modalPresentationStyle = .overCurrentContext
//    present(caloriesPickerController, animated: true, completion: nil)
//
//}
//
////MARK:- GENDER VIEWS
//
//func genderViewsButton() {
//
//    manGenderView.isUserInteractionEnabled = true
//
//    let maleButton = UITapGestureRecognizer(target: self, action: #selector(maleButtonTapped))
//    manGenderView.addGestureRecognizer(maleButton)
//
//    let femaleButton = UITapGestureRecognizer(target: self, action: #selector(femaleButtonTapped))
//    womanGenderView.addGestureRecognizer(femaleButton)
//}
//
//@objc func maleButtonTapped() {
//
//gender = "male"
//
//manGenderView.showAnimation {
//    self.manGenderView.alpha = 1
//    self.manGender.tintColor = self.color
//    self.maleLabel.textColor = .white
//    self.womanGender.tintColor = .darkGray
//    self.femaleLabel.textColor = .lightGray
//    self.womanGenderView.alpha = 0.5
//}
//}
//
//@objc func femaleButtonTapped() {
//
//    gender = "female"
//
//    womanGenderView.showAnimation {
//        self.womanGenderView.alpha = 1
//        self.womanGender.tintColor = .systemPink
//        self.femaleLabel.textColor = .white
//        self.manGender.tintColor = .darkGray
//        self.maleLabel.textColor = .lightGray
//        self.manGenderView.alpha = 0.5
//    }
//}
//
//
////MARK:- SLIDERS
//
//func cmToFootAndInches(_ cm: Double) -> String {
//
//    let feet = cm * 0.0328084
//    let feetFloor = Int(floor(feet))
//    let feetRest: Double = ((feet * 100).truncatingRemainder(dividingBy: 100) / 100)
//    let inches = Int(floor(feetRest * 12))
//
//    return "\(feetFloor)' \(inches)\""
//}
//
//@IBAction func heightSliderChanged(_ sender: UISlider) {
//    presenter.calculateHeight(height: sender.value)
//}
//
//@IBAction func weightSliderChanged(_ sender: UISlider) {
//    presenter.calculateWeight(weight: sender.value)
//}
//
//@IBAction func minusButtonTapped(_ sender: UIButton) {
//    guard age >= 1 else { return print("za maly wiek")}
//    age -= 1
//    newAge = String(age)
//    ageTextField.text = newAge
//}
//
//@IBAction func plusButtonTapped(_ sender: UIButton) {
//    guard age >= 1 else { return print("za maly wiek")}
//    age += 1
//    newAge = String(age)
//    ageTextField.text = newAge
//}
//
//@IBAction func calculateButton(_ sender: UIButton) {
//
//    guard let weightValue = weight, let heightValue = height, let activityIndexValue = activityIndex, let genderValue = gender else { return Alert.showBasicAlert(on: self, with: "Incomplete data", message: "Please configure all parameteres", handler: nil) }
//
//    if genderValue == "male" {
//
//    caloriesRequirement = Int((66.47 + 13.75 * Double(weightValue) + 5.03 * Double(heightValue) - 6.7550 * Double(age)) * activityIndexValue)
//
//
//    } else {
//
//        caloriesRequirement = Int((665.09 + 8.56 * Double(weightValue) + 1.84 * Double(heightValue) - 4.67 * Double(age)) * activityIndexValue)
//
//    }
//
//   performSegue(withIdentifier: "toCaloriesResult", sender: self)
//}
//
//override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    if segue.identifier == "toCaloriesResult" {
//        let caloriesResultDestination = segue.destination as? CaloriesResultViewController
//        caloriesResultDestination?.calories = caloriesRequirement
//}
//}
////MARK:- UI SET UP
//
//func makeTintImages() {
//    guard let manGenderImage = UIImage(named: "manGender") else { return }
//    let tintManImage = manGenderImage.withRenderingMode(.alwaysTemplate)
//    manGender.image = tintManImage
//    manGender.tintColor = color
//    manGenderView.layer.cornerRadius = 15
//
//    guard let womanGenderImage = UIImage(named: "womanGender") else { return }
//    let tintWomanGender = womanGenderImage.withRenderingMode(.alwaysTemplate)
//    womanGender.image = tintWomanGender
//    womanGender.tintColor = .systemPink
//    womanGenderView.layer.cornerRadius = 15
//
//    heightView.layer.cornerRadius = 15
//    weightView.layer.cornerRadius = 15
//    ageView.layer.cornerRadius = 15
//    activityView.layer.cornerRadius = 15
//
//}
//
//func buttonsCornerRadius() {
//
//    let greenColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
//
//    ageMinusButton.layer.cornerRadius = ageMinusButton.frame.width / 2
//    ageMinusButton.layer.masksToBounds = true
//    ageMinusButton.layer.borderColor = greenColor
//    ageMinusButton.layer.borderWidth = 1
//    agePlusButton.layer.cornerRadius = agePlusButton.frame.width / 2
//    agePlusButton.layer.masksToBounds = true
//    agePlusButton.layer.borderColor = greenColor
//    agePlusButton.layer.borderWidth = 1
//
//    calculateButton.layer.cornerRadius = 20
//}
//}
//
//extension BodyWeightCalories: CaloriesPickerControllerDelegate {
//func getActivityLevel(activity: String) {
//    activityButton.setTitle(activity, for: .normal)
//    // "ACTIVE" is to short, and it looks better when its in center
//    if activity == "Active" {
//        activityButton.contentHorizontalAlignment = .center
//    } else {
//        activityButton.contentHorizontalAlignment = .right
//    }
//
//    switch activity {
//    case "Sedentary":
//        activityIndex = 1.2
//    case "Low":
//        activityIndex = 1.3
//    case "Moderately":
//        activityIndex = 1.4
//    case "Active":
//        activityIndex = 1.5
//    case "Very active":
//        activityIndex = 1.7
//    default:
//        activityIndex = 1.4
//        print("activity index is not choosen")
//    }
//    print("activity is \(activity)")
//}
//}
//
//extension BodyWeightCalories: BodyWeightCaloriesPresenterDelegate {
//
//func calculateWeight(weight: String) {
//    weightValueLabel.text = "\(weight)\(weightUnit)"
//}
//
//func calculateHeight(heightCm: String, heightInch: String) {
//    heightValueLabel.text = "\(heightCm)cm (\(heightInch))"
//}
//}
