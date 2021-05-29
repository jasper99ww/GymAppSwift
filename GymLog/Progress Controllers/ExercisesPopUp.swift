//
//  ExercisesPopUp.swift
//  GymLog
//
//  Created by Kacper P on 25/05/2021.
//

import UIKit

class ExercisesPopUp: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
            
          
    var exercises: [String] = []
    let screenWidth = UIScreen.main.bounds.width - 20
    let screenHeight = UIScreen.main.bounds.height / 7
    let vc = UIViewController()
    var selectedRow = 0
    var selectedExercise: ((_ data: String) -> ())?
    var selectedWorkout: String = ""
    
    override func viewDidLoad() {
        print("selected workout \(selectedWorkout)")
        getWorkoutsTitle()
        alert()
    }
    
    func getWorkoutsTitle() {
            exercises.insert("ALL EXERCISES", at: 0)
        
        }
        
    
    func alert() {
    
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)

        let alert = UIAlertController(title: "Select Exercise", message: "", preferredStyle: .actionSheet)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 200))
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.selectRow(selectedRow, inComponent: 0, animated: false)
        
        
        alert.view.addSubview(pickerView)
        pickerView.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor).isActive = true
        
        let TitleString = NSAttributedString(string: "Select Exercise", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.backgroundColor : UIColor.clear])
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
            let selected = self.exercises[self.selectedRow]
            print("\(selected) SELECTED")
            self.selectedExercise?(selected)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return exercises[row]
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return exercises.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }


}
