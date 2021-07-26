

import Foundation
import Firebase

struct Colors {
    static let greenColor = UIColor.init(red: 81/255, green: 134/255, blue: 87/255, alpha: 1)
}

struct DateFormats {
    static let formatYearMonthDay = "yyyy-MM-dd"
    static let formatMonth = "MMMM"
}

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
