//
//  Service.swift
//  GymLog
//
//  Created by Kacper P on 29/05/2021.
//

import Foundation
import Firebase
import UIKit

class Service {
    
    let db = Firestore.firestore()
    
    let user = Auth.auth().currentUser
    
    var exercises: [String] = []
    
    var formatter = DateFormatter()
       
     
    
    var newDictionaryByVolume: [String: [RetrievedWorkoutsByVolume]] = [:]
    var newArrayByExercise: [RetrievedWorkoutsByExercise] = []
    var newDictionaryForAllExercises: [String : [RetrievedWorkoutMax]] = [:]

    var dispatchGroup = DispatchGroup()
    
    
    func getDocumentsTitle(workout: String, completion: @escaping (_ result: [String]) -> ()) {
        
        db.collection("users").document("\(user!.uid)").collection("WorkoutsName").document(workout).collection("Exercises").getDocuments(completion: { (querySnapshot, error) in
            
            if let error = error
                       {
                           print("\(error.localizedDescription)")
                       }
                       else {
                           if let snapshotDocuments = querySnapshot?.documents {
                               for doc in snapshotDocuments {
                                
                                let exercise = doc.documentID
                                self.exercises.append(exercise)
                                print("DONE")
                                       }
                                }
                               
                                   }
            completion(self.exercises)
            print("EXEr \(self.exercises)")
                               })
    
                       }
    
    func getDataByVolume(titles: [String], completionHandler: @escaping([String: [RetrievedWorkoutsByVolume]]) -> Void) {
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.timeZone = TimeZone.current
        newDictionaryByVolume = [:]
       
        for title in titles {
            dispatchGroup.enter()
            db.collection("users").document("\(user!.uid)").collection("WorkoutsName").document("\(title)").collection("Calendar").getDocuments(completion:  { (querySnapshot, error) in
                if let error = error {
                    print("\(error.localizedDescription)")
                }
                else {
                    if let documents = querySnapshot?.documents {
                        
                        for doc in documents {
                            
                            let data = doc.data()
                            
                            if let volume = data["Volume"] as? Int, let reps = data["Reps"] as? Int, let time = data["Time"] as? String, let weight = data["Weight"] as? Int {

                                let dateDocumentID = self.formatter.date(from: doc.documentID)
            
                                guard let dateConverted = dateDocumentID?.removeTimeStamp else {return}
       
                                let newData = RetrievedWorkoutsByVolume(reps: reps, time: time, volume: volume, weight: weight, date: dateConverted)
  
                                    self.newDictionaryByVolume["\(title)", default: []].append(newData)
        
                                
                            }
                        }
                    }
                    self.dispatchGroup.leave()
                }
            })
            }
        dispatchGroup.notify(queue: .main) {
        completionHandler(self.newDictionaryByVolume)
        }
    }
    
    
    func getDataByExercise(title: String, document: String, completionHandler: @escaping([RetrievedWorkoutsByExercise]) -> Void) {
        
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        newArrayByExercise = []
        
        dispatchGroup.enter()
        db.collection("users").document("\(user!.uid)").collection("WorkoutsName").document(title).collection("Exercises").document(document).collection("History").getDocuments(completion:  { (querySnapshot, error) in
            if let error = error {
                print("\(error.localizedDescription)")
            }
            else {
                
                if let documents = querySnapshot?.documents {
                   
                    for doc in documents {
                        
                        let data = doc.data()
                        
                        if let docSets = data["Sets"] as? [String: [String:String]], let max = data["Max"] as? [String:Int] {
                            
                            if let date = data["date"] as? String, let maxWeight = max["weight"] , let maxReps = max["doneReps"], let volume = data["Volume"] as? Int {
                                
                                guard let dateFormattedToDate = self.formatter.date(from: date) else {return}
                               
                                let newModel = RetrievedWorkoutsByExercise(exerciseTitle: "\(document)", sets: docSets.count, maxWeight: maxWeight, maxReps: maxReps, date: dateFormattedToDate, volume: volume)
                            
                                self.newArrayByExercise.append(newModel)
                    }
                }
            }
        }
                self.dispatchGroup.leave()
            }
        })
        dispatchGroup.notify(queue: .main) {
            completionHandler(self.newArrayByExercise)
        }
    }
    
    func getAllExercisesInWorkout(title: String, arrayOfDocuments: [String : [String]], completionHandler: @escaping([String : [RetrievedWorkoutMax]]) -> Void) {
        
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        newDictionaryForAllExercises = [:]
        
        for document in arrayOfDocuments[title]! {
            dispatchGroup.enter()
        db.collection("users").document("\(user!.uid)").collection("WorkoutsName").document("\(title)").collection("Exercises").document("\(document)").collection("History").getDocuments(completion:  { (querySnapshot, error) in
            if let error = error {
                print("\(error.localizedDescription)")
            }
            else {
                if let documents = querySnapshot?.documents {
                    
                    for doc in documents {
                    
                        let data = doc.data()
        
                        if let docSets = data["Sets"] as? [String: [String:String]], let max = data["Max"] as? [String:Int] {
                            
                            if let date = data["date"] as? String, let maxWeight = max["weight"] , let maxReps = max["doneReps"], let volume = data["Volume"] as? Int {
                                
                                guard let dateFormattedToDate = self.formatter.date(from: date) else {return}
                               
                                let newModelMax = RetrievedWorkoutMax(workoutTitle: title, exerciseTitle: "\(document)", sets: (docSets.count), maxWeight: maxWeight, maxReps: maxReps,date: dateFormattedToDate, volume: volume)

                                self.newDictionaryForAllExercises["\(document)", default: []].append(newModelMax)

                            }
                            }
                        }
        }
                self.dispatchGroup.leave()
    }
})
}
        dispatchGroup.notify(queue: .main) {
            completionHandler(self.newDictionaryForAllExercises)
            print("TO WYSZLO \(self.newDictionaryForAllExercises)")
            }
    }
            
    }

extension UIView {
    func fadeTransition(_ duration: CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}

        
        
    
    

