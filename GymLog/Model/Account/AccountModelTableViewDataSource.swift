//
//  AccountModelTableViewDataSource.swift
//  GymLog
//
//  Created by Kacper P on 14/07/2021.
//

import UIKit

protocol AccountModelTableViewDelegate: class {
    func performSegueToEdit(selectedMainLabel: String, selectedSecondLabel: String)
}

protocol GetDataForAccountVC: class {
    func retrievedData(first: String, second: String)
}

class AccountModelTableViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate, AccountTableViewCellDelegate {
    
    private let accountModel = AccountModel()
    
    weak var delegate: AccountModelTableViewDelegate?
    weak var delegateToPassForVC: GetDataForAccountVC?
    
//    weak var cellDelegate: AccountTableViewCellDelegate?
    
    private let tableView: UITableView
    var dataArray: [AccountModelData] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    init(tableView: UITableView, delegate: AccountModelTableViewDelegate, delegateToPassForVC: GetDataForAccountVC) {
        self.tableView = tableView
        self.delegate = delegate
        self.delegateToPassForVC = delegateToPassForVC
        self.tableView.rowHeight = 87
        super.init()
        self.accountModel.didRecieveDataUpdate { (data) in
            self.dataArray = data
            print("data done")
        }

        setup()
    }
    
    func didTapButton(with title: String, with value: String) {
        print("TAPPED, title is \(title) and value is \(value)")
        delegateToPassForVC?.retrievedData(first: title, second: value)
    }
    
    private func setup() {
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataArray.count
    }
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountTableViewCell.identifier, for: indexPath) as? AccountTableViewCell else {
            return UITableViewCell(style: .default, reuseIdentifier: AccountTableViewCell.identifier)
        }
        cell.configureWithItem(item: dataArray[indexPath.item])
        cell.hideEditImage(indexPath: indexPath)
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("SELECTED")
        let selectedMainLabel = dataArray[indexPath.row].mainLabel
        let selectedSecondLabel = dataArray[indexPath.row].secondLabel
        delegate?.performSegueToEdit(selectedMainLabel: selectedMainLabel, selectedSecondLabel: selectedSecondLabel)
    }
}

//extension AccountModelTableViewDataSource: AccountModelDataDelegate {
//    func didRecieveDataUpdate(completion: @escaping ([AccountModelData]) -> Void) {
//
//    }
//
////    func didRecieveDataUpdate(data: [AccountModelData]) {
////        print("data is \(data)")
////        dataArray = data
////    }
//
//    func didFailDataUpdateWithError(error: Error) {
//        print("BUBUBU")
//    }
//
//
//}

//extension AccountModelTableViewDataSource: AccountTableViewCellDelegate {
//
//    func didTapButton(with title: String, with value: String) {
////        titleToEdit = title
////        valueToEdit = value
////        performSegue(withIdentifier: "toEditAccount", sender: nil)
//    }
//
//}
