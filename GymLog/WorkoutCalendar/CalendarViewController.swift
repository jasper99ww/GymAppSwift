

import UIKit
import JTAppleCalendar
import Firebase

class CalendarViewController: UIViewController {

    let service = Service()
    @IBOutlet weak var numberDayOfDoneTraining: UILabel!
    @IBOutlet weak var nameDayOfDoneTraining: UILabel!
    
    var exercisesInTraining: [String: [String]] = [:]
    var hourOfDoneTraining: [String] = []
    var exercisesInDoneTraining: [String: [String]] = [:]

    var doneTrainingDate: [String] = []

    var selectedDate = Date()
    
    var emptyDict: [String: [Date?]] = [:]
    
    var arrayOfTitles = [String]()
    var doneDates: [String] = []
    var selectDoneDates: [Date] = []
    var selectDoneDates2: [String] = []
    var selectDoneDates3: [String] = []
    var arrayOfDocumentsTitle: [String : [String]] = [:]
    
    var selectedString = String()
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    
    @IBOutlet weak var calendarView: JTACMonthView!
    
    let popup = CalendarPopupViewController()
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    
    let formatter = DateFormatter()
    let currentDate = Date()
    // MARK: TABLE VIEW
    
    @IBOutlet weak var tableView: UITableView!
   
    // MARK: PopUp

    override func viewWillAppear(_ animated: Bool) {
   
        calendarView.allowsMultipleSelection = true
        calendarView.deselectAllDates()
        calendarView.scrollToDate(Date(), animateScroll: false)
        selectTodayDate()
        emptyDict = [:]
        selectDoneDates = []
        retrieveTitleWorkouts()
        retrieveExercisesForWorkouts
        {
            self.getDateOfWorkout()
        }
        
        setUpCalendar()
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
             
        calendarView.calendarDataSource = self
        calendarView.calendarDelegate = self
        calendarViewCorners()
        setDefaultDate()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 110
     
        print("date is \(Date().firstDateOfYear())")
        print("DATA DZISIEJSZA \(Date())")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
     
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCalendarPopUp" {
            let popup = segue.destination as! CalendarPopupViewController
            popup.selectedWorkout = { text in
//                self.selectDoneDates2 = []
                self.selectedString = text
                self.calendarView.allowsMultipleSelection = true
                self.calendarView.deselectAllDates()
                self.preSelectDataAfterPopUp()
                self.selectTodayDate()
                self.calendarView.allowsMultipleSelection = false
            }
        }
      
    }
    
    func preSelectDataAfterPopUp() {
        
//        selectDoneDates2 = []
        selectDoneDates3 = []
        
        if selectedString == "ALL" {
            preSelectData()
        }
        else {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            if let examples = emptyDict[selectedString] {
                let examplesInString = examples.compactMap { dateFormatter.string(from: $0!) } as [String]
            selectDoneDates3 = examplesInString
            }
        }
    
        self.calendarView.reloadData()
       
    }
    
    
    func selectTodayDate() {
       
        calendarView.selectDates([currentDate])
        
    }
    
    func setDefaultDate() {
        formatter.dateFormat = "dd"
        let todayDate = formatter.string(from: currentDate)
        numberDayOfDoneTraining.text = todayDate
        getShortNameOfDay(date: currentDate)
    }
    
    func getShortNameOfDay(date: Date) {
        formatter.dateFormat = "EE"
        let dayInWeek = formatter.string(from: date).uppercased()
        nameDayOfDoneTraining.text = dayInWeek
    }
    
    func calendarViewCorners() {
        calendarView.layer.cornerRadius = 35
        calendarView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    

    func retrieveTitleWorkouts() {
        if let workoutName = UserDefaults.standard.object(forKey: "workoutsName") as? [String] {
        arrayOfTitles = workoutName
        }
    }
 
    func retrieveExercisesForWorkouts(completion: @escaping() -> ()) {
        service.getExercisesForWorkouts(arrayOfTitles: arrayOfTitles) { (data) in
            self.exercisesInTraining = data
            completion()
        }
    }
    
    func getDateOfWorkout() {
        
        let grp = DispatchGroup()
        for title in arrayOfTitles {
            grp.enter()
        db.collection("users").document("\(user!.uid)").collection("WorkoutsName").document("\(title)").collection("Calendar").getDocuments { (querySnapshot, error) in
                        
            if let error = error {
                print("\(error.localizedDescription)")
            }
            else {
                if let calendarDocuments = querySnapshot?.documents {
                  
                    for i in 0..<calendarDocuments.count {
                        let calendarDocumentID = calendarDocuments[i].documentID
                        
                        self.formatter.dateFormat = "yyyy-MM-dd HH:mm"
                        guard let value = self.formatter.date(from: calendarDocumentID) else {return }
                        self.emptyDict[title, default: []].append(value)
                        
                        let dateFormatter2 = DateFormatter()
                        dateFormatter2.dateFormat = "yyyy-MM-dd"
                        let value2 = dateFormatter2.string(from: value)
                        self.selectDoneDates2.append(value2)
                    }
                    grp.leave()
                }
            }
        }
            
    }
        
        grp.notify(queue: DispatchQueue.main) {
            self.preSelectData()
        }
    }
    
   
    func preSelectData() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        for (_, date) in emptyDict {

            for date2 in date {
            selectDoneDates.append(date2!)
            }
        }
        calendarView.selectDates(selectDoneDates, triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
        self.calendarView.allowsMultipleSelection = false
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
        
        formatter.dateFormat = "yyyy-MM-dd"
        
        let todayDateString = formatter.string(from: Date())
        let monthDateString = formatter.string(from: cellState.date)
        
        

        if todayDateString == monthDateString {
            validCell.selectedView.isHidden = false
            validCell.selectedView.backgroundColor = .darkGray
            validCell.todayLabel.isHidden = false
        } else {
            validCell.todayLabel.isHidden = true
            validCell.selectedView.backgroundColor = UIColor.init(red: 81/255, green: 134/255, blue: 87/255, alpha: 1)
        }

        if cellState.isSelected {
            validCell.datelabel.textColor = .white
        }
     
        else {
            if cellState.dateBelongsTo == .thisMonth {
                validCell.datelabel.textColor = .white
                
            } else {
                validCell.datelabel.textColor = .lightGray
            }
        }
    }

    func handleCellSelected(view: JTACDayCell?, cellState: CellState) {
        guard let validCell = view as? DateCell else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let cellDate = dateFormatter.string(from: cellState.date)
       
        
        if validCell.isSelected || (selectDoneDates2.contains(cellDate) && selectDoneDates3
            .isEmpty) {
            validCell.selectedView.isHidden = false
        } else if cellState.date == Date() || selectDoneDates3.contains(cellDate) {
            validCell.selectedView.isHidden = false
            validCell.selectedView.backgroundColor = UIColor.init(red: 81/255, green: 134/255, blue: 87/255, alpha: 1)
            
        }
        else {
            validCell.selectedView.isHidden = true
        }
}
    
  
}

