//
//  ProfileService.swift
//  GymLog
//
//  Created by Kacper P on 15/06/2021.
//

import Foundation
import UIKit
import Firebase

class ProfileService {
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    var password: UITextField?
    var credentials: AuthCredential?
    
    func getUserName(completionHandler: @escaping(String) -> ()) {
        
        db.collection("users").document(user!.uid).getDocument { (document, error) in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                if let document = document, document.exists {
                    let documentData = document["username"] as! String
                    completionHandler(documentData)
                }
            }
        }
        
    }
    
    func changeUsername(newUsername: String) {
        db.collection("users").document(user!.uid).updateData(["username": newUsername]) { (err) in
            if let err = err {
                print("\(err.localizedDescription)")
            } else {
               print("Username successfully updated")
            }
        }
    }
    
    func changeEmail(newEmail: String) {
    
        if let user = user, let email = user.email, let password = password?.text {
            
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
            self.password = textField
        }
        
        vc.present(reauthAlert, animated: true)
    }
    
    
    
}
