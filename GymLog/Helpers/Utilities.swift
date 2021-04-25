//
//  Utilities.swift
//  GymLog
//
//  Created by Barbara Podgórska on 21/02/2021.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class Utilities {
    
    
    static func styleTextField(_ textfield:UITextField) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0.0, y: textfield.frame.height - 1, width: textfield.frame.width, height: 1.0)
        
        bottomLine.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
        
        // Remove border on text field
        
        
        textfield.borderStyle = .none
        
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    static func styleFilledButton(_ button:UIButton) {
        
        // Filled rounded corner style
        button.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        button.layer.cornerRadius = button.frame.height / 2
        button.tintColor = UIColor.white
    }
    
    static func styleHollowButton(_ button:UIButton) {
        
        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
        button.layer.cornerRadius = button.frame.height / 2
        button.tintColor = UIColor.white
    }
    
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    static func titleAnimation (_ title: UILabel) {
    
        title.text = ""
        var charIndex = 0.0
        let titleText = "Encrease your performance."
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.025 * charIndex, repeats: false) { (timer) in
                title.text?.append(letter)
        }
            charIndex += 1
        }
}
//    static func styleTextFieldForWorkout(_ textfield:UITextField) {
//
//        // Create the bottom line
//        let bottomLine = CALayer()
//
//        bottomLine.frame = CGRect(x: 0.0, y: textfield.frame.height - 10, width: textfield.frame.width, height: 1.0)
//
//        bottomLine.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
//
//        // Remove border on text field
//
//        textfield.borderStyle = .none
//
//        // Add the line to the text field
//        textfield.layer.addSublayer(bottomLine)
//
//    }
   
        
        
}

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
