//
//  NotificationService.swift
//  GymLog
//
//  Created by Kacper P on 06/08/2021.
//

import Foundation
import Firebase

class NotificationService {
    
    let dispatchGroup = DispatchGroup()
    
    func getDayOfWorkoutForNotification(workoutTitles: [String], completionHandler: @escaping([DataForNotification]) -> ()) {
        
        guard let userUID = Firebase.userUID else { return }
        
        var arrayOfDay: [DataForNotification] = []
        
        for workoutTitle in workoutTitles {
            dispatchGroup.enter()
            Firebase.db.collection("users").document(userUID).collection("WorkoutsName").document(workoutTitle).getDocument { (document, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let document = document, document.exists {
                    let documentData = document["workoutDay"] as! String
                    let newModel = DataForNotification(day: documentData, workout: workoutTitle)
                    arrayOfDay.append(newModel)
                }
            }
            self.dispatchGroup.leave()
        }
       
    }
        dispatchGroup.notify(queue: .main) {
            print("array is \(arrayOfDay)")
            completionHandler(arrayOfDay)
        }
        
    }
    
}
