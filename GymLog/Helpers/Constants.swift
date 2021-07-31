

import Foundation
import Firebase

struct Colors {
    static let greenColor = UIColor.init(red: 81/255, green: 134/255, blue: 87/255, alpha: 1)
    static let chartColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
}

struct Images {
    static let arrowUp = "arrow.up"
    static let arrowDown = "arrow.down"
}

struct DateFormats {
    static let formatYearMonthDay = "yyyy-MM-dd"
    static let formatMonth = "MMMM"
    static let formatYearMonthDayTime = "yyyy-MM-dd HH:mm"
    static let formatDayMonthTime = "dd.MM, HH:mm"
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
