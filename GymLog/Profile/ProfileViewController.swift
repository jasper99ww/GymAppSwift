//
//  ProfileViewController.swift
//  GymLog
//
//  Created by Barbara Podgórska on 25/03/2021.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    let minRowHeight: CGFloat = 45
    let firebaseAuth = Auth.auth()
   
    let supportViewController = SupportViewController()
    
    var arrayOfIcons: [String] = ["accountIcon", "workoutIcon", "bodyweightIcon-1", "supportIcon", "notificationIcon"]
    var labels: [String] = ["Account", "Workout", "Body weight", "Support", "Notifications"]
   
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var profilePhoto: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        setUpPhotoLayer()
        setUpCornerRadiusButton()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labels.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tableViewHeight = tableView.frame.height
        let temp = tableViewHeight / CGFloat(labels.count)
        return temp > minRowHeight ? temp : minRowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileTableViewCell
        
        cell.label.text = labels[indexPath.row]
        cell.imageIcon.image = UIImage(named: arrayOfIcons[indexPath.row])
        cell.delegate = self
        
        return cell
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

extension ProfileViewController: TitleOfSelectedRow {
    func didTapButton(with title: String) {
        switch title {
        case "Account":
            performSegue(withIdentifier: "toAccount", sender: self)
        case "Workout":
            performSegue(withIdentifier: "toWorkout", sender: self)
        case "Body weight":
            performSegue(withIdentifier: "toBodyWeight", sender: self)
        case "Support":
            print("tapped")
            
                supportViewController.showMailComposer(on: self) { result in
                    switch result {
                    case .failure(let error):
                        Alert.showBasicAlert(on: self, with: "Error", message: "There is an error during sending email: \(error.localizedDescription)")
                    case .success(.failed):
                        Alert.showBasicAlert(on: self, with: "Failed to send the e-mail!", message: "Cannot send the email")
                    case .success(.saved):
                        Alert.showBasicAlert(on: self, with: "Your email has been saved!", message: "")
                    case .success(.sent):
                        Alert.showBasicAlert(on: self, with: "Your email has been sent!", message: "")
                    default:
                        print("nothing changed")
                    }
                }
            
        case "Notifications":
            performSegue(withIdentifier: "toNotifications", sender: self)
        default:
            print("No vc to perform segue")
        }
    }
 
    
}
