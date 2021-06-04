



struct RetrievedWorkout {
    let workoutTitle: String
    let exerciseTitle: String
    let sets: String
    let date: Date
    let volume: Int
    
}

struct RetrievedWorkoutsByExercise {
    
    let exerciseTitle: String
    let sets: Int
    let maxWeight: Int
    let maxReps: Int
    let date: Date
    let volume: Int
    
}

struct RetrievedWorkoutsByVolume {
    let reps: Int
    let time: String
    let volume: Int
    let weight: Int
    let date: Date
}

struct RetrievedWorkoutMax {
    
    let workoutTitle: String
    let exerciseTitle: String
    let sets: Int
    let maxWeight: Int
    let maxReps: Int
    let date: Date
    let volume: Int
    
}

struct HighlightedExercise {
    
    let reps: Int
    let sets: Int
    let time: String
    
}

import UIKit
import Charts
import Firebase

class ProgressChartViewController: UIViewController, ChartViewDelegate {
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    let service = Service()
    
    let formatter = DateFormatter()
    var dateCount: Int = 0
    let calendar = Calendar(identifier: .iso8601)
    
    var workoutTitle = UILabel()
    var exercisesForSelectedWorkout: [String] = []
    @IBOutlet weak var selectAlert: UIBarButtonItem!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var lineChart: LineChartView!
    @IBOutlet weak var viewChart: UIView!
   
    @IBOutlet weak var selectExercise: UIButton!
    
    
    @IBOutlet weak var weightValue: UILabel!
    @IBOutlet weak var repsValue: UILabel!
    @IBOutlet weak var changeValue: UILabel!
    @IBOutlet weak var weightView: UIView!
    @IBOutlet weak var repsView: UIView!
    @IBOutlet weak var changeView: UIView!
    @IBOutlet weak var selectBy: UIView!
    @IBOutlet weak var selectByButton: UIButton!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    
    
    
    var numberOfColors = 0
    let colors = [UIColor.red, UIColor.green, UIColor.purple, UIColor.gray,  UIColor.white]
    
    var lineChartEntry1 = [ChartDataEntry]()
    var dataEntry: [ChartDataEntry] = []
    var dataSets: [LineChartDataSet] = [LineChartDataSet]()
    var referenceTimeInterval: TimeInterval = 0
    
    var dateSelection = DateSelection()
    var retrievedExercise: [String: [RetrievedWorkout]] = [:]
    var arrayOfTitles: [String] = []
    var arrayOfTitleDocuments:  [String: [String]]? = [:]
    var retrievedExerciseMax: [String: [RetrievedWorkoutMax]] = [:]
    var retrievedExerciseMaxWithSelection: [String: [RetrievedWorkoutMax]] = [:]
    var retrievedAllWorkouts: [String: [RetrievedWorkoutsByVolume]] = [:]
    var retrievedByExercise: [RetrievedWorkoutsByExercise] = []
    var int = 0
    var highlightedValue: [HighlightedExercise] = []
    var checkIfWorkoutIsSelected: Bool = false
    var checkIfWeightCriteriaIsSelected: Bool = true
    let dateFormatter = DateFormatter()
    
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lineChart.delegate = self
        retrieveArrays()
        retrieveDocumentsArray()
        
