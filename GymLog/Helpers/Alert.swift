//
//  Alert.swift
//  GymLog
//
//  Created by Barbara Podgórska on 09/03/2021.
//

import Foundation
import UIKit

struct Alert {
    
    private static func showBasicAlert(on vc: UIViewController, with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            vc.present(alert, animated: true)
        }
    }
    
    static func showIncompleteFormAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Incomplete workout name", message: "Please entry a workout name")
    }
    
    static func showIncompleteSetAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Incomplete data", message: "Please fill out all data in current exercise")
    }
    
   
    
    static func showBeforeNextExerciseAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Incomplete data", message: " Please fill out all fields and checkmarks")
    }
    
    static func showBeforeLogOut(on vc: UIViewController, completionHandler: @escaping(String) -> ()) {
        let alert = UIAlertController(title: "Signing out", message: "Are you sure you want to sign out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            print("tapped Yes")
            completionHandler("Yes")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            print("tapped No")
        }))
        
        vc.present(alert, animated: true)
    }
    
   
}
