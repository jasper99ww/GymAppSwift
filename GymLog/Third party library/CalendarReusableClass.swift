//
//  Calendar.swift
//  GymLog
//
//  Created by Kacper P on 26/07/2021.
//

import Foundation
import JTAppleCalendar

protocol CalendarReusableClassDelegate: class {
   func handleCellSelected(view: JTACDayCell?, cellState: CellState)
    func updateUIAfterSelection(selected date: Date)
}

class CalendarReusableClass {
    
weak var calendarDelegate: CalendarReusableClassDelegate?
    
   var viewForCalendar: UIView?
   var calendar: JTACMonthView?
   var currentDisplayMonthLabel: UILabel?
   var backwardMonthButton: UIButton?
   var forwardMonthButton: UIButton?
   var formatter = DateFormatter()
    
    init(calendarDelegate: CalendarReusableClassDelegate) {
        self.calendarDelegate = calendarDelegate
    }
    
    
    
    //MARK: - CALENDAR UI SET UP

    func setUpCalendar(calendar: JTACMonthView) {
        calendar.minimumLineSpacing = 0
        calendar.minimumInteritemSpacing = 0
        
        calendar.visibleDates { (visibleDates) in
            self.setUpCurrentMonth(from: visibleDates)
        }
    }
    
    func setUpCurrentMonth(from visibleDates: DateSegmentInfo) {

        let currentDisplayedMonth = visibleDates.monthDates.first?.date
        self.currentDisplayMonthLabel?.text = currentDisplayedMonth?.getFormattedDate(format: DateFormats.formatMonth)
    }
    
    func cellTextColor(view: DateCell, cellState: CellState) {
        if cellState.isSelected || cellState.dateBelongsTo == .thisMonth{
            view.datelabel.textColor = .white
        }
        else {
            view.datelabel.textColor = .lightGray
        }
    }
    
    func handleCellsUI(view: JTACDayCell?, cellState: CellState) {
        
        guard let validCell = view as? DateCell else { return }

        let todayDateString = Date().getFormattedDate(format: DateFormats.formatYearMonthDay)
        let monthDateString = cellState.date.getFormattedDate(format: DateFormats.formatYearMonthDay)
        
        // If selected date is today's date, set a grey background for cell
        if todayDateString == monthDateString {
            validCell.selectedView.isHidden = false
            validCell.todayLabel.isHidden = false
            validCell.selectedView.backgroundColor = .darkGray
           
        } else {
            // If selected date isn't today's date, hide todayLabel
            validCell.todayLabel.isHidden = true
            validCell.selectedView.backgroundColor = Colors.greenColor
        }

        // Make days from last and next month as grey
        cellTextColor(view: validCell, cellState: cellState)
    }
    
   

    func handleCellSelected(view: JTACDayCell?, cellState: CellState) {
        
        calendarDelegate?.handleCellSelected(view: view, cellState: cellState)
    }
    
}

extension CalendarReusableClass: JTACMonthViewDataSource {

    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"

        let startDate = Date().firstDateOfYear()
        let endDate = Date().lastDateOfYear()
        let firstDayOfWeek: DaysOfWeek = .monday
        let parameteres = ConfigurationParameters(startDate: startDate, endDate: endDate, firstDayOfWeek: firstDayOfWeek)
        
        return parameteres
    }
}

extension CalendarReusableClass: JTACMonthViewDelegate {
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
       
        cell.datelabel.text = cellState.text

        handleCellSelected(view: cell, cellState: cellState)
        handleCellsUI(view: cell, cellState: cellState)
        
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
        let cell = cell as! DateCell
        cell.datelabel.text = cellState.text

        calendarDelegate?.handleCellSelected(view: cell, cellState: cellState)
        handleCellsUI(view: cell, cellState: cellState)
      
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
     
        calendarDelegate?.handleCellSelected(view: cell, cellState: cellState)
        handleCellsUI(view: cell, cellState: cellState)
        
        calendarDelegate?.updateUIAfterSelection(selected: date)
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
   
        calendarDelegate?.handleCellSelected(view: cell, cellState: cellState)
        handleCellsUI(view: cell, cellState: cellState)
    }
 
    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setUpCurrentMonth(from: visibleDates)
    }
}

