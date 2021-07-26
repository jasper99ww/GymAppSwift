//
//  BodyWeightService.swift
//  GymLog
//
//  Created by Kacper P on 28/06/2021.
//

import Foundation
import Firebase

protocol BodyWeightServiceProtocol {
    func saveNewWeight(weight: String)
    func getData(completionHandler: @escaping([BodyWeightCalendarModel]) -> Void)
}

class BodyWeightService: BodyWeightServiceProtocol {
    
    let dateFormatter = DateFormatter()
    
    let user = Auth.auth().currentUser
    
    var array: [BodyWeightCalendarModel] = []
    
    var arrayOfDocuments: [String] = []
    
    func saveNewWeight(weight: String) {
        
        print("weight is \(weight)")
            let date = Date()
            let formattedDateDocument = date.getFormattedDate(format: "yyyy-MM-dd")
            let formattedDate = date.getFormattedDate(format: "yyyy-MM-dd HH:mm")
      
        guard let currentUser = Firebase.userUID else { return }

            Firebase.db.collection("users").document(currentUser).collection("Weight").document(formattedDateDocument).setData(["weight": weight, "date": formattedDate]) { (error) in
                if let error = error {
                    print("error is \(error.localizedDescription)")
                }
            }
        
    }
    
    func getLastWeight() {
        
    }

    func getData(completionHandler: @escaping([BodyWeightCalendarModel]) -> Void) {
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        guard let currentUser = Firebase.userUID else { return }

            Firebase.db.collection("users").document(currentUser).collection("Weight").getDocuments { (result, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    if let documents = result?.documents {
                        
                        for doc in documents {
                            
                            if let weight = doc["weight"] as? String, let date = doc["date"] as? String {
                               
                                if let weightFloat = Float(weight),let dateInDateFormat = self.dateFormatter.date(from: date) {
                                   
                                let newModel = BodyWeightCalendarModel(weight: weightFloat, date: dateInDateFormat)
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


