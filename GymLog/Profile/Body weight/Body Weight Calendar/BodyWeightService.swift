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
    let date: Date
}

class BodyWeightService {
    
    let dateFormatter = DateFormatter()
    
    let db = Firestore.firestore()
    
    let user = Auth.auth().currentUser
    
    var array: [Weight] = []
    
    var arrayOfDocuments: [String] = []
    
    func saveNewWeight(weight: String) {
        print("weight is \(weight)")
            let date = Date()
            let formattedDate = date.getFormattedDate(format: "yyyy-MM-dd")
        
        if let user = user?.uid {
            db.collection("users").document(user).collection("Weight").document(formattedDate).setData(["weight": weight, "date": formattedDate]) { (error) in
                if let error = error {
                    print("error is \(error.localizedDescription)")
                }
            }
        }
    }

    func getData(completionHandler: @escaping([Weight]) -> Void) {
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let user = user?.uid {
            db.collection("users").document(user).collection("Weight").getDocuments { (result, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    if let documents = result?.documents {
                        
                        for doc in documents {
                            
                            if let weight = doc["weight"] as? String, let date = doc["date"] as? String {
                               
                                if let weightFloat = Float(weight),let dateInDateFormat = self.dateFormatter.date(from: date) {
                                   
                                let newModel = Weight(weight: weightFloat, date: dateInDateFormat)
                                self.array.append(newModel)
                             
                                }
                            }
                        }
                    }
                    completionHandler(self.array)
                }
            }
        }
    }
}