        setUpNavigationBarItems()
        controlSegmentSetUp()
        setUpViews()
//        getData(title: "Workout4")
        self.getDataByVolume(titles: self.arrayOfTitles)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print(" poczatek miesiace \(Date().firstDateOfMonth()) koniec \(Date().lastDateOfMonth()))")
        
    }
    
 
    
    //MARK: - MAKING PERIOD OF TIME SELECTION
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            segmentedControlForWeek(period: "week")
        } else if sender.selectedSegmentIndex == 1 {
            segmentedControlForWeek(period: "month")
        } else if sender.selectedSegmentIndex == 2 {
           segmentedControlForWeek(period: "year")
        }
    }
    
   
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        let dataSetIndex = highlight.dataSetIndex
    
        let stringValue = String(format: "%.0f", highlight.y)
      
        guard let dataSet = chartView.data?.dataSets[highlight.dataSetIndex] else { return }
            
        let indexOfEntry : Int = dataSet.entryIndex(entry: entry)
           
        if let entryData = entry.data as? HighlightedExercise {
 
            if indexOfEntry > 0 {
                
                let previousEntry = dataSets[dataSetIndex][indexOfEntry - 1]
                let previousEntryData = Int((((highlight.y) - (previousEntry.y)) / (previousEntry.y)) * 100)
                changeValue.text = String("\(previousEntryData)%")
                changeValue.fadeTransition(0.4)
              
                if previousEntryData > 0 {
                    changeValue.textColor = .green
                    changeValue.text = String("+\(previousEntryData)%")
                } else {
                    changeValue.textColor = .red
                }
            }
            
            else {
                changeValue.text = "-"
                changeValue.textColor = .white
            }
            
            if checkIfWeightCriteriaIsSelected == false {
                repsValue.text = entryData.time
                repsValue.fadeTransition(0.4)
            }
            
            if entryData.time == "" {
            let repsEntryData = String(entryData.reps)
            repsValue.text = repsEntryData
                repsValue.fadeTransition(0.4)
                weightValue.text = "\(stringValue)kg"
                weightValue.fadeTransition(0.4)
            }
            else {
                repsValue.text = entryData.time.convertFormatTime()
                repsValue.fadeTransition(0.4)
                weightValue.text = "\(stringValue)"
                weightValue.fadeTransition(0.4)
            }
        }

    }
    
  
    //MARK: - SET CHART DATA
    
    
    func setData(entries: [LineChartDataSet]) {
        
        for set in entries {

        set.mode = .cubicBezier
        set.drawCirclesEnabled = true
        set.circleColors = set.colors
        set.drawCircleHoleEnabled = false
        set.circleRadius = 4
        set.lineWidth = 4

        set.drawHorizontalHighlightIndicatorEnabled = false
        set.highlightColor = .red
        }
        
        let data = LineChartData(dataSets: entries)
        lineChart.data = data
        data.setDrawValues(false)

            self.setChartProperties()
       
    }
  
    func convertDateForAxis() {
        
        if let minTimeInterval = (retrievedAllWorkouts.compactMap({$0.value}).compactMap({$0.compactMap({$0.date})}).min(by: {$0[0].timeIntervalSince1970 < $1[0].timeIntervalSince1970}))?.min() {
            referenceTimeInterval = minTimeInterval.timeIntervalSince1970
        }

    }
    
    func findTrainingVolume(ex: [String], period: String) {
        
        let group2 = DispatchGroup()
     
        var new: [String: [RetrievedWorkoutsByVolume]] = [:]
    
        if period == "year" {
            group2.enter()
          new = retrievedAllWorkouts
            convertDateForAxis()
            group2.leave()
        } else if period == "month" {
            group2.enter()
            dateSelection.loopForMonthVolume(data: retrievedAllWorkouts) { (data) in
                new = data
            }
          group2.leave()
        }
         else if period == "week" {
            group2.enter()
            dateSelection.loopForWeekVolume(data: retrievedAllWorkouts) { (data) in
               new = data
            }
            group2.leave()
        } else {
            print("weird")
        }
        
        lineChart.xAxis.valueFormatter = ChartXAxisFormatter(referenceTimeInterval: referenceTimeInterval, dateFormatter: dateFormatter)
        

            dateCount = 0
            numberOfColors = 0
           
            lineChartEntry1 = []
            dataSets = []
       
            
            
            for (key, value) in new {
               
                group2.enter()
                numberOfColors += 1
                lineChartEntry1 = []

                for values in value {
                    
                    let date = values.date

                    dateCount += 1
                    
                
                    let timeInterval = date.timeIntervalSince1970
                    let xValue = (timeInterval - referenceTimeInterval) / (3600 * 24)
                    
                    let volume = values.volume
                    let highlightedValue = HighlightedExercise(reps: values.reps, sets: 0, time: values.time)
                    
                    
                    lineChartEntry1.append(ChartDataEntry(x: xValue, y: Double(volume), data: highlightedValue))
                   
                }
                
                lineChartEntry1.sort(by: { $0.x < $1.x})
                
                let set = LineChartDataSet(entries: lineChartEntry1, label: "\(key)")
       
                set.setColor(colors[numberOfColors])
                
                dataSets.append(set)
                checkIfWeightCriteriaIsSelected = false
                group2.leave()
            }
            
            group2.notify(queue: .main) {
                self.setData(entries: self.dataSets)
        
            }
    }
    
    func findByExercise(criteria: String, period: String) {
        
        lineChartEntry1 = []
        dataSets = []

        var newData: [RetrievedWorkoutsByExercise] = []
        
        let group2 = DispatchGroup()
        
        var titleOfExercise: String = ""
     
          if period == "year" {
              group2.enter()
            newData = retrievedByExercise
            convertDateForAxis()
              group2.leave()
          } else if period == "month" {
              group2.enter()
            dateSelection.loopForMonthByExercise(data: retrievedByExercise) { (data) in
                newData = data
            }
            group2.leave()
          }
           else if period == "week" {
              group2.enter()
              dateSelection.loopForWeekByExercise(data: retrievedByExercise) { (data) in
                  newData = data
              }
              group2.leave()
          } else {
              print("weird")
          }
        
        lineChart.xAxis.valueFormatter = ChartXAxisFormatter(referenceTimeInterval: referenceTimeInterval, dateFormatter: dateFormatter)
        
        for value in newData {
            group2.enter()
            let date = value.date
            
            let timeInterval = date.timeIntervalSince1970
            let xValue = (timeInterval - referenceTimeInterval) / (3600 * 24)
            
            let weight = value.maxWeight
            let volume = value.volume
            
            let highlightedValue = HighlightedExercise(reps: value.maxReps, sets: value.sets, time: "")
       
            titleOfExercise = value.exerciseTitle
            
            if criteria == "Weight" {
            lineChartEntry1.append(ChartDataEntry(x: xValue, y: Double(weight), data: highlightedValue))
            }
            else {
                lineChartEntry1.append(ChartDataEntry(x: xValue, y: Double(volume), data: highlightedValue))
            }
            group2.leave()
        }
       
        lineChartEntry1.sort(by: { $0.x < $1.x})
        let set = LineChartDataSet(entries: lineChartEntry1, label: "\(titleOfExercise)")
        group2.notify(queue: .main) {
   
            self.dataSets.append(set)
            self.setData(entries: self.dataSets)
  
        }
      
    }


    func findMaxValueWithSelection(type: String, period: String) {
        
        let group2 = DispatchGroup()
        lineChartEntry1 = []
        dataSets = []
        retrievedExerciseMaxWithSelection = [:]
     
      
        if period == "year" {
            group2.enter()
          retrievedExerciseMaxWithSelection = retrievedExerciseMax
            convertDateForAxis()
            group2.leave()
        } else if period == "month" {
            group2.enter()
            dateSelection.loopForMonthByMaxValue(data: retrievedExerciseMax) { (data) in
                retrievedExerciseMaxWithSelection = data
            }
            group2.leave()
        } else if period == "week" {
            group2.enter()
            dateSelection.loopForWeekByMaxValue(data: retrievedExerciseMax) { (data) in
                retrievedExerciseMaxWithSelection = data
            }
            group2.leave()
        } else {
            print("weird")
        }
       
      
        lineChart.xAxis.valueFormatter = ChartXAxisFormatter(referenceTimeInterval: referenceTimeInterval, dateFormatter: dateFormatter)
        numberOfColors = 0
        

        for (key, value) in retrievedExerciseMaxWithSelection {
            group2.enter()
            numberOfColors += 1
            lineChartEntry1 = []
            for values in value {
               
                dateCount += 1
                
                let timeInterval = values.date.timeIntervalSince1970
                
                let maxWeight = Double(values.maxWeight)
                let volume = Double(values.volume)
                let highlightedValue = HighlightedExercise(reps: values.maxReps, sets: values.sets, time: "")

                let xValue = (timeInterval - referenceTimeInterval) / (3600 * 24)
                
                if type == "Weight" {
                    lineChartEntry1.append(ChartDataEntry(x: xValue, y: Double(maxWeight), data: highlightedValue))
                } else {
                    lineChartEntry1.append(ChartDataEntry(x: xValue, y: Double(volume), data: highlightedValue))
                }
       
            }
            
            lineChartEntry1.sort(by: { $0.x < $1.x})
            let set = LineChartDataSet(entries: lineChartEntry1, label: "\(key)")
            set.setColor(colors[numberOfColors])
            
            dataSets.append(set)
            group2.leave()
        }
        
        group2.notify(queue: .main) {

            self.setData(entries: self.dataSets)
         
        }
        
    }
    
    func findMaxValue(type: String, period: String) {
        
        dateCount = 0
        numberOfColors = 0
        lineChartEntry1 = []
        dataSets = []
        
        let group2 = DispatchGroup()
      
        let dateFormatter = DateFormatter()
        lineChart.xAxis.valueFormatter = ChartXAxisFormatter(referenceTimeInterval: referenceTimeInterval, dateFormatter: dateFormatter)
       
        for (key, value) in retrievedExerciseMax {
            group2.enter()
            numberOfColors += 1
            lineChartEntry1 = []
            for values in value {
               
                dateCount += 1
                
                var timeInterval = values.date.timeIntervalSince1970
                
                let maxWeight = Double(values.maxWeight)
                let volume = Double(values.volume)
                let highlightedValue = HighlightedExercise(reps: values.maxReps, sets: values.sets, time: "")

                let xValue = (timeInterval - referenceTimeInterval) / (3600 * 24)
                
                if type == "Weight" {
                    lineChartEntry1.append(ChartDataEntry(x: xValue, y: Double(maxWeight), data: highlightedValue))
                } else {
                    lineChartEntry1.append(ChartDataEntry(x: xValue, y: Double(volume), data: highlightedValue))
                }
       
            }
            
            lineChartEntry1.sort(by: { $0.x < $1.x})
            let set = LineChartDataSet(entries: lineChartEntry1, label: "\(key)")
            set.setColor(colors[numberOfColors])
            
            dataSets.append(set)
            group2.leave()
        }
        
        group2.notify(queue: .main) {
            self.setData(entries: self.dataSets)
        }
    }
    
    
    //MARK: - UserDefaults

