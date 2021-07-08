//
//  CaloriesPickerController.swift
//  GymLog
//
//  Created by Kacper P on 07/07/2021.
//

import UIKit

struct ActivityLevels {
    let levelOfActivity: String
    let descriptionOfActivity: String
}

protocol CaloriesPickerControllerDelegate {
    func getActivityLevel(activity: String)
}

class CaloriesPickerController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var caloriesPickerDelegate: CaloriesPickerControllerDelegate!
    
    var activityIndexes: [ActivityLevels] = [ActivityLevels(levelOfActivity: "Sedentary", descriptionOfActivity: "mostly sitting, no exercise") ,ActivityLevels(levelOfActivity: "Low", descriptionOfActivity: "short walks, exercise 1-3 times/week"), ActivityLevels(levelOfActivity: "Moderately", descriptionOfActivity: "exercises 2-3 times/week"), ActivityLevels(levelOfActivity: "Active", descriptionOfActivity: "mostly walking, exercise more than 3 times/week"), ActivityLevels(levelOfActivity: "Very active", descriptionOfActivity: "hard workouts every day")]
    
//    var activityIndex: [String:String] = ["Sedentary": "mostly sitting, no exercise", "Low": "short walks, exercise 1-3 times/week", "Moderately": "exercises 2-3 times/week", "Active": "mostly walking, exercise more than 3 times/week", "Extremely active": "hard workouts every day"]

        let screenWidth = UIScreen.main.bounds.width - 20
        let screenHeight = UIScreen.main.bounds.height / 4
    
        let vc = UIViewController()
        var selectedRow = 0    
        
        override func viewDidLoad() {

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
