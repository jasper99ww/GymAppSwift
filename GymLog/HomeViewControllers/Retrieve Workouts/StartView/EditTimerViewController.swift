//
//  EditTimerViewController.swift
//  GymLog
//
//  Created by Kacper P on 11/07/2021.
//

import UIKit

class EditTimerViewController: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
  
    
    func showAlert(view: UIViewController, message: String, completion: @escaping(Int) -> ()) {
        
        let alertView = UIAlertController(
            title: "Set new pause",
            message: "",
            preferredStyle: .alert)
        
        let height: NSLayoutConstraint = NSLayoutConstraint(item: alertView.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)
        
        alertView.view.addConstraint(height)
        
        let picker = UIPickerView(frame:
            CGRect(x: 0, y: 50, width: 260, height: 180))
        
        picker.dataSource = self
        picker.delegate = self

        picker.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)

        alertView.view.addSubview(picker)
                    

        let actionConfirm = UIAlertAction(title: "OK", style: .default) { (accepted) in
            print("accepted \(accepted)")
            let minute = picker.selectedRow(inComponent: 0)
//            let minuteString = String(picker.selectedRow(inComponent: 0))
            let seconds = picker.selectedRow(inComponent: 1)
//            let secondsString = String(picker.selectedRow(inComponent: 1))
//            var time = String()
            if picker.selectedRow(inComponent: 0) > 0 {
//                time = "\(minuteString):\(secondsString)"
                let newTime = minute * 60 + seconds
                completion(newTime)
//                print("time is \(minute):\(seconds)")
            } else {
//                print("time is \(seconds)sec")
                completion(seconds)
            }
            
            
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertView.addAction(actionConfirm)
        alertView.addAction(actionCancel)
        view.present(alertView, animated: true)
        
    }
    
    
    
//    let screenWidth = UIScreen.main.bounds.width - 20
//    let screenHeight = UIScreen.main.bounds.height / 4
//
//    let vc = UIViewController()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        alert()
//
//    }
//
//    func alert() {
//
//        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
//
//        let alert = UIAlertController(title: "Set new timer", message: "", preferredStyle: .alert)
//
//
//            let pickerView = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
//
//
//            pickerView.dataSource = self
//            pickerView.delegate = self
//
//        vc.view.addSubview(pickerView)
//        pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
//        pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
//        alert.setValue(vc, forKey: "contentViewController")
//            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
//
////                print("You selected " + self.typeValue )
//
//            }))
//
//        self.present(alert,animated: true, completion: nil )
//    }
//
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 60
        } else {
            return 61
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(row) min"
        } else {
            return "\(row) sec"
        }
    }




}
