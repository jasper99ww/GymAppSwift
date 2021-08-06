//
//  ProfilePresenter.swift
//  GymLog
//
//  Created by Kacper P on 04/08/2021.
//

import Foundation
import Firebase

protocol ProfilePresenterDelegate: class {
    func setProfileData(profileData: [ProfileModel])
    func logoutAlert()
    func performSegue(identifier: String)
    func showSupportVC()
}

class ProfilePresenter {
    
    let service = ProfileMainService()
    let firebaseAuth = Auth.auth()
    
    let supportClass = SupportClass()
    
    weak var profilePresenterDelegate: ProfilePresenterDelegate?
    
    init(profilePresenterDelegate: ProfilePresenterDelegate) {
        self.profilePresenterDelegate = profilePresenterDelegate
    }
    
    func getProfileData() {
        let data = service.getProfileModel()
        profilePresenterDelegate?.setProfileData(profileData: data)
    }
    
    func alertLogOut(confirmation: String) {
        if confirmation == "Yes" {
            do {
                try self.firebaseAuth.signOut()
                profilePresenterDelegate?.logoutAlert()
            }
            catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
        }
    }
    
    func performSegue(indexPathRow: Int) {
        switch indexPathRow {
        case 0:
            profilePresenterDelegate?.performSegue(identifier: ProfileIdentifiers.account)
        case 1:
            profilePresenterDelegate?.performSegue(identifier: ProfileIdentifiers.workout)
        case 2:
            profilePresenterDelegate?.performSegue(identifier: ProfileIdentifiers.bodyWeight)
        case 3:
            profilePresenterDelegate?.showSupportVC()
        case 4:
            profilePresenterDelegate?.performSegue(identifier: ProfileIdentifiers.notification)
        default:
            print("No title in BodyWeightTableViewController")
        }
    }
    
    func showSupportAlert(vc: UIViewController) {
        supportClass.showMailComposer(on: vc) { result in
            switch result {
            case .failure(let error):
                Alert.showBasicAlert(on: vc, with: "Error", message: "There is an error during sending email: \(error.localizedDescription)", handler: nil)
            case .success(.failed):
                Alert.showBasicAlert(on: vc, with: "Failed to send the e-mail!", message: "Cannot send the email", handler: nil)
            case .success(.saved):
                Alert.showBasicAlert(on: vc, with: "Your email has been saved!", message: "", handler: nil)
            case .success(.sent):
                Alert.showBasicAlert(on: vc, with: "Your email has been sent!", message: "", handler: nil)
            default:
                print("nothing changed")
            }
        }
    }
}
