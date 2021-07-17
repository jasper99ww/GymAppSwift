//
//  EditAccountViewController.swift
//  GymLog
//
//  Created by Kacper P on 15/06/2021.
//

import UIKit

class EditAccountViewController: UIViewController {

   
    private let editAccountModel = EditAccountModel()
    @IBOutlet weak var newLabel: UILabel!
    @IBOutlet weak var newValue: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
  
    var first: String?
    var second: String?
    var changedUsername: ((String) -> ())?
    var changedEmail: ((String) -> ())?
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newLabel.text = first
        newValue.text = second
       
    }
    
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        editDB()
    }
    
    func editDB() {
       
        editAccountModel.changeDataInDatabase(newLabelText: newLabel.text, newValueText: newValue.text, vc: self, completion: {
            self.navigationController?.popViewController(animated: true)
        })
    }
}