extension CalendarViewController: JTACMonthViewDataSource {

    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"

        let startDate = Date().firstDateOfYear()
        let endDate = formatter.date(from: "2021 12 12")!
        
        let firstDayOfWeek: DaysOfWeek = .monday
    
        let parameteres = ConfigurationParameters(startDate: startDate, endDate: endDate, firstDayOfWeek: firstDayOfWeek)
        
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
        
        
        doneTrainingDate = []
        exercisesInDoneTraining = [:]
        hourOfDoneTraining = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateSelected = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "dd"
        let daySelected = dateFormatter.string(from: date)
   
        numberDayOfDoneTraining.text = daySelected
        getShortNameOfDay(date: date)
        
        for (key, value) in emptyDict {
            
            for dateOfWorkout in value {
                
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let value1 = dateFormatter.string(from: dateOfWorkout ?? date)
            dateFormatter.dateFormat = "HH:mm"
            let hour = dateFormatter.string(from: dateOfWorkout ?? date)
                
            if dateSelected == value1 {
                
                doneTrainingDate.append(key)
                hourOfDoneTraining.append(hour)

            }
            else {
//                print("Nie zrobiles tego dnia treningu")
            }
        }

    }
        DispatchQueue.main.async {
            self.tableView.reloadData()
           
        }
    }

    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
     
    }

    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setUpViewsOfCalendar(from: visibleDates)

    }
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard doneTrainingDate.count == 0 else {return doneTrainingDate.count}
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "calendarCell", for: indexPath) as! CalendarTableViewCell

        if doneTrainingDate.count == 0 {
            cell.showDetailsButton?.alpha = 0
            cell.viewColor?.backgroundColor = .clear
            cell.workoutCellLabel?.text = "No training this day"
            cell.cellHourOfDoneTraining?.text = ""
            cell.exercisesInWorkout?.text = ""
            
        } else {
            
            cell.showDetailsButton?.alpha = 1
            cell.viewColor?.backgroundColor = UIColor.init(red: 1/255, green: 50/255, blue: 32/255, alpha: 1)
         
            cell.workoutCellLabel?.text = doneTrainingDate[indexPath.row]
            cell.cellHourOfDoneTraining?.text = hourOfDoneTraining[indexPath.row]
            cell.exercisesInWorkout?.text = exercisesInTraining["\(doneTrainingDate[indexPath.row])"]?.joined(separator: ", ")
        }
        
        return cell
    }
}


extension Date {
    
    public var removeTimeStamp: Date? {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
            return nil
        }
        return date
    }
}

