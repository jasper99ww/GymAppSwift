//
//  Constants.swift
//  GymLog
//
//  Created by Barbara Podgórska on 21/02/2021.
//

import Foundation
import Firebase

struct Firebase {
    static let db = Firestore.firestore()
    static let userUID = Auth.auth().currentUser?.uid
    static let user = Auth.auth().currentUser
    static let email = Auth.auth().currentUser?.email
    static let emailAuthProvider = EmailAuthProvider.self

}

struct Account {
   
    static let username = "Username"
    static let email = "E-mail address"
    static let account = "Account"
}


struct Constants {
    
    struct Storyboard {
        
        static let homeViewController = "HomeVC"
        
    }
    
  
}
