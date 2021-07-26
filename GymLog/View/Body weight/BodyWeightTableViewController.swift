//
//  BodyWeightTableViewController.swift
//  GymLog
//
//  Created by Kacper P on 24/06/2021.
//

import UIKit

class BodyWeightTableViewController: UIViewController {
  
    lazy var bodyWeightPresenter = BodyWeightPresenter(bodyWeightPresenterDelegate: self)
    
    @IBOutlet weak var tableView: UITableView!

    private var dataArray = [BodyWeightModel]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bodyWeightPresenter.getModel()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 90
    }
}

extension BodyWeightTableViewController: BodyWeightPresenterDelegate {
    func getData(data: [BodyWeightModel]) {
        dataArray = data
    }
}
    
extension BodyWeightTableViewController: UITableViewDataSource, UITableViewDelegate {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return dataArray.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "bodyWeightCell", for: indexPath) as! BodyWeightTableViewCell

            cell.cellConfigure(item: dataArray[indexPath.row])
            return cell
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "toBodyWeightCalendar", sender: self)
        case 1:
            performSegue(withIdentifier: "toBodyWeightProgress", sender: self)
        case 2:
            performSegue(withIdentifier: "toCalories", sender: self)
        case 3:
            performSegue(withIdentifier: "toBMI", sender: self)
        default:
            print("No title in BodyWeightTableViewController")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
    

//
//extension BodyWeightTableViewController: TitleOfSelectedRow {
//    func didTapButton(with title: String) {
//        switch title {
//        case "Add new weight":
//            performSegue(withIdentifier: "toBodyWeightCalendar", sender: self)
//        case "Body weight progress":
//            performSegue(withIdentifier: "toBodyWeightProgress", sender: self)
//        case "BMI":
//            performSegue(withIdentifier: "toBMI", sender: self)
//        case "Calories":
//            performSegue(withIdentifier: "toCalories", sender: self)
//        default:
//            print("No title in BodyWeightTableViewController")
//        }
//    }
//
    

