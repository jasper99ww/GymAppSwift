//
//  NotificationViewController.swift
//  GymLog
//
//  Created by Kacper P on 09/07/2021.
//

import UIKit
import UserNotifications

class NotificationViewController: UIViewController {

    private let notificationPublisher = NotificationLocal()
    private let profileService = ProfileService()
    
    @IBOutlet weak var notificationTableView: UITableView!
    
    var mainLabel: [String] = ["Workout notification", "Notification after pause", "Notification with vibrations"]
    var secondLabel: [String] = ["Send notification in a workout day", "Send notification when pause is finished", "Send all notifications with vibrations"]
    
    var workoutsTitle: [String]? {
        guard let array = UserDefaults.standard.object(forKey: "workoutsName") as? [String] else { return nil}
        return array
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        notificationTableView.delegate = self
        notificationTableView.dataSource = self
        notificationTableView.rowHeight = 120
        
    }
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE h:mm a"
        
        switch sender.tag {
        case 0:
            if sender.isOn {
            if workoutsTitle != nil {
                profileService.getDayOfWorkoutForNotification(workoutTitles: workoutsTitle!) { (data) in
                
                    for day in data {
                      
                    guard let day2 = dateFormatter.date(from: day.day) else { return }
                    
                        //Make notification one hour before a training
                      let modifiedDate = Calendar.current.date(byAdding: .hour, value: -1, to: day2)
                        
                        let nowdata = Calendar.current.dateComponents([.weekday, .hour, .minute], from: modifiedDate!)
                        
                        self.notificationPublisher.createNotification(title: "Workout!", body: "You've got a \(day.workout) training today", badge: 1, at: nowdata, id: day.day)
                        print("OKI")
                    }
                }
            }
            } else {
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            }
        case 1:
            print("second row selected")
//            notificationPublisher.createNotificationAfterPause(title: "Pause finished", body: "Yo! Your pause is finished, come back to training!", delayInterval: <#T##Int?#>)
            if sender.isOn {
            UserDefaults.standard.set(true, forKey: "pauseNotification")
            } else {
            UserDefaults.standard.set(false, forKey: "pauseNotification")
            }
        case 2:
            print("third row selected")
            print("BRRRRRRRRRR")
        default:
            print("default switch tag")
        }
        
    }
    
//    func notification() {
//        let center = UNUserNotificationCenter.current()
//
//        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
//
//        }
//
//        let content = UNMutableNotificationContent()
//        content.title = "HEY ITS TEST NOTIFICATION!"
//        content.body = "TEST BODY"
//
//
//        let date = Date().addingTimeInterval(10)
//
//        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
//
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
//
//        let uuidString = UUID().uuidString
//
//        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
//
//        center.add(request) { (error) in
//            // Check the error parameter and handle any errors
//
//        }
//    }
    
    
    
}

extension NotificationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainLabel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = notificationTableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! NotificationTableViewCell
        
        
        cell.notificationMainLabel.text = mainLabel[indexPath.row]
        cell.notificationSecondLabel.text = secondLabel[indexPath.row]
        cell.notificationSwitch.tag = indexPath.row
    
        return cell
    }
    
    
    
    
}
