//
//  UnitClass.swift
//  GymLog
//
//  Created by Kacper P on 20/06/2021.
//

import Foundation

protocol DataInHistoryServiceProtocol {
    func changeUnitFromKGtoLBInHistory()
    func changeUnitFromLBtoKGInHistory()
}

protocol DataInCalendarServiceProtocol {
    func changeUnitFromKGtoLBInCalendar()
    func changeUnitFromLBtoKGInCalendar()
}


class WorkoutSettingsService {

    var arrayOfTitles: [String] = []
    var arrayTitleOfDocuments: [String: [String]] = [:]
    var arrayOfCalendarDocuments: [String] = []
    var dispatchGroup = DispatchGroup()
    
    init() {
        retrieveArrays()
        retrieveDocumentsArray()
    }
    
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
}

extension WorkoutSettingsService:  DataInHistoryServiceProtocol, DataInCalendarServiceProtocol {
    
    func changeUnitFromKGtoLBInHistory() {
       
        guard let currentUser = Firebase.userUID else { return }
       
               for title in arrayOfTitles {
       
                   Firebase.db.collection("users").document(currentUser).collection("WorkoutsName").document(title).collection("Calendar").getDocuments { (result, error) in
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
                                   }
                               }
                       }
                   }
               }
           }
    }
    
    func changeUnitFromLBtoKGInHistory() {

              guard let currentUser = Firebase.userUID else { return }
      
              for title in arrayOfTitles {
      
                  Firebase.db.collection("users").document(currentUser).collection("WorkoutsName").document(title).collection("Calendar").getDocuments { (result, error) in
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
                                  }
                              }
                      }
                  }
              }
          }
    }
    
    func changeUnitFromKGtoLBInCalendar() {

                guard let currentUser = Firebase.userUID else { return }
        
                for title in arrayOfTitles {
        
                    Firebase.db.collection("users").document(currentUser).collection("WorkoutsName").document(title).collection("Calendar").getDocuments { (result, error) in
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
                                    }
                                }
                        }
                    }
                }
            }
    }
    
    func changeUnitFromLBtoKGInCalendar() {

                guard let currentUser = Firebase.userUID else { return }
        
                for title in arrayOfTitles {
        
                    Firebase.db.collection("users").document(currentUser).collection("WorkoutsName").document(title).collection("Calendar").getDocuments { (result, error) in
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
        
                                    }
        
                                }
                        }
                    }
        
                }
            }
    }
}
    
