//
//  AccountViewController.swift
//  GymLog
//
//  Created by Kacper P on 15/06/2021.
//

import UIKit
import Firebase

protocol AccountViewControllerDelegate: class {
    func passDataToEditAccount(mainLabel: String, secondLabel: String)
}

class AccountViewController: UIViewController {

    weak var passDataToEditAccount: AccountViewControllerDelegate?
    
    lazy var accountPresenter = AccountPresenter(accountService: AccountService(), accountPresenterDelegate: self)
    
    private var dataArray = [AccountModelData]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    var titleToEdit = String()
    var valueToEdit = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        accountPresenter.getDataArray()
     
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if (segue.identifier == "toEditAccount") {
   
            guard let editVC = segue.destination as? EditAccountViewController else { return }
            editVC.editAccountPresenter.editAccountModel = EditAccountModels(mainLabel: titleToEdit, secondLabel: valueToEdit)
            
                editVC.changedUsername = { newUsername in
                self.dataArray[0].secondLabel = newUsername
                }

               editVC.changedEmail = { newEmail in
                   self.dataArray[1].secondLabel = newEmail
               }
               }
           }
       }

extension AccountViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountTableViewCell.identifier, for: indexPath) as? AccountTableViewCell else {
            return UITableViewCell(style: .default, reuseIdentifier: AccountTableViewCell.identifier)
        }
        cell.configureWithItem(item: dataArray[indexPath.item])
        cell.hideEditImage(indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 87
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        titleToEdit = dataArray[indexPath.row].mainLabel
        valueToEdit = dataArray[indexPath.row].secondLabel
        performSegue(withIdentifier: "toEditAccount", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension AccountViewController: AccountPresenterDelegate {
    func updateDataArray(data: [AccountModelData]) {
        dataArray = data
    }
}


