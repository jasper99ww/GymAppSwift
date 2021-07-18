//
//  EditAccountViewController.swift
//  GymLog
//
//  Created by Kacper P on 15/06/2021.
//

import UIKit


class EditAccountViewController: UIViewController {

    lazy var editAccountPresenter = EditAccountPresenter(editAccountService: EditAccountService(), editAccountPresenterDelegate: self, passwordConfirmationDelegate: self, editAccountPresenterUpdatedData: self)
    
    @IBOutlet weak var newLabel: UILabel!
    @IBOutlet weak var newValue: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!

    var changedUsername: ((String) -> ())?
    var changedEmail: ((String) -> ())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editAccountPresenter.getModel()
        editAccountPresenter.passwordConfirmationDelegate = self
    }
    
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let newValue = newValue.text else { return }
        editAccountPresenter.changeDataInDataBase(newValue: newValue)
        
    }
}

extension EditAccountViewController: EditAccountPresenterDelegate {
    
    func updateFirstLabel(firstLabel: String) {
        newLabel.text = firstLabel
    }
    func updateSecondLabel(secondLabel: String) {
        newValue.text = secondLabel
    }
}

extension EditAccountViewController: EditAccountPresenterUpdatedData {
    
    func passDataToCallBack(changedComponent: String) {
        switch changedComponent {
        case Account.username:
            changedUsername?(newValue.text!)
        case Account.email:
            changedEmail?(newValue.text!)
        default:
            break
        }
    }
    
    func successfullyChangedData(changedComponent: String) {

        Alert.showBasicAlert(on: self, with: "Success!", message: "Your \(changedComponent) has changed!", handler: {_ in
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func failedChangedData() {
        Alert.showBasicAlert(on: self, with: "Error", message: "Oops, that wasn't correct password", handler: nil)
    }
    
    func errorDuringChangeData() {
        Alert.showBasicAlert(on: self, with: "Error occured", message: "Something went wrong during saving, try again") { _ in
            self.navigationController?.popViewController(animated: true)
        }
        
    }
}


extension EditAccountViewController: PasswordConfirmationDelegate {
    func showBeforeChangingEmail() {
        
        guard let newValue = newValue.text, !newValue.isEmpty  else { return Alert.showBasicAlert(on: self, with: "Invalid new e-mail address", message: "Your new e-mail address is empty", handler: nil) }
        
        let presenter = ConfirmationPasswordPresenter(question: "In order to change your e-mail address, please provide your password", submitedTitle: "Submit", rejectTitle: "Cancel", textfieldValue: { [unowned self] enteredPassword in
            editAccountPresenter.changeEmailInDatabase(newEmail: newValue, password: enteredPassword)
        })
        
        presenter.presentAlert(in: self)
    }
}