//    func changeUnitFromKGtoLBInCalendar() {
//
//
//        retrieveArrays()
//
//        guard let currentUser = Firebase.userUID else { return }
//
//        for title in arrayOfTitles {
//
//            Firebase.db.collection("users").document(currentUser).collection("WorkoutsName").document(title).collection("Calendar").getDocuments { (result, error) in
//                if let error = error {
//                    print(error.localizedDescription)
//                } else {
//
//                    if let documents = result?.documents {
//                        for doc in documents {
//
//                            let data = doc.data()
//                            if let field = data["Volume"] as? Double, let weight = data["Weight"] as? Double {
//                            let newVolume = (field * 2.2)
//                            let volumeInLb = Double(String(format: "%.2f", newVolume))
//                            let newWeight = weight * 2.2
//                            let weightInLb = Double(String(format: "%.2f", newWeight))
//                            doc.reference.updateData(["Volume" : volumeInLb!])
//                            doc.reference.updateData(["Weight" : weightInLb!])
//
//                                print("new weight is \(newWeight)")
//                            }
//                        }
//                }
//            }
//
//        }
//    }
//    }
//
//    func changeUnitFromLBtoKGInCalendar() {
//
//        retrieveArrays()
//
//        guard let currentUser = Firebase.userUID else { return }
//
//        for title in arrayOfTitles {
//
//            Firebase.db.collection("users").document(currentUser).collection("WorkoutsName").document(title).collection("Calendar").getDocuments { (result, error) in
//                if let error = error {
//                    print(error.localizedDescription)
//                } else {
//
//                    if let documents = result?.documents {
//                        for doc in documents {
//
//                            let data = doc.data()
//                            if let field = data["Volume"] as? Double, let weight = data["Weight"] as? Double {
//
//                            let newVolume = (field / 2.2)
//                            let volumeInLb = Double(String(format: "%.1f", newVolume))
//                            let newWeight = (weight / 2.2)
//                            let weightInKg = Double(String(format: "%.1f", newWeight))
//                            doc.reference.updateData(["Volume" : volumeInLb!])
//                                doc.reference.updateData(["Weight" : weightInKg!])
//
//                                print("new is \(weightInKg!)")
//
//                            }
//
//                        }
//                }
//            }
//
//        }
//    }
//    }
//
//
//    func changeUnitFromKGtoLBInHistory() {
//
//      retrieveDocumentsArray()
//
//        guard let currentUser = Firebase.userUID else { return }
//
//            for (titleOfWorkout, titleOfDocument) in arrayTitleOfDocuments {
//                dispatchGroup.enter()
//                for value in titleOfDocument {
//                    Firebase.db.collection("users").document(currentUser).collection("WorkoutsName").document(titleOfWorkout).collection("Exercises").document(value).collection("History").getDocuments { (result, error) in
//                        if let error = error {
//                            print(error.localizedDescription)
//                        } else {
//                            if let documents = result?.documents {
//
//                                for doc in documents {
//                                    let data = doc.data()
//                                    if let max = data["Max"] as? [String:Double], let volume = data["Volume"] as? Double {
//                                        if let maxWeight = max["weight"] {
//                                            let newWeightInLb = (maxWeight * 2)
//                                            let newMaxWeight = Double(String(format: "%.1f", newWeightInLb))
//
//                                            let newVolumeInKg = (volume * 2)
//                                            let newVolume = Double(String(format: "%.1f", newVolumeInKg))
//
//                                            doc.reference.updateData(["Max.weight": newMaxWeight!])
////                                            doc.reference.updateData([max["weight"] : newMaxWeight!])
//                                            doc.reference.updateData(["Volume": newVolume!])
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//
//                }
//                dispatchGroup.leave()
//        }
//        dispatchGroup.notify(queue: .main) {
//            print("FROM KG TO LB DONE")
//        }
//        }
//
//
//    func changeUnitFromLBtoKGInHistory() {
//
//
//        retrieveDocumentsArray()
//
//        guard let currentUser = Firebase.userUID else { return }
//
//            for (titleOfWorkout, titleOfDocument) in arrayTitleOfDocuments {
//                dispatchGroup.enter()
//                for value in titleOfDocument {
//                    Firebase.db.collection("users").document(currentUser).collection("WorkoutsName").document(titleOfWorkout).collection("Exercises").document(value).collection("History").getDocuments { (result, error) in
//                        if let error = error {
//                            print(error.localizedDescription)
//                        } else {
//                            if let documents = result?.documents {
//
//                                for doc in documents {
//                                    let data = doc.data()
//                                    if let max = data["Max"] as? [String:Double], let volume = data["Volume"] as? Double {
//                                        if let maxWeight = max["weight"] {
//                                            let newWeightInKg = (maxWeight / 2)
//                                            let newMaxWeight = Double(String(format: "%.1f", newWeightInKg))
//
//                                            let newVolumeInLb = (volume / 2)
//                                            let newVolume = Double(String(format: "%.1f", newVolumeInLb))
//
//                                            doc.reference.updateData(["Max.weight" : newMaxWeight!])
//                                            doc.reference.updateData(["Volume" : newVolume!])
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//
//                }
//                dispatchGroup.leave()
//        }
//        dispatchGroup.notify(queue: .main) {
//            print("done from LB to KG")
//        }
//        }
//
//    }
//
