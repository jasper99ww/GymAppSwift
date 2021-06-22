//
//  StartService.swift
//  GymLog
//
//  Created by Kacper P on 22/06/2021.
//

import Foundation
import Firebase
import UIKit

struct LastTraining {
    
    let number: String
    let kg: String
    let reps: String
    
}

class StartService {
    
    let db = Firestore.firestore()
    
    let user = Auth.auth().currentUser
    
    var models : [DataCell] = []
    var lastTrainingArray: [String: [LastTraining]] = [:]
    
    let dispatchGroup = DispatchGroup()

    func retrieveWorkout(titleValue: String, completionHandler: @escaping([DataCell]) -> ()) {
        
        db.collection("users").document("\(user!.uid)").collection("WorkoutsName").document(titleValue).collection("Exercises").order(by: "Number").getDocuments { (querySnapshot, error) in
            if let error = error
                       {
                           print("\(error.localizedDescription)")
                       }
                       else {
                           if let snapshotDocuments = querySnapshot?.documents {
                               for doc in snapshotDocuments {
           
                                   let data = doc.data()
                                   if let numberDb = data["Number"] as? String, let exerciseDb = data["Exercise"] as? String, let kgDb = data["kg"] as? String, let setsDb = data["Sets"] as? String, let repsDb = data["Reps"] as? String, let workoutName = data["workoutName"] as? String {
           
                                       let newModel = DataCell(Number: numberDb, Exercise: exerciseDb, kg: kgDb, sets: setsDb, reps: repsDb, workoutName: workoutName)
           
                                       self.models.append(newModel)
           
                                       }
                                   }
                               }
                           }
        
    }
        completionHandler(models)
        print("done")
        
    }
    
    func getLastTraining(titleValue: String, exercises: [String: [String]], completionHandler: @escaping([String: [LastTraining]]) -> ()) {
       
        
        if let exercise = exercises[titleValue], let user = user?.uid {
        for value in exercise {
            dispatchGroup.enter()
            db.collection("users").document(user).collection("WorkoutsName").document(titleValue).collection("Exercises").document(value).collection("History").order(by: "date", descending: true).limit(to: 1).getDocuments { (result, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        
                        if let document = result?.documents {
                            
                            for doc in document {
                               let lastData = doc.data()
                                
                                if let sets = lastData["Sets"] as? [String : [String:String]] {
                                    print("sets are \(sets)")

                                    for (key,values) in sets {
                                       
                                        if let kg = values["kg"], let reps = values["reps"] {
                                            let newModel = LastTraining(number: key, kg: kg, reps: reps)
                                            self.lastTrainingArray[value, default: []].append(newModel)
                                        }
                                    }
                                }
                            }
                            self.dispatchGroup.leave()
                        }
                        
                    }
                }
            
                }
        }
        dispatchGroup.notify(queue: .main) {
            completionHandler(self.lastTrainingArray)
          
       
        }
    }
    
    
}
