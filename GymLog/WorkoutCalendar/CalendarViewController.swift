//
//  CalendarViewController.swift
//  GymLog
//
//  Created by Barbara Podgórska on 25/04/2021.
//

import UIKit
import FSCalendar


class CalendarViewController: UIViewController, FSCalendarDelegate {
    
    @IBOutlet var calendar: FSCalendar!

    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
     
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let date = Date() 
    }

  

}
