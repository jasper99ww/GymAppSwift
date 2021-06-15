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
    
    
    
    func getUserName(completionHandler: @escaping(String) -> ()) {
        
        db.collection("users").document(user!.uid).getDocument { (document, error) in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                if let document = document, document.exists {
                    let documentData = document["username"] as! String
                    print("NAZWA to \(documentData)")
                    completionHandler(documentData)
                }
            }
        }
        
    }
    
    
}
