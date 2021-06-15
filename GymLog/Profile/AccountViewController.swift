//
//  AccountViewController.swift
//  GymLog
//
//  Created by Kacper P on 15/06/2021.
//

import UIKit
import Firebase

class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let profileService = ProfileService()
    @IBOutlet weak var tableView: UITableView!
    var username: String = ""
    var email: String = ""
    var account: String = "FREE"
    var mainLabels: [String] = ["Username", "E-mail address", "Account"]
    var secondLabels: [String] = ["", "", "FREE"]
    var imageIndex: Int?
    var titleToEdit: String = ""
    var valueToEdit: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        retrieveUserData()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = 87
        
    }
    
    func retrieveUserData() {
        
        if let addressEmail = Auth.auth().currentUser?.email {
            self.email = addressEmail
            
        }
        
        profileService.getUserName { (text) in
            self.username = text
            
            DispatchQueue.main.async {
                self.secondLabels = [self.username, self.email, "FREE"]
                self.tableView.reloadData()
            }
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainLabels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as! AccountTableViewCell
        
        cell.mainLabel.text = mainLabels[indexPath.row]
        cell.secondLabel.text = secondLabels[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toEditAccount") {
            print("OPEN")
            if let editVC = segue.destination as? EditAccountViewController {
                print("title to edit \(titleToEdit)")
                editVC.first = titleToEdit
                editVC.second = valueToEdit
            }
        }
    }
}

extension AccountViewController: AccountTableViewCellDelegate {
    func didTapButton(with title: String, with value: String) {
        print("TADAM")
        titleToEdit = title
        valueToEdit = value
        performSegue(withIdentifier: "toEditAccount", sender: nil)
    }
  
}
