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
}

        
        
    
    

