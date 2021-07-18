//
//  ConfirmationPasswordPresenter.swift
//  GymLog
//
//  Created by Kacper P on 18/07/2021.
//

import UIKit

//enum Outcome {
//    case submitted
//    case rejected
//}

struct ConfirmationPasswordPresenter {
    
    let question: String
    
    let submitedTitle: String
    
    let rejectTitle: String
    
//    let handler: (Outcome) -> Void
    
    let textfieldValue: (String) -> Void
    
    func presentAlert(in vc: UIViewController) {
        
        let reauthAlert = UIAlertController(title: "Reauthenticate", message: question, preferredStyle: .alert)
        reauthAlert.addTextField()
//        reauthAlert.addTextField { (textField) in
//            textField.isSecureTextEntry = true
////            guard let textField = textField.text else {return}
////            self.textfieldValue(textField)
//        }
        
        let rejectAction = UIAlertAction(title: rejectTitle, style: .cancel) { _ in
//
//            self.handler(.rejected)
            
        }

        let submitAction = UIAlertAction(title: submitedTitle, style: .default) { _ in
//            self.handler(.submitted)
            let answer = reauthAlert.textFields![0]
            textfieldValue(answer.text!)
        }
       
    
        reauthAlert.addAction(rejectAction)
        reauthAlert.addAction(submitAction)
        
        vc.present(reauthAlert, animated: true)

    }
}

