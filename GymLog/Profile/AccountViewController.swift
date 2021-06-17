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
    
//    override func viewWillAppear(_ animated: Bool) {

//    }
    
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
       
            guard let editVC = segue.destination as? EditAccountViewController else { return }

                editVC.first = titleToEdit
                editVC.second = valueToEdit
                
            editVC.changedEmail = { text in

                    self.secondLabels[1] = text

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
//            editVC.changedValueDelegate = self
            }
        }
    }


extension AccountViewController: AccountTableViewCellDelegate {
    func didTapButton(with title: String, with value: String) {
        titleToEdit = title
        valueToEdit = value
        performSegue(withIdentifier: "toEditAccount", sender: nil)
    }
  
}

extension AccountViewController: ChangedValueDelegate {
    
    func didChangeValue(value: String) {
        if titleToEdit == "Username" {
            self.secondLabels[0] = value
        } else {
            self.secondLabels[1] = value
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
}
