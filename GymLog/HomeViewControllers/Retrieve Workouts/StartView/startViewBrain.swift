//
//  startViewBrain.swift
//  GymLog
//
//  Created by Barbara Podgórska on 05/04/2021.
//

import Foundation
import Firebase

struct StartViewBrain {
    
    var exerciseNumber = 0
    
    var models: [DataCell] = []
    
    let user = Auth.auth().currentUser
    
    var db = Firestore.firestore()
    
    var titleValue: String = ""
    
    var dayOfWorkout: String = ""
    
    
    
    
}