func retrieveArrays() {
    
    if let arrayTitles = UserDefaults.standard.object(forKey: "workoutsName") as? [String] {
        arrayOfTitles = arrayTitles
      
    }
}

func retrieveDocumentsArray() {
    
    if let arrayTitleDocuments = UserDefaults.standard.object(forKey: "dictionaryOfTitleDocuments") as? [String: [String]] {
        arrayOfTitleDocuments = arrayTitleDocuments
    }
}
    
    //MARK: - FIRESTORE
    
    func getExercisesForSelectedWorkout() {

        if let workoutTitle = workoutTitle.text {
        service.getDocumentsTitle(workout: workoutTitle) { (result) in
            self.exercisesForSelectedWorkout = result
        }
        }
    }
    
    func getDataByVolume(titles: [String]) {
        retrievedAllWorkouts = [:]
        service.getDataByVolume(titles: titles, completionHandler: { data in
            self.retrievedAllWorkouts = data
            self.convertDateForAxis()
            self.findTrainingVolume(ex: titles, period: "year")
            print("retreived \(self.retrievedAllWorkouts)")
        })
    }
    
    func getDataByExercise(title: String, document: String) {
      
        retrievedByExercise = []
        service.getDataByExercise(title: title, document: document) { (data) in
            self.retrievedByExercise = data
            self.convertDateForAxis()
            self.findByExercise(criteria: "Weight", period: "year")
        }
    }

    func getData(title: String) {
        
        retrievedExerciseMax = [:]
        service.getAllExercisesInWorkout(title: title, arrayOfDocuments: arrayOfTitleDocuments!) { (data) in
            self.retrievedExerciseMax = data
            self.convertDateForAxis()
            self.findMaxValue(type: "Weight", period: "year")
            print("TO BYLO WCZESNIEJ \(self.retrievedExerciseMax)")
        }
    }

    
    //MARK: -SEGUES
    
    func segmentedControlForWeek(period: String) {
        
        switch (workoutTitle.text, selectExercise.currentTitle) {
        
        case ("ALL WORKOUTS", "Select exercises"):
            self.findTrainingVolume(ex: arrayOfTitles, period: period)
        
        case (let title1, "Select exercises") where title1 != "ALL WORKOUTS":
            self.findTrainingVolume(ex: [selectExercise.currentTitle!], period: period)
            
        case (_, "All exercises"):
            self.findMaxValueWithSelection(type: selectByButton.currentTitle!, period: period)
        
        case (_, let exercise) where exercise != "All exercises":
            self.findByExercise(criteria: selectByButton.currentTitle!, period: period)
            
        default:
            print("SOMETHING WEIRD HAS HAPPENED")
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWorkoutSelection" {
            let popup = segue.destination as! ProgressPopUpView
            
            popup.selectedWorkoutChart = { text in

                self.workoutTitle.text = text
                if text == "ALL WORKOUTS" {
                    self.getDataByVolume(titles: self.arrayOfTitles)
                    self.selectByButton.setTitle("Volume", for: .normal)
                    self.selectExercise.isUserInteractionEnabled = false
                    self.selectByButton.isUserInteractionEnabled = false
                    self.changeLabelsForVolume()
                
                } else {

                    self.getDataByVolume(titles: [text])
                    self.selectExercise.isUserInteractionEnabled = true
                    self.selectByButton.isUserInteractionEnabled = false
       
                }

                self.lineChart.notifyDataSetChanged()
                self.checkIfWorkoutIsSelected = true
                self.getExercisesForSelectedWorkout()
                
            }
        }
        
        if checkIfWorkoutIsSelected == true {
        if segue.identifier == "toExerciseSelection" {
            let popup = segue.destination as! ExercisesPopUp
            
            popup.exercises = exercisesForSelectedWorkout
            popup.selectedExercise = { text in

                self.selectExercise.setTitle(text, for: .normal)
                if text == "All exercises" {
                    self.getData(title:  self.workoutTitle.text!)
                 
                } else {
                    self.getDataByExercise(title: self.workoutTitle.text!, document: text)
              
                }
                
                self.lineChart.notifyDataSetChanged()
                self.selectByButton.isUserInteractionEnabled = true
                self.changeLabelsForWeight()
       
                self.selectByButton.imageView?.tintColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
            }
            
            }
            
        }
        
        if segue.identifier == "toCriteriaSelection" {
            let popup = segue.destination as! CriteriaOfSelectViewController
            popup.selectedCriteria = { criteria in
                
                self.selectByButton.setTitle(criteria, for: .normal)
                
                if criteria == "Volume" {
                    if self.selectExercise.titleLabel?.text == "All exercises" {

                        self.findMaxValueWithSelection(type: "Volume", period: "year")
                   
                    } else {
                        self.findByExercise(criteria: "Volume", period: "year")
                    }
                    self.changeLabelsForVolume()
                }
                else {
                    if self.selectExercise.titleLabel?.text == "All exercises" {
                        self.findMaxValueWithSelection(type: "Weight", period: "year")
                    } else {
                        self.findByExercise(criteria: "Weight", period: "year")
                    }
                    self.changeLabelsForWeight()
                }
                self.lineChart.notifyDataSetChanged()
                
            }
        }
    }
    
    //MARK: - SET UP UI

    func setUpNavigationBarItems() {
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
      
        workoutTitle = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        workoutTitle.textAlignment = .left
        workoutTitle.text = "Progress Charts"
        workoutTitle.textColor = .white
        workoutTitle.font = UIFont.systemFont(ofSize: 28)
      
        titleView.addSubview(workoutTitle)
        navigationItem.titleView = titleView
    
        if let navigationBar = navigationController?.navigationBar {
            titleView.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor, constant: 10).isActive = true
        }
    }
    
    func setUpViews() {
        
        weightView.layer.cornerRadius = 10
        repsView.layer.cornerRadius = 10
        changeView.layer.cornerRadius = 10
        selectBy.layer.cornerRadius = 15
        
    }
    
    func controlSegmentSetUp() {
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.darkGray], for: .normal)
        let greenColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: greenColor], for: .selected)

        if let viewColor = view.backgroundColor {
        segmentedControl.clearBG(color: viewColor)
        }
    }
    
    
    //MARK: - SET CHART PROPERTIES
    
    func setChartProperties() {
 
        viewChart.layer.cornerRadius = 20
            lineChart.backgroundColor = .clear
            lineChart.extraBottomOffset = 25

            lineChart.rightAxis.enabled = false
        lineChart.scaleXEnabled = true
        
            let yAxis = lineChart.leftAxis
            yAxis.labelFont = .boldSystemFont(ofSize: 8)
            yAxis.setLabelCount(6, force: false)
            yAxis.axisMinimum = 0
            yAxis.labelTextColor = .white
            yAxis.axisLineColor = .clear
            yAxis.labelPosition = .outsideChart
            yAxis.drawGridLinesEnabled = true

          
        lineChart.xAxis.labelPosition = .bottom
        lineChart.xAxis.avoidFirstLastClippingEnabled = true
        lineChart.xAxis.granularity = 1
        lineChart.xAxis.labelRotationAngle = -45
        lineChart.xAxis.labelFont = .systemFont(ofSize: 12)
        lineChart.xAxis.axisLineColor = .white
        lineChart.xAxis.labelTextColor = .white
        lineChart.xAxis.drawGridLinesEnabled = false
        lineChart.legend.font = .systemFont(ofSize: 10)
//        lineChart.xAxis.setLabelCount(8, force: true)
        
        lineChart.legend.textColor = .white
  
        self.lineChart.animate(xAxisDuration: 0.04 * Double(self.lineChartEntry1.count), easingOption: .linear)

    }
    
    //MARK: - CHANING UI
    func changeLabelsForVolume() {
        weightLabel.text = "VOLUME"
        repsLabel.text = "TIME"
    }
    
    func changeLabelsForWeight() {
        weightLabel.text = "WEIGHT"
        repsLabel.text = "REPS"
    }
    }

