//
//  NotificationViewController.swift
//  GymLog
//
//  Created by Kacper P on 09/07/2021.
//

import UIKit
import UserNotifications

class NotificationViewController: UIViewController {

    lazy var presenter = NotificationPresenter(notificationPresenterDelegate: self)
    
    private let notificationPublisher = NotificationLocal()
    private let profileService = ProfileService()
    
    @IBOutlet weak var notificationTableView: UITableView!
    
    var tableViewData = [NotificationModel]() {
        didSet {
            DispatchQueue.main.async {
                self.notificationTableView.reloadData()
            }
        }
    }
 
    var workoutsTitle: [String]? {
        guard let array = UserDefaults.standard.object(forKey: "workoutsName") as? [String] else { return nil}
        return array
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.getModel()
        notificationTableView.delegate = self
        notificationTableView.dataSource = self
        notificationTableView.rowHeight = 120
        
    }
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        presenter.uiSwitchChanged(senderTag: sender.tag, senderIsOn: sender.isOn)
    }
}

extension NotificationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = notificationTableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! NotificationTableViewCell
        
        cell.notificationMainLabel.text = tableViewData[indexPath.row].mainLabel
        cell.notificationSecondLabel.text = tableViewData[indexPath.row].secondLabel
        cell.notificationSwitch.tag = indexPath.row
    
        return cell
    }
}

extension NotificationViewController: NotificationPresenterDelegate {
    func showNotificationInformation() {
        Alert.showBasicAlert(on: self, with: "Notification has been set", message: "You will get notifications one hour before training", handler: nil)
    }
    
    func getNotificationModel(data: [NotificationModel]) {
        tableViewData = data
    }
}
