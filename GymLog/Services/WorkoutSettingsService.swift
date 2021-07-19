//
//  UnitClass.swift
//  GymLog
//
//  Created by Kacper P on 20/06/2021.
//

import Foundation
import Firebase
import UIKit

class WorkoutSettingsService {
    
    let db = Firestore.firestore()
    
    let user = Auth.auth().currentUser
    var arrayOfTitles: [String] = []
    var arrayTitleOfDocuments: [String: [String]] = [:]
    var arrayOfCalendarDocuments: [String] = []
    var dispatchGroup = DispatchGroup()
    
    func retrieveArrays() {
        
        if let arrayTitles = UserDefaults.standard.object(forKey: "workoutsName") as? [String] {
            arrayOfTitles = arrayTitles
        }
    }
    
    func retrieveDocumentsArray() {
        
        if let arrayTitleDocuments = UserDefaults.standard.object(forKey: "exercises") as? [String: [String]] {
            arrayTitleOfDocuments = arrayTitleDocuments
        }
    }
    
    func changeUnitFromKGtoLBInCalendar() {
     
        retrieveArrays()
        
        for title in arrayOfTitles {
            
            db.collection("users").document(user!.uid).collection("WorkoutsName").document(title).collection("Calendar").getDocuments { (result, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {

                    if let documents = result?.documents {
                        for doc in documents {
                            
                            let data = doc.data()
                            if let field = data["Volume"] as? Double, let weight = data["Weight"] as? Double {
                            let newVolume = (field * 2.2)
                            let volumeInLb = Double(String(format: "%.2f", newVolume))
                            let newWeight = weight * 2.2
                            let weightInLb = Double(String(format: "%.2f", newWeight))
                            doc.reference.updateData(["Volume" : volumeInLb!])
                            doc.reference.updateData(["Weight" : weightInLb!])
                                
                                print("new weight is \(newWeight)")
                            }
                        }
                }
            }

        }
    }
    }
    
    func changeUnitFromLBtoKGInCalendar() {
        print("STARTED 2")
        retrieveArrays()
        for title in arrayOfTitles {
            
            db.collection("users").document(user!.uid).collection("WorkoutsName").document(title).collection("Calendar").getDocuments { (result, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {

                    if let documents = result?.documents {
                        for doc in documents {
                            
                            let data = doc.data()
                            if let field = data["Volume"] as? Double, let weight = data["Weight"] as? Double {
                                
                            let newVolume = (field / 2.2)
                            let volumeInLb = Double(String(format: "%.1f", newVolume))
                            let newWeight = (weight / 2.2)
                            let weightInKg = Double(String(format: "%.1f", newWeight))
                            doc.reference.updateData(["Volume" : volumeInLb!])
                                doc.reference.updateData(["Weight" : weightInKg!])
                                
                                print("new is \(weightInKg!)")
                                
                            }

                        }
                }
            }

        }
    }
    }

   
    func changeUnitFromKGtoLBInHistory() {
      
      retrieveDocumentsArray()
     
        print("started second function")
        print("\(arrayTitleOfDocuments)")
        
            for (titleOfWorkout, titleOfDocument) in arrayTitleOfDocuments {
                dispatchGroup.enter()
                for value in titleOfDocument {
                    db.collection("users").document(user!.uid).collection("WorkoutsName").document(titleOfWorkout).collection("Exercises").document(value).collection("History").getDocuments { (result, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            if let documents = result?.documents {
                             
                                for doc in documents {
                                    let data = doc.data()
                                    if let max = data["Max"] as? [String:Double], let volume = data["Volume"] as? Double {
                                        if let maxWeight = max["weight"] {
                                            let newWeightInLb = (maxWeight * 2)
                                            let newMaxWeight = Double(String(format: "%.1f", newWeightInLb))
                                            
                                            let newVolumeInKg = (volume * 2)
                                            let newVolume = Double(String(format: "%.1f", newVolumeInKg))

                                            doc.reference.updateData(["Max.weight": newMaxWeight!])
//                                            doc.reference.updateData([max["weight"] : newMaxWeight!])
                                            doc.reference.updateData(["Volume": newVolume!])
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                }
                dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            print("FROM KG TO LB DONE")
        }
        }
    
    
    func changeUnitFromLBtoKGInHistory() {
        
   
        retrieveDocumentsArray()

        
        print("started second function")
        print("\(arrayTitleOfDocuments)")
            for (titleOfWorkout, titleOfDocument) in arrayTitleOfDocuments {
                dispatchGroup.enter()
                for value in titleOfDocument {
                    db.collection("users").document(user!.uid).collection("WorkoutsName").document(titleOfWorkout).collection("Exercises").document(value).collection("History").getDocuments { (result, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            if let documents = result?.documents {
                             
                                for doc in documents {
                                    let data = doc.data()
                                    if let max = data["Max"] as? [String:Double], let volume = data["Volume"] as? Double {
                                        if let maxWeight = max["weight"] {
                                            let newWeightInKg = (maxWeight / 2)
                                            let newMaxWeight = Double(String(format: "%.1f", newWeightInKg))
                                            
                                            let newVolumeInLb = (volume / 2)
                                            let newVolume = Double(String(format: "%.1f", newVolumeInLb))
                                            
                                            doc.reference.updateData(["Max.weight" : newMaxWeight!])
                                            doc.reference.updateData(["Volume" : newVolume!])
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                }
                dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            print("done from LB to KG")
        }
        }
        
    }
    
