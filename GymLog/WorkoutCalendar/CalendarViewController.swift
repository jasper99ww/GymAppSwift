

import UIKit
import JTAppleCalendar
import Firebase

class CalendarViewController: UIViewController {
   
    var hourOfDoneTraining: [String] = []
    var exercisesInDoneTraining: [String] = []
    var doneTrainingDate: [String] = []
    
    @IBOutlet weak var numberDayOfDoneTraining: UILabel!
    @IBOutlet weak var nameDayOfDoneTraining: UILabel!

    var selectedDate = Date()
    
    var emptyDict: [String: [Date?: String]] = [:]
    
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
    
    // MARK: TABLE VIEW
    
    @IBOutlet weak var tableView: UITableView!
   
    override func viewWillAppear(_ animated: Bool) {
        calendarView.allowsMultipleSelection = true
        arrayOfTitles = []
        arrayOfDocumentsTitle = []
        doneDates = []
        selectDoneDates = []
        retrieveTitleWorkouts()
        retrieveDocumentsId {
            self.retrieveWorkoutsDate()
        }
//        preSelectData()
        setUpCalendar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
             
        calendarView.calendarDataSource = self
        calendarView.calendarDelegate = self
        calendarView.layer.cornerRadius = 30
        calendarView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 115
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
            print("TU FINITO")
        }
    }
        
    func retrieveWorkoutsDate() {
        let grp2 = DispatchGroup()
        
       doneDates = []
            for title in arrayOfTitles {
               
            print("Second function started")
                print("TYTUL TO \(title)")
            for document in arrayOfDocumentsTitle {
                grp2.enter()
            db.collection("users").document("\(user!.uid)").collection("WorkoutsName").document("\(title)").collection("Exercises").document("\(document)").collection("History").getDocuments { (querySnapshot, error) in
                
                if let error = error
                           {
                                    print("\(error.localizedDescription)")
                           }
                           else {
                               if let snapshotDocuments = querySnapshot?.documents {
                               
                                   for doc in snapshotDocuments {
                                    let data = doc.data()
                                    if let dateOfWorkout = data["date"] as? String {
                                      
                                            self.doneDates.append(dateOfWorkout)
                                        print("DOBRA \(title) i \(dateOfWorkout)")
                                        self.formatter.dateFormat = "yyyy-MM-dd HH:mm"
                                        let value = self.formatter.date(from: dateOfWorkout)
                                        self.emptyDict["\(title)"] = [value:document]
                                        
                                    }
                                    print("DONE DATES TO \(self.doneDates)")
                                    
                                   }
                                grp2.leave()
                                }
                            }
                        }
            }
        }
        grp2.notify(queue: DispatchQueue.main) {
//            completion()
            self.preSelectData()
            print("TU DRUGIE FINITO")
        print("SECOND FUNCTION DONE")
        }
//        self.preSelectData()
    }
    
    func preSelectData() {
        print("ODPALONA OSTATNIA PETARDA")
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.timeZone = Calendar.current.timeZone
        for date in doneDates {
            print("DATE TO \(date)")
            if let dateObject = formatter.date(from: date) {
            print("TO JEST TO \(dateObject)")
            selectDoneDates.append(dateObject)
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
        print("PRZED FORMATEM \(date)")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateSelected = dateFormatter.string(from: date)
      
        for (key, value) in emptyDict {
            for (dateOfWorkout, name) in value {
            dateFormatter.dateFormat = "yyyy-MM-dd"
                let value1 = dateFormatter.string(from: dateOfWorkout ?? date)
            dateFormatter.dateFormat = "dd"
            let day = dateFormatter.string(from: dateOfWorkout ?? date)
            dateFormatter.dateFormat = "HH:mm"
            let hour = dateFormatter.string(from: dateOfWorkout ?? date)
            if dateSelected == value1 {
                numberDayOfDoneTraining.text = day
                
                doneTrainingDate.append(key)
                hourOfDoneTraining.append(hour)
                exercisesInDoneTraining.append(name)
            }
            else {
                print("Nie zrobiles tego dnia treningu")
//                doneTrainingDate = "No training this day"
            }
        }
    }
        tableView.reloadData()
        
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
        return doneTrainingDate.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "calendarCell", for: indexPath) as! CalendarTableViewCell
        cell.workoutCellLabel?.text = doneTrainingDate[indexPath.row]
        cell.cellHourOfDoneTraining?.text = hourOfDoneTraining[indexPath.row]
        cell.exercisesInWorkout?.text = exercisesInDoneTraining[indexPath.row]
        return cell
    }
}
