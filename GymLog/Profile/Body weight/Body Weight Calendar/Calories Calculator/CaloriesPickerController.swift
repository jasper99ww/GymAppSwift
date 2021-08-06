//
//  CaloriesPickerController.swift
//  GymLog
//
//  Created by Kacper P on 07/07/2021.
//

import UIKit


protocol CaloriesPickerControllerDelegate {
    func getActivityLevel(activity: String)
}

class CaloriesPickerController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var caloriesPickerDelegate: CaloriesPickerControllerDelegate!
    
    lazy var presenter = BodyWeightCaloriesPresenter()
    
    var activityIndexes = [ActivityLevels]()
    
    let screenWidth = UIScreen.main.bounds.width - 20
    let screenHeight = UIScreen.main.bounds.height / 4
    
    let vc = UIViewController()
    var selectedRow = 0
    
    override func viewDidLoad() {
        
        presenter.bodyWeightCaloriesPickerDelegate = self
        presenter.getPickerData()
        alert()
    }
    
    func alert() {
        
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        
        let alert = UIAlertController(title: "Select Exercise", message: "", preferredStyle: .actionSheet)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.selectRow(3, inComponent: 0, animated: false)
        
        
        vc.view.addSubview(pickerView)
        pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        
        let TitleString = NSAttributedString(string: "Select level of activity", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 25), NSAttributedString.Key.backgroundColor : UIColor.clear])
        
        alert.setValue(TitleString, forKey: "attributedTitle")
        alert.setValue(vc, forKey: "contentViewController")
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel,handler: { (UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
            
        })
        
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        alert.addAction(cancelAction)
        
        
        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { (UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
            self.selectedRow = pickerView.selectedRow(inComponent: 0)
            //            let selected = Array(self.activityIndex)[self.selectedRow].value
            let selected = self.activityIndexes[self.selectedRow].levelOfActivity
            //              self.selectedActivity?(selected)
            self.caloriesPickerDelegate.getActivityLevel(activity: selected)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 80))
        
        label.font = label.font.withSize(23)
        label.autoresizingMask = .flexibleWidth
        label.textAlignment = .center
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        //        label.text = Array(activityIndex)[row].value
        label.text = activityIndexes[row].descriptionOfActivity
        label.sizeToFit()
        
        return label
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return activityIndexes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 80
    }
    
}

extension CaloriesPickerController: BodyWeightCaloriesPickerDelegate {
    func updatePickerData(data: [ActivityLevels]) {
        activityIndexes = data
    }
}
