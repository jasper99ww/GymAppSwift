//
//  AccountViewController.swift
//  GymLog
//
//  Created by Kacper P on 15/06/2021.
//

import UIKit
import Firebase

class AccountViewController: UIViewController {

    var titleToEdit = String()
    var valueToEdit = String()
    
    
    fileprivate var dataArray = [AccountModelData]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    var tableViewDataSource: AccountModelTableViewDataSource?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.rowHeight = 87
//        accountModel.delegate = self
        setUp()
     
    }
 
    
    func setUp() {
        tableViewDataSource = AccountModelTableViewDataSource(tableView: tableView, delegate: self, delegateToPassForVC: self)
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

extension AccountViewController: GetDataForAccountVC {
    func retrievedData(first: String, second: String) {
        print("first is \(first) and second is \(second)")
        titleToEdit = first
        valueToEdit = second
        performSegue(withIdentifier: "toEditAccount", sender: nil)
    }
    
    
}

extension AccountViewController: AccountModelTableViewDelegate {
    func performSegueToEdit(selectedMainLabel: String, selectedSecondLabel: String) {
        titleToEdit = selectedMainLabel
        valueToEdit = selectedSecondLabel
        print("titletoedit \(titleToEdit) a valueToEdit \(valueToEdit)")
        performSegue(withIdentifier: "toEditAccount", sender: nil)
    }
}

    
//    extension AccountViewController:  UITableViewDelegate, UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return dataArray.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: AccountTableViewCell.identifier, for: indexPath) as? AccountTableViewCell else {fatalError("Unexpected Table View Cell")}
//
//        cell.configureWithItem(item: dataArray[indexPath.item])
//        cell.hideEditImage(indexPath: indexPath)
//        cell.delegate = self
//
//        return cell
//    }
//
//

//
//extension AccountViewController: AccountTableViewCellDelegate {
//
//    func didTapButton(with title: String, with value: String) {
//        titleToEdit = title
//        valueToEdit = value
//        performSegue(withIdentifier: "toEditAccount", sender: nil)
//    }
//
//}


