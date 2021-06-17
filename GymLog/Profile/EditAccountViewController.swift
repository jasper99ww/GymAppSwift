//
//  EditAccountViewController.swift
//  GymLog
//
//  Created by Kacper P on 15/06/2021.
//

import UIKit


protocol ChangedValueDelegate {
    func didChangeValue(value: String)
}

class EditAccountViewController: UIViewController {

    @IBOutlet weak var newLabel: UILabel!
    @IBOutlet weak var newValue: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    let service = ProfileService()
    
    var first: String?
    var second: String?
    var changedUsername: ((String) -> ())?
    var changedEmail: ((String) -> ())?
    
//    var changedValueDelegate: ChangedValueDelegate!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newLabel.text = first
        newValue.text = second
       
    }
    
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        changeDataInDatabase()
        
    }
    
    func changeDataInDatabase() {
        if let newLabel = newLabel.text, let newValue = newValue.text {
        switch newLabel {
        case "Username":
            service.changeUsername(newUsername: newValue)
            changedUsername?(newValue)
          
            self.navigationController?.popViewController(animated: true)
        case "E-mail address":
          
            
            service.showBeforeChangeEmail(vc: self, submitedEmail: newValue) {
                self.changedEmail?(newValue)
//                self.changedValueDelegate.didChangeValue(value: newValue)
                self.navigationController?.popViewController(animated: true)
            }
       
        default:
            print("do nothing")
        }
        }

    }
}
