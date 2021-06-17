//
//  ProfileViewController.swift
//  GymLog
//
//  Created by Barbara Podgórska on 25/03/2021.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    let firebaseAuth = Auth.auth()
    
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var resetAccountButton: UILabel!
    
    
    @IBOutlet weak var accountButton: UIButton!
    @IBOutlet weak var workoutButton: UIButton!
    @IBOutlet weak var bodyWeightButton: UIButton!
    @IBOutlet weak var supportButton: UIButton!
    @IBOutlet weak var notificationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpPhotoLayer()
        setUpCornerRadiusButton()
    }
    
    func setUpPhotoLayer() {
        profilePhoto.layer.borderWidth = 1.0
        profilePhoto.layer.masksToBounds = false
        profilePhoto.layer.cornerRadius = profilePhoto.frame.size.width / 2
        profilePhoto.clipsToBounds = true
    }
    
    func setUpCornerRadiusButton() {
        logoutButton.layer.cornerRadius = 20
    }
     
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        func alertBeforeLogOut() {
            Alert.showBeforeLogOut(on: self) { (text) in
                if text == "Yes" {
                    do {
                        try self.firebaseAuth.signOut()
                        self.navigationController?.navigationController?.popToRootViewController(animated: true)
                    }
                    catch let signOutError as NSError {
                        print("Error signing out: %@", signOutError)
                    }
                }
            }
        }
    }
    
    
    
}
