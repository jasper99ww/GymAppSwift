//
//  AccountService.swift
//  GymLog
//
//  Created by Kacper P on 18/07/2021.
//

import Foundation

//protocol AccountModelDataDelegate: class {
//    func didRecieveDataUpdate(completion: ([AccountModelData]))
//    func didFailDataUpdateWithError(error: Error)
//}

class AccountService {
    
    let array: [AccountModelData] = []

    var email: String {
        getAddresEmail()
    }

    func getUserInfo(completion: @escaping([AccountModelData]) -> ()) {

        var username = String()
        var data = [AccountModelData]()

        getUserName { (retrievedUsername) in
            username = retrievedUsername
            data = [AccountModelData(mainLabel: Account.username, secondLabel: username), AccountModelData(mainLabel: Account.email, secondLabel: self.email), AccountModelData(mainLabel: Account.account, secondLabel: "FREE")]
//            self.delegate?.didRecieveDataUpdate(completion: data)
            completion(data)
        }
    }

    func getAddresEmail() -> String {
        guard let emailAddress = Firebase.email  else { return "error during received email" }
        print("email to \(emailAddress)")
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

//extension AccountService: AccountModelDataDelegate {
//
//    func didRecieveDataUpdate(completion: @escaping([AccountModelData]) -> Void) {
//        getUserInfo { (dataC) in
//            completion(dataC)
//        }
//    }
//
//    func didFailDataUpdateWithError(error: Error) {
//        <#code#>
//    }
//}
