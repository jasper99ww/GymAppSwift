//
//  EditAccountModel.swift
//  GymLog
//
//  Created by Kacper P on 13/07/2021.
//

import UIKit
import Firebase

struct EDITACCOUNTMODELL {
    var changedUsername: String
    var changedEmail: String
    var password: String
}

class EditAccountModel {
    
    var changedUsername: ((String) -> ())?
    var changedEmail: ((String) -> ())?
    var password: UITextField?
    
    func changeDataInDatabase(newLabelText: String?, newValueText: String?, vc: UIViewController, completion: @escaping() -> ()) {
        
        guard let newLabel = newLabelText, let newValue = newValueText else { return }
        
        switch newLabel {
        
        case "Username":
            changeUsername(newUsername: newValue)
            changedUsername?(newValue)
          completion()
            
        case "E-mail address":
                      
        showBeforeChangeEmail(vc: vc, submitedEmail: newValue) {
            self.changedEmail?(newValue)
            completion()
            }
       
        default:
            print("do nothing")
        }
    }
    
    func changeUsername(newUsername: String) {
        Firebase.db.collection("users").document(Firebase.userUID!).updateData(["username": newUsername]) { (err) in
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
            self.changeEmail(newEmail: submitedEmail)
            completionHandler()
        }))
    
        reauthAlert.addTextField { (textField) in
            textField.isSecureTextEntry = true
        }
        
        vc.present(reauthAlert, animated: true)
    }

    func changeEmail(newEmail: String) {
    
        if let user = Firebase.user, let email = Firebase.email, let password = password?.text {
            
            let credentials = EmailAuthProvider.credential(withEmail: email, password: password)
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
}

