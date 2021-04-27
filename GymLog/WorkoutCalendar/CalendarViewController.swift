//
//  CalendarViewController.swift
//  GymLog
//
//  Created by Barbara Podgórska on 25/04/2021.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var calendarView: JTACMonthView!
  
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!

    let formatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
             
        calendarView.calendarDataSource = self
        calendarView.calendarDelegate = self
        

        setUpCalendar()
    }

    func setUpCalendar() {
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0

        //Setup labels
        calendarView.visibleDates { (visibleDates) in
            self.setUpViewsOfCalendar(from: visibleDates)

        }
    }

        func setUpViewsOfCalendar(from visibleDates: DateSegmentInfo) {

            let date = visibleDates.monthDates.first!.date

            self.formatter.dateFormat = "yyyy"
            self.year.text = self.formatter.string(from: date)

            self.formatter.dateFormat = "MMMM"
            self.month.text = self.formatter.string(from: date)

        }


    func handleCellTextColor(view: JTACDayCell?, cellState: CellState) {
        guard let validCell = view as? DateCell else { return }

        if cellState.isSelected {
            validCell.datelabel.textColor = .white
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                validCell.datelabel.textColor = .white
                
            } else {
                validCell.datelabel.textColor = .lightGray
                validCell.datelabel.alpha = 0.3
            }
        }
    }

    func handleCellSelected(view: JTACDayCell?, cellState: CellState) {
        guard let validCell = view as? DateCell else { return }

        if validCell.isSelected {
            validCell.selectedView.isHidden = false
        } else {
            validCell.selectedView.isHidden = true
        }
}
}

extension CalendarViewController: JTACMonthViewDataSource {

    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale

        let startDate = formatter.date(from: "2021 01 01")!
        let endDate = formatter.date(from: "2021 12 12")!

        let parameteres = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameteres
    }

}

extension CalendarViewController: JTACMonthViewDelegate {
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
       
        cell.datelabel.text = cellState.text
       
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        return cell
    }
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cell = cell as! DateCell
        cell.datelabel.text = cellState.text

        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }

    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }

    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setUpViewsOfCalendar(from: visibleDates)

    }
    
    
}

