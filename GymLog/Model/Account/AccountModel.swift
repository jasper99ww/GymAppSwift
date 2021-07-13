//
//  AccountModel.swift
//  GymLog
//
//  Created by Kacper P on 13/07/2021.
//

import UIKit

protocol AccountModelDataDelegate: class {
    func didRecieveDataUpdate(data: [AccountModelData])
    func didFailDataUpdateWithError(error: Error)
}

struct AccountModelData {
    var mainLabel: String
    var secondLabel: String
}

class AccountModel {
    
    let array: [AccountModelData] = []
    
    weak var delegate: AccountModelDataDelegate?
 
    func getUserInfo() {
    
        let email = getAddresEmail()
        var username = String()
        var data = [AccountModelData]()
        
        getUserName { (retrievedUsername) in
            username = retrievedUsername
            data = [AccountModelData(mainLabel: Account.username, secondLabel: username), AccountModelData(mainLabel: Account.username, secondLabel: email), AccountModelData(mainLabel: Account.account, secondLabel: "FREE")]
            self.delegate?.didRecieveDataUpdate(data: data)
        }
    }
    
    func getAddresEmail() -> String {
        guard let emailAddress = Firebase.email  else { return "error during received email" }
        return emailAddress
    }
    
    
    func getUserName(completionHandler: @escaping(String) -> ()) {
    
        Firebase.db.collection("users").document(Firebase.user!).getDocument { (document, error) in
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
}
