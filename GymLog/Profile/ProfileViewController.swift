//
//  ProfileViewController.swift
//  GymLog
//
//  Created by Barbara Podgórska on 25/03/2021.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    @IBAction func logOutButton(_ sender: Any) {
        
        logOutUser()
    }
  
    func logOutUser() {
      
        try! Auth.auth().signOut()
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(identifier: "main") as! MainViewController
            self.present(vc, animated: false, completion: nil)
        }

}
}
