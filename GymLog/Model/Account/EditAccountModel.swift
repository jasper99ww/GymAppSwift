//
//  EditAccountModel.swift
//  GymLog
//
//  Created by Kacper P on 13/07/2021.
//

import UIKit
import Firebase

class EditAccountModel {
    
    var changedUsername: ((String) -> ())?
    var changedEmail: ((String) -> ())?
    var password: UITextField?
    
    func changeDataInDatabase(newLabel: String, newValue: String, vc: UIViewController) {
        
        switch newLabel {
        case "Username":
            changeUsername(newUsername: newValue)
            changedUsername?(newValue)
          
        case "E-mail address":
                      
        showBeforeChangeEmail(vc: vc, submitedEmail: newValue) {
            self.changedEmail?(newValue)

//        self.navigationController?.popViewController(animated: true)
            }
       
        default:
            print("do nothing")
        }
        }

    }
    
    
    func changeUsername(newUsername: String) {
        Firebase.db.collection("users").document(Firebase.user!).updateData(["username": newUsername]) { (err) in
            if let err = err {
                print("\(err.localizedDescription)")
            } else {
               print("Username successfully updated")
            }
        }
    }
    
func showBeforeChangeEmail(vc: UIViewController, submitedEmail: String, completionHandler: @escaping() -> Void) {
        
        let reauthAlert = UIAlertController(title: "Reauthenticate", message: "In order to change your e-mail address, please provide your password", preferredStyle: .alert)
        
        reauthAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            print("alert has canceled")
        }))
        
        reauthAlert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (action) in
            changeEmail(newEmail: submitedEmail)
            completionHandler()

        }))
    
        reauthAlert.addTextField { (textField) in
            textField.isSecureTextEntry = true
            
            password = textField
        }
        
        vc.present(reauthAlert, animated: true)
    }

//static let credentials = AuthCredential?()
//static let emailAuthProvider = EmailAuthProvider?()

    func changeEmail(newEmail: String) {
    
        if let user = Firebase.user, let email = Firebase.email, let password = password?.text {
            
            let credentials = AuthCredential?.credential(withEmail: email, password: password)
            user.reauthenticate(with: credentials) { (result, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    user.updateEmail(to: newEmail, completion: { (error) in
            if let error = error {
                print(error)
            } else {
                print("Email has changed")
            }
        })
    }
    }
}
}