extension UISegmentedControl {
    func clearBG(color: UIColor) {
        let clearImage = UIImage().imageWithColor(color: color)
        setBackgroundImage(clearImage, for: .normal, barMetrics: .default)
        setBackgroundImage(clearImage, for: .selected, barMetrics: .default)
        setDividerImage(clearImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
}

public extension UIImage {
        func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        guard let context = UIGraphicsGetCurrentContext() else { return UIImage()}
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}



extension String {

func convertFormatTime() -> String {
    
    let components: Array = self.components(separatedBy: ":")

    let hours = Int(components[0]) ?? 0
    let minutes = Int(components[1]) ?? 0
    let seconds = Int(components[2]) ?? 0
    
    if Int(components[1]) ?? 0 < 1{
        return "\(seconds) sec"
    }
    else if Int(components[0]) ?? 0 < 1 {
        return "\(minutes) min"
    }
    else {
        return "\(hours)h \(minutes)m"
    }
}
}



extension Calendar {

    typealias WeekBoundary = (startOfWeek: Date?, endOfWeek: Date?)

    func currentWeekBoundary() -> WeekBoundary? {
        return weekBoundary(for: Date())
    }
    
    
    func weekBoundary(for date: Date) -> WeekBoundary? {
        let components = dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        
        guard let startOfWeek = self.date(from: components) else {
            return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        
        let endOfWeekOffset = weekdaySymbols.count - 1
        let endOfWeekComponents = DateComponents(day: endOfWeekOffset, hour: 23, minute: 59, second: 59)
        guard let endOfWeek = self.date(byAdding: endOfWeekComponents, to: startOfWeek) else {
            return nil
        }
        return (startOfWeek, endOfWeek)
    }
    
//    func getFirstDayOfMonth(date: Date) -> (firstDay: Date?, lastDay: Date?){
//        let calendar = Calendar(identifier: .iso8601)
//
//
//
//        let firstDayComponents = calendar.dateComponents([.year, .month], from: date)
//        let firstDay = calendar.date(from: firstDayComponents)!
//
//        let lastDayComponents = DateComponents(month: 1, day: -1)
//        let lastDay = calendar.date(byAdding: lastDayComponents, to: firstDay)!
//
//        return (firstDay, lastDay)
//    }

}
//
//extension Date {
//    func firstDayOfMonth() -> Date {
//
//        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
//    }
//
//    func endDayOfMonth() -> Date {
//        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.firstDayOfMonth())!
//    }
//}

extension Date {
    
    func firstDateOfMonth() -> Date {
        
        let calendar = Calendar.current
        var startDate = Date()
        var interval: TimeInterval = 0
        _ = calendar.dateInterval(of: .month, start: &startDate, interval: &interval, for: self)
        return startDate
    }
    
    func lastDateOfMonth() -> Date {
        
        let calendar = Calendar.current
        let dayRange = calendar.range(of: .day, in: .month, for: self)!
        let dayLength = dayRange.upperBound
        var components = calendar.dateComponents([.year, .month, .day], from: self)
        components.day = dayLength
        
        return calendar.date(from: components)!
    }
}


//func findMaxValueForMonth() {
//
//        dateCount = 0
//        numberOfColors = 0
//        lineChartEntry1 = []
//        dataSets = []
//
//        let group2 = DispatchGroup()
//
//        referenceTimeInterval = Date().firstDateOfMonth().timeIntervalSince1970
//
//        let dateFormatter = DateFormatter()
//        lineChart.xAxis.valueFormatter = ChartXAxisFormatter(referenceTimeInterval: referenceTimeInterval, dateFormatter: dateFormatter)
//
//        var date: Date = Date()
//        for (key, value) in retrievedExerciseMax {
//            group2.enter()
//            numberOfColors += 1
//            lineChartEntry1 = []
//            for values in value {
//
//                if values.date >= Date().firstDateOfMonth() && values.date <= Date().lastDateOfMonth() {
//                dateCount += 1
//
//
//                let maxWeight = Double(values.maxWeight)
//                let volume = Double(values.volume)
//                let highlightedValue = HighlightedExercise(reps: values.maxReps, sets: values.sets, time: "")
//
//
//
//                let timeInterval = values.date.timeIntervalSince1970
//
//                let xValue = (timeInterval - referenceTimeInterval) / (3600 * 24)
//
//                lineChartEntry1.append(ChartDataEntry(x: xValue, y: Double(maxWeight), data: highlightedValue))
//                }
//                else {
//                    print("poza range")
//            }
//            }
//
//            lineChartEntry1.sort(by: { $0.x < $1.x})
//            let set = LineChartDataSet(entries: lineChartEntry1, label: "\(key)")
//            set.setColor(colors[numberOfColors])
//
//            dataSets.append(set)
//            group2.leave()
//        }
//
//        group2.notify(queue: .main) {
//            self.setData(entries: self.dataSets)
//        }
//
//    }

