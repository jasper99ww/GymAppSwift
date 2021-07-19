//
//  EditAccountService.swift
//  GymLog
//
//  Created by Kacper P on 18/07/2021.
//

import Foundation

enum EmailChange {
    case changed
    case failed
    case error
}

class EditAccountService {
        
        func changeUsername(newUsername: String) {
            Firebase.db.collection("users").document(Firebase.userUID!).updateData(["username": newUsername]) { (err) in
                if let err = err {
                    print("\(err.localizedDescription)")
                } else {
                   print("Username successfully updated")
                }
            }
        }
    
    func changeEmail(newEmail: String, password: String?, completion: @escaping(EmailChange) -> Void) {
    
        if let user = Firebase.user, let email = Firebase.email, let password = password {
            
            let credentials = Firebase.emailAuthProvider.credential(withEmail: email, password: password)
            user.reauthenticate(with: credentials) { (result, error) in
                if let error = error {
                    completion(.failed)
                    print(error.localizedDescription)
                } else {
                    user.updateEmail(to: newEmail, completion: { (error) in
            if let error = error {
                print(error.localizedDescription)
                completion(.error)
            } else {
                completion(.changed)
                print("changed on \(newEmail)")
            }
        })
    }
    }
}
}
        
//        func showBeforeChangeEmail(vc: UIViewController, submitedEmail: String, completionHandler: @escaping() -> Void) {
//            
//            let reauthAlert = UIAlertController(title: "Reauthenticate", message: "In order to change your e-mail address, please provide your password", preferredStyle: .alert)
//
//            reauthAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
//                print("alert has canceled")
//            }))
//
//            reauthAlert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (action) in
//                self.changeEmail(newEmail: submitedEmail)
//                completionHandler()
//            }))
//
//            reauthAlert.addTextField { (textField) in
//                textField.isSecureTextEntry = true
//            }
//
//            vc.present(reauthAlert, animated: true)
//        }

        
    
}
