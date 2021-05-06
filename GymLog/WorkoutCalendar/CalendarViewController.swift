

import UIKit
import JTAppleCalendar
import Firebase

class CalendarViewController: UIViewController {

    @IBOutlet weak var numberDayOfDoneTraining: UILabel!
    @IBOutlet weak var nameDayOfDoneTraining: UILabel!

    
    var exampleArray: [String: [String]] = [:]
    var hourOfDoneTraining: [String] = []
    var exercisesInDoneTraining: [String: [String]] = [:]

    var doneTrainingDate: [String] = []
    

    var selectedDate = Date()
    
    var emptyDict: [String: [Date?]] = [:]
    
    var arrayOfTitles = [String]()
    var doneDates: [String] = []
    var selectDoneDates: [Date] = []
    var arrayOfDocumentsTitle: [String] = []
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    
    @IBOutlet weak var calendarView: JTACMonthView!
  
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    
    let formatter = DateFormatter()
    let currentDate = Date()
    // MARK: TABLE VIEW
    
    @IBOutlet weak var tableView: UITableView!
   
    override func viewWillAppear(_ animated: Bool) {
        calendarView.allowsMultipleSelection = true
        arrayOfTitles = []
        arrayOfDocumentsTitle = []
        doneDates = []
        selectDoneDates = []
        retrieveTitleWorkouts()
        retrieveDocumentsId
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
 
    func retrieveDocumentsId(completion: @escaping () -> ()) {

        let grp = DispatchGroup()
        arrayOfDocumentsTitle = []
        for title in arrayOfTitles {
            grp.enter()
        db.collection("users").document("\(user!.uid)").collection("WorkoutsName").document("\(title)").collection("Exercises").getDocuments { (querySnapshot, error) in
                        
            if let error = error {
                print("\(error.localizedDescription)")
            }
            else {
                if let documents = querySnapshot?.documents {
                  
                    for i in 0..<documents.count {
                        let documentID2 = documents[i].documentID
                        
                            self.arrayOfDocumentsTitle.append(documentID2)
                        self.exampleArray[title, default: []].append(documentID2)
                    }
                    grp.leave()
                    print("FIRST FUNCTION DONE")
                 print("YYY \(self.arrayOfDocumentsTitle)")
                }
            }
        }
            
    }
        
        grp.notify(queue: DispatchQueue.main) {
            completion()
            print("YY2 \(self.arrayOfDocumentsTitle)")
            print("NOWA ARRAY \(self.exampleArray)")
            print("TU FINITO")
        }
    }
    
    func getDateOfWorkout() {
        let grp = DispatchGroup()
        arrayOfDocumentsTitle = []
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
                        let value = self.formatter.date(from: calendarDocumentID)
                        self.emptyDict[title, default: []].append(value)

                    }
                    grp.leave()
                    print("NOWA TABLICA \(self.emptyDict)")
                }
            }
        }
            
    }
        
        grp.notify(queue: DispatchQueue.main) {
//            completion()
            self.preSelectData()
        }
    }
    
        
//    func retrieveWorkoutsDate() {
//        let grp2 = DispatchGroup()
//
//       doneDates = []
//            for title in arrayOfTitles {
//
//            print("Second function started")
//                print("TYTUL TO \(title)")
//            for document in arrayOfDocumentsTitle {
//                grp2.enter()
//            db.collection("users").document("\(user!.uid)").collection("WorkoutsName").document("\(title)").collection("Exercises").document("\(document)").collection("History").getDocuments { (querySnapshot, error) in
//
//                if let error = error
//                           {
//                                    print("\(error.localizedDescription)")
//                           }
//                           else {
//                               if let snapshotDocuments = querySnapshot?.documents {
//
//                                   for doc in snapshotDocuments {
//                                    let data = doc.data()
//                                    if let dateOfWorkout = data["date"] as? String {
//
//                                            self.doneDates.append(dateOfWorkout)
//                                        print("DOBRA \(title) i \(dateOfWorkout)")
//                                        self.formatter.dateFormat = "yyyy-MM-dd HH:mm"
//                                        let value = self.formatter.date(from: dateOfWorkout)
//                                        self.emptyDict[title, default: []].append(value)
////                                        self.emptyDict[title, default: [value : [].append(document)]]
//                                    }
//                                    print("DONE DATES TO \(self.doneDates)")
//
//                                   }
//                                grp2.leave()
//                                }
//                            }
//                        }
//            }
//        }
//        grp2.notify(queue: DispatchQueue.main) {
////            completion()
//            self.preSelectData()
//            print("TU DRUGIE FINITO")
//        print("SECOND FUNCTION DONE")
//        }
////        self.preSelectData()
//    }
    
    func preSelectData() {
        print("ODPALONA OSTATNIA PETARDA")
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.timeZone = Calendar.current.timeZone
        for (key, date) in emptyDict {
            print("DATE TO \(date)")
//            if let dateObject = formatter.date(from: date) {
//            print("TO JEST TO \(dateObject)")
//            selectDoneDates.append(dateObject)
//            }
            for date2 in date {
            selectDoneDates.append(date2!)
            }
        }
        calendarView.selectDates(selectDoneDates, triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
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

        let startDate = Date()
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
        doneTrainingDate = []
        exercisesInDoneTraining = [:]
        hourOfDoneTraining = []
        print("DONE TRAINING TO \(doneTrainingDate)")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateSelected = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "dd"
        let daySelected = dateFormatter.string(from: date)
        print("DAY SELECTED \(daySelected)")
        numberDayOfDoneTraining.text = daySelected
        getShortNameOfDay(date: date)
        for (key, value) in emptyDict {
            
            for dateOfWorkout in value {
                
            dateFormatter.dateFormat = "yyyy-MM-dd"
                let value1 = dateFormatter.string(from: dateOfWorkout ?? date)
            dateFormatter.dateFormat = "dd"
            let day = dateFormatter.string(from: dateOfWorkout ?? date)
            dateFormatter.dateFormat = "HH:mm"
            let hour = dateFormatter.string(from: dateOfWorkout ?? date)
                
            if dateSelected == value1 {
                
                doneTrainingDate.append(key)
                hourOfDoneTraining.append(hour)

            }
            else {
                print("Nie zrobiles tego dnia treningu")
//                numberDayOfDoneTraining.text = daySelected
            }
        }
    }
        DispatchQueue.main.async {
            self.tableView.reloadData()
       
            print("\(self.emptyDict) DICTIONARY SLOWNIK")
           
        
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
        print("GODZINY \(hourOfDoneTraining)")
        print("DONE DATES \(doneTrainingDate)")
        
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
            cell.exercisesInWorkout?.text = exampleArray["\(doneTrainingDate[indexPath.row])"]?.joined(separator: ", ")
        }
        
      
        return cell
}
}

