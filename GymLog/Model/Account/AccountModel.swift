//
//  AccountModel.swift
//  GymLog
//
//  Created by Kacper P on 13/07/2021.
//

import UIKit

protocol AccountModelDataDelegate: class {
    func didRecieveDataUpdate(completion: @escaping([AccountModelData]) -> Void)
    func didFailDataUpdateWithError(error: Error)
}

struct AccountModelData {
    var mainLabel: String
    var secondLabel: String
}

class AccountModel: AccountModelDataDelegate {

    func didFailDataUpdateWithError(error: Error) {
        print("BOBO ")
    }
    
    
    let array: [AccountModelData] = []
    
    weak var delegate: AccountModelDataDelegate?
 
    func getUserInfo(completion: @escaping([AccountModelData]) -> ()) {
    
        let email = getAddresEmail()
        var username = String()
        var data = [AccountModelData]()
        
        getUserName { (retrievedUsername) in
            username = retrievedUsername
            data = [AccountModelData(mainLabel: Account.username, secondLabel: username), AccountModelData(mainLabel: Account.email, secondLabel: email), AccountModelData(mainLabel: Account.account, secondLabel: "FREE")]
//            self.delegate?.didRecieveDataUpdate(data: data)
            completion(data)
        }
    }
    
    func didRecieveDataUpdate(completion: @escaping([AccountModelData]) -> Void) {
        getUserInfo { (dataC) in
            completion(dataC)
        }
    }
    
    
    
    
    func getAddresEmail() -> String {
        guard let emailAddress = Firebase.email  else { return "error during received email" }
        return emailAddress
    }
    
    
    func getUserName(completionHandler: @escaping(String) -> ()) {
    
        Firebase.db.collection("users").document(Firebase.userUID!).getDocument { (document, error) in
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
