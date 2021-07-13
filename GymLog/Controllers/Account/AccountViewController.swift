//
//  AccountViewController.swift
//  GymLog
//
//  Created by Kacper P on 15/06/2021.
//

import UIKit
import Firebase

class AccountViewController: UIViewController {
    
    private let accountModel = AccountModel()
    
    fileprivate var dataArray = [AccountModelData]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    var username: String = ""
    var email: String = ""
    var account: String = "FREE"
    var mainLabels: [String] = ["Username", "E-mail address", "Account"]
    var secondLabels: [String] = ["", "", ""]
    var imageIndex: Int?
    var titleToEdit: String = ""
    var valueToEdit: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        retrieveUserData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.dataSource = self
        tableView.delegate = self
        
        accountModel.delegate = self
        
        tableView.rowHeight = 87
        
    }
    
    func retrieveUserData() {
        print("STARTED")
        accountModel.getUserInfo()
    }
}

extension AccountViewController: AccountModelDataDelegate {
    func didRecieveDataUpdate(data: [AccountModelData]) {
        print("data is \(data)")
        dataArray = data
    }
    
    func didFailDataUpdateWithError(error: Error) {
        print("BUBUBU")
    }
    
    
}
    
    extension AccountViewController:  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: AccountTableViewCell.identifier, for: indexPath) as? AccountTableViewCell else {fatalError("Unexpected Table View Cell")}
        
        cell.configureWithItem(item: dataArray[indexPath.item])
        cell.hideEditImage(indexPath: indexPath)
        cell.delegate = self
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toEditAccount") {
       
            guard let editVC = segue.destination as? EditAccountViewController else { return }

            editVC.first = titleToEdit
            editVC.second = valueToEdit
                
            editVC.changedEmail = { newEmail in
                self.dataArray[1].secondLabel = newEmail
            }
            
            editVC.changedUsername = { newUsername in
                self.dataArray[0].mainLabel = newUsername
            }
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

//        print("email is \(accountModel.email)")
//
//        accountModel.getUserName { (user) in
//            self.username = user
//        }
//        profileService.getUserName { (text) in
//            self.username = text
//
//            DispatchQueue.main.async {
//                self.secondLabels = [self.username, self.email, "FREE"]
//                self.tableView.reloadData()
//            }
//
//        }
