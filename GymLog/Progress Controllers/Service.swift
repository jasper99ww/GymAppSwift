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
    var exercisesForWorkout: [String : [String]] = [:]
    var workouts: [WorkoutsTitle] = []
    var workoutsName: [String] = []
    
    var formatter = DateFormatter()
    
    var newDictionaryByVolume: [String: [DoneWorkoutInformation]] = [:]
    var newArrayByExercise: [DoneExercise] = []
    var newDictionaryForAllExercises: [String : [RetrievedWorkoutMax]] = [:]

    var dispatchGroup = DispatchGroup()
    
    
    func getExercisesForWorkouts(arrayOfTitles: [String], completionHandler: @escaping([String : [String]]) -> Void)
    
    {
        exercisesForWorkout = [:]
       
        for title in arrayOfTitles {
            dispatchGroup.enter()
        db.collection("users").document("\(user!.uid)").collection("WorkoutsName").document("\(title)").collection("Exercises").getDocuments { (querySnapshot, error) in
                        
            if let error = error {
                print("\(error.localizedDescription)")
            }
            else {
                if let documents = querySnapshot?.documents {
                  
                    for i in 0..<documents.count {
                        let documentID2 = documents[i].documentID
                        
                        self.exercisesForWorkout[title, default: []].append(documentID2)
                    }
                    self.dispatchGroup.leave()
                }
            }
        }
    }
        dispatchGroup.notify(queue: DispatchQueue.main) {
            completionHandler(self.exercisesForWorkout)
            print("exercises for workout from service \(self.exercisesForWorkout)")
        }
        
    }
    
    
    func getDocumentForOneWorkout(workout: String, completion: @escaping (_ result: [String]) -> ()) {
        
        exercises = []
        
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

                               })
    
                       }
    
    
    //MARK: - HOME VIEW CONTROLLER
    
    func retrieveWorkoutTitle(completionHandler: @escaping([WorkoutsTitle], [String]) -> Void) {
        
        workouts = []
        workoutsName = []
        
        db.collection("users").document("\(user!.uid)").collection("WorkoutsName").getDocuments(completion: { (querySnapshot, error) in
            self.dispatchGroup.enter()
            if let error = error
                       {
                           print("\(error.localizedDescription)")
                       }
                       else {
                           if let snapshotDocuments = querySnapshot?.documents {
                               for doc in snapshotDocuments {
                              
                                   let data = doc.data()
                                   if let workoutTitle = data["workoutTitle"] as? String, let workoutDay = data["workoutDay"] as? String {
           
                                    let newTitle = WorkoutsTitle(workoutTitle: workoutTitle, workoutDay: workoutDay)
           
                                        self.workouts.append(newTitle)
                                    self.workoutsName.append(workoutTitle)
                           print("new tile \(newTitle)")
                              
                                   }
                              
                                   }
                            self.dispatchGroup.leave()
                            self.dispatchGroup.notify(queue: .main) {
                                completionHandler(self.workouts, self.workoutsName)
                            }
                               }
                       }
        })
 
        
    }
    
    //MARK: - CALENDAR CONTROLLER
    
    
   
    //MARK: - PROGRESS CONTROLLER
    func getDataByVolume(titles: [String], completionHandler: @escaping([String: [DoneWorkoutInformation]]) -> Void) {
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.timeZone = TimeZone.current
        newDictionaryByVolume = [:]
       print("titles to \(titles)")
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
                            
                            if let volume = data["Volume"] as? Double, let reps = data["Reps"] as? Int, let time = data["Time"] as? String, let weight = data["Weight"] as? Double {

                                let dateDocumentID = self.formatter.date(from: doc.documentID)
            
                                guard let dateConverted = dateDocumentID?.removeTimeStamp else {return}
       
                                let newData = DoneWorkoutInformation(sets: 0, reps: reps, time: time, volume: volume, weight: weight, date: dateConverted)
  
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
    
    
    func getDataByExercise(title: String, document: String, completionHandler: @escaping([DoneExercise]) -> Void) {
        
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
                        
                        if let docSets = data["Sets"] as? [String: [String:String]], let max = data["Max"] as? [String:Double] {
                            
                            if let date = data["date"] as? String, let maxWeight = max["weight"] , let maxReps = max["doneReps"], let volume = data["Volume"] as? Double {
                                
                                guard let dateFormattedToDate = self.formatter.date(from: date) else {return}
                               
                                let newModel = DoneExercise(exerciseTitle: "\(document)", sets: docSets.count, weight: maxWeight, reps: Int(maxReps), date: dateFormattedToDate, volume: volume)
                            
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
            print("new array by exercise \(self.newArrayByExercise)")
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
        
                        if let docSets = data["Sets"] as? [String: [String:String]], let max = data["Max"] as? [String:Double] {
                            
                            if let date = data["date"] as? String, let maxWeight = max["weight"] , let maxReps = max["doneReps"], let volume = data["Volume"] as? Double {
                                
                                guard let dateFormattedToDate = self.formatter.date(from: date) else {return}
                               
                                let newModelMax = RetrievedWorkoutMax(workoutTitle: title, exerciseTitle: document, sets: (docSets.count), weight: maxWeight, reps: Int(maxReps),date: dateFormattedToDate, volume: volume)

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

//extension UIView {
//    func fadeTransition(_ duration: CFTimeInterval) {
//        let animation = CATransition()
//        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//        animation.type = CATransitionType.fade
//        animation.duration = duration
//        layer.add(animation, forKey: CATransitionType.fade.rawValue)
//    }
//}

        
        
    
    

