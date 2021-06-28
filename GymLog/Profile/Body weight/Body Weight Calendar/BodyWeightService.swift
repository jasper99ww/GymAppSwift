//
//  BodyWeightService.swift
//  GymLog
//
//  Created by Kacper P on 28/06/2021.
//

import Foundation
import Firebase

struct Weight {
    let weight: Float
    let date: String
}

class BodyWeightService {
    
    
    let db = Firestore.firestore()
    
    let user = Auth.auth().currentUser
    
    var array: [Weight] = []
    
    var arrayOfDocuments: [String] = []
    
    func saveNewWeight(weight: Float, date: String) {
        
        if let user = user?.uid {
            db.collection("users").document(user).collection("Weight").document(date).setData(["weight": weight, "date": date]) { (error) in
                if let error = error {
                    print("error is \(error.localizedDescription)")
                }
            }
        }
    }
    
    func getData(completionHandler: @escaping([Weight]) -> Void) {
        
        if let user = user?.uid {
            db.collection("users").document(user).collection("Weight").getDocuments { (result, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    if let documents = result?.documents {
                        
                        for doc in documents {
                            
                            if let weight = doc["weight"] as? Float, let date = doc["date"] as? String {
                                let newModel = Weight(weight: weight, date: date)
                                self.array.append(newModel)
                                print("newModel is \(newModel)")
                            }
                        }
                    }
                    completionHandler(self.array)
                }
            }
        }
    }
}
