



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
    
    let formatter = DateFormatter()
    var dateCount: Int = 0

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
    
    var retrievedExercise: [String: [RetrievedWorkout]] = [:]
    var arrayOfTitles: [String] = []
    var arrayOfTitleDocuments:  [String: [String]]? = [:]
    var retrievedExerciseMax: [String: [RetrievedWorkoutMax]] = [:]
    var retrievedAllWorkouts: [String: [RetrievedWorkoutsByVolume]] = [:]
    var retrievedByExercise: [RetrievedWorkoutsByExercise] = []
    var int = 0
    var highlightedValue: [HighlightedExercise] = []
    var checkIfWorkoutIsSelected: Bool = false
    var checkIfWeightCriteriaIsSelected: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lineChart.delegate = self
        retrieveArrays()
        retrieveDocumentsArray()
        
        setUpNavigationBarItems()
        controlSegmentSetUp()
        setUpViews()
        getData(title: "Workout4")

    }
 
    
    //MARK: - POP UP DATA
    
    func changeLabelsForVolume() {
        
        weightLabel.text = "VOLUME"
        repsLabel.text = "TIME"
     
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
//                    self.getData(title: text)
                    self.getDataByVolume(titles: [text])
                    self.selectExercise.isUserInteractionEnabled = true
                    self.selectByButton.isUserInteractionEnabled = false
                }
//                self.selectExercise.setTitle("All exercises", for: .normal)
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
                    print("OK OK")
                }
                
                self.lineChart.notifyDataSetChanged()
                self.selectByButton.isUserInteractionEnabled = true
            }
            }
            
        }
        
        if segue.identifier == "toCriteriaSelection" {
            let popup = segue.destination as! CriteriaOfSelectViewController
            popup.selectedCriteria = { criteria in
                
                self.selectByButton.setTitle(criteria, for: .normal)
                
                if criteria == "Volume" {
                    if self.selectExercise.titleLabel?.text == "All exercises" {
//                       self.findTrainingVolume(ex: [self.workoutTitle.text!])
                        self.findMaxValue(type: "Volume")
                   
                    } else {
                        self.findByExercise(criteria: "Volume")
                    }
                    self.changeLabelsForVolume()
                } else {
                    if self.selectExercise.titleLabel?.text == "All exercises" {
                        self.findMaxValue(type: "Weight")
                    } else {
                        self.findByExercise(criteria: "Weight")
                    }

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
            }
            
            
            
            if entryData.time == "" {
            let repsEntryData = String(entryData.reps)
            repsValue.text = repsEntryData
                weightValue.text = "\(stringValue)kg"
            }
            else {
                repsValue.text = entryData.time.convertFormatTime()
                weightValue.text = "\(stringValue)"
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
        
        if let minTimeInterval = (retrievedExerciseMax.compactMap({$0.value}).compactMap({$0.compactMap({$0.date})}).min(by: {$0[0].timeIntervalSince1970 < $1[0].timeIntervalSince1970}))?.min() {
            referenceTimeInterval = minTimeInterval.timeIntervalSince1970
        }
        let dateFormatter = DateFormatter()
        lineChart.xAxis.valueFormatter = ChartXAxisFormatter(referenceTimeInterval: referenceTimeInterval, dateFormatter: dateFormatter)
    }
    
    func findVolumeForAllExercises() {
        
        
        
    }
    
    
    func findTrainingVolume(ex: [String]) {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"

            dateCount = 0
            numberOfColors = 0
           
            lineChartEntry1 = []
            dataSets = []
            let group2 = DispatchGroup()
            
            
            for (key, value) in retrievedAllWorkouts {
               
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
    
    func findByExercise(criteria: String) {
        
        lineChartEntry1 = []
        dataSets = []
        
        let group2 = DispatchGroup()
        
        var titleOfExercise: String = ""
     
        
        for value in retrievedByExercise {
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
        print("setTETETETETE \([set])")
        }
        
        
        
    }

    func findMaxValue(type: String) {
        
        dateCount = 0
       numberOfColors = 0
        lineChartEntry1 = []
        dataSets = []
        let group2 = DispatchGroup()
        
        for (key, value) in retrievedExerciseMax {
            group2.enter()
            numberOfColors += 1
            lineChartEntry1 = []
            for values in value {
               
                let date = values.date

                dateCount += 1
                let timeInterval = date.timeIntervalSince1970
                let xValue = (timeInterval - referenceTimeInterval) / (3600 * 24)
                
                let maxWeight = Double(values.maxWeight)
                let volume = Double(values.volume)
                let highlightedValue = HighlightedExercise(reps: values.maxReps, sets: values.sets, time: "")
                
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
            print("DATA SETs \(self.dataSets)")
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
//        exercisesForSelectedWorkout = []
        let service = Service()
        if let workoutTitle = workoutTitle.text {
        service.getDocumentsTitle(workout: workoutTitle) { (result) in
            self.exercisesForSelectedWorkout = result
        }
        }
    }
    
    func getDataByVolume(titles: [String]) {
        retrievedAllWorkouts = [:]
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.timeZone = TimeZone.current
        let group2 = DispatchGroup()
        
        for title in titles {
            group2.enter()
        db.collection("users").document("\(user!.uid)").collection("WorkoutsName").document("\(title)").collection("Calendar").getDocuments(completion:  { (querySnapshot, error) in
            if let error = error {
                print("\(error.localizedDescription)")
            }
            else {
                if let documents = querySnapshot?.documents {
                    
                    for doc in documents {
                        
                        let data = doc.data()
                        
                        if let volume = data["Volume"] as? Int, let reps = data["Reps"] as? Int, let time = data["Time"] as? String, let weight = data["Weight"] as? Int {

                            let dateDocumentID = self.formatter.date(from: doc.documentID)
        
                            guard let dateConverted = dateDocumentID?.removeTimeStamp else {return}
   
//                            guard let dateFormattedToDate = self.formatter.date(from: doc.documentID) else {return}
                         
                            let newData = RetrievedWorkoutsByVolume(reps: reps, time: time, volume: volume, weight: weight, date: dateConverted)
                            
                         
                            
                            self.retrievedAllWorkouts["\(title)", default: []].append(newData)
                        }
        
                    }
                }
                group2.leave()
            }
        })
            
        }
      
        group2.notify(queue: .main) {
            print("ALL WORKOUTS \(self.retrievedAllWorkouts)")
            self.convertDateForAxis()
            self.findTrainingVolume(ex: titles)
        }
    

    }
    
    func getDataByExercise(title: String, document: String) {
      
        retrievedByExercise = []
        
        print("title \(title) document \(document)")
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        let group = DispatchGroup()
        group.enter()
        db.collection("users").document("\(user!.uid)").collection("WorkoutsName").document(title).collection("Exercises").document(document).collection("History").getDocuments(completion:  { (querySnapshot, error) in
            if let error = error {
                print("\(error.localizedDescription)")
            }
            else {
                
                if let documents = querySnapshot?.documents {
                   
                    for doc in documents {
                        
                        let data = doc.data()
                        
                        if let docSets = data["Sets"] as? [String: [String:String]], let max = data["Max"] as? [String:Int] {
                            
                            if let date = data["date"] as? String, let maxWeight = max["weight"] , let maxReps = max["doneReps"], let volume = data["Volume"] as? Int {
                                
                                guard let dateFormattedToDate = self.formatter.date(from: date) else {return}
                               
                                let newModel = RetrievedWorkoutsByExercise(exerciseTitle: "\(document)", sets: docSets.count, maxWeight: maxWeight, maxReps: maxReps, date: dateFormattedToDate, volume: volume)
                              
                                self.retrievedByExercise.append(newModel)
                                print("DONE DONE")
                    }
                }
                 
            }
                 
        }
                group.leave()
            }
        })
        group.notify(queue: .main) {
            print("rere \(self.retrievedByExercise)")
        self.convertDateForAxis()
            self.findByExercise(criteria: "Weight")
            print("OLABOGAA")
        }
        print("TOTO \(retrievedByExercise)")
    }

    func getData(title: String) {
        
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        let group = DispatchGroup()
        
//        retrievedExercise = [:]
        retrievedExerciseMax = [:]

        if let dictionaryOfTitleDocuments = arrayOfTitleDocuments {
           
        for document in dictionaryOfTitleDocuments[title]! {
            group.enter()
        db.collection("users").document("\(user!.uid)").collection("WorkoutsName").document("\(title)").collection("Exercises").document("\(document)").collection("History").getDocuments(completion:  { (querySnapshot, error) in
            if let error = error {
                print("\(error.localizedDescription)")
            }
            else {
                if let documents = querySnapshot?.documents {
                    
                    for doc in documents {
                        self.int = 0
                    
                        let data = doc.data()
        
                        if let docSets = data["Sets"] as? [String: [String:String]], let max = data["Max"] as? [String:Int] {
                            
                            if let date = data["date"] as? String, let maxWeight = max["weight"] , let maxReps = max["doneReps"], let volume = data["Volume"] as? Int {
                                
                                guard let dateFormattedToDate = self.formatter.date(from: date) else {return}
                               
                                let newModelMax = RetrievedWorkoutMax(workoutTitle: title, exerciseTitle: "\(document)", sets: (docSets.count), maxWeight: maxWeight, maxReps: maxReps,date: dateFormattedToDate, volume: volume)

                                self.retrievedExerciseMax["\(document)", default: []].append(newModelMax)

                            }
                            }
                        }
                   
        }
                group.leave()
    }
         
})
        
}
        
    }
         
            group.notify(queue: .main) {
                self.convertDateForAxis()
                self.findMaxValue(type: "Weight")
                print("Retrieved \(self.retrievedExerciseMax)")
                }
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



//let minimumTimeInterval = retrievedExerciseMax.compactMap({$0.value}).compactMap({$0.compactMap({$0.date})})
//let letmin1 = minimumTimeInterval.min(by: {$0[0] < $1[0]})?.min()
//print("letmin1 \(letmin1)")
//let min = minimumTimeInterval.sorted(by: {$0[0] < $1[0] })
//print("min FIRST \(min.first)")

//
//
//var retrievedExercise: [String: [RetrievedWorkout]] = [:]
////    @IBOutlet weak var lineChart2: LineChartView!
//@IBOutlet weak var lineChart: LineChartView! = {
//    let chartView = LineChartView()
//    chartView.backgroundColor = .clear
//
//    chartView.rightAxis.enabled = false
//
//    let yAxis = chartView.leftAxis
////        yAxis.drawZeroLineEnabled = false
////        yAxis.drawGridLinesEnabled = false
//    yAxis.labelFont = .boldSystemFont(ofSize: 12)
//    yAxis.setLabelCount(10, force: false)
//    yAxis.labelTextColor = .white
//    yAxis.axisLineColor = .clear
//    yAxis.labelPosition = .outsideChart
//    yAxis.drawGridLinesEnabled = true
//
//
//    chartView.xAxis.labelPosition = .bottom
//    chartView.xAxis.labelFont = .boldSystemFont(ofSize: 8)
////        chartView.xAxis.setLabelCount(retrievedExercise.values.count, force: false)
//    chartView.xAxis.axisLineColor = .white
//    chartView.xAxis.labelTextColor = .white
//    chartView.xAxis.drawGridLinesEnabled = false
////        chartView.animate(xAxisDuration: 1)
//
//    return chartView
//}()

//    func appendData() {
//
////        let set = LineChartDataSet(entries: self.dataEntry, label: "Workout4")
//
////        var dataSets: [LineChartDataSet] = [LineChartDataSet]()
//
//        var lineChartEntry1 = [ChartDataEntry]()
//        print("RETRIEVED \(retrievedExercise)")
//        let group2 = DispatchGroup()
//
//        for x in 0..<retrievedExercise.count {
//            print("\(x) TO x")
//            group2.enter()
//            let newData = retrievedExercise[x]
//            let weight = newData.weight
//
//
//            lineChartEntry1.append(ChartDataEntry(x: Double(weight) ?? 0, y: Double(weight) ?? 0))
//
//            lineChartEntry1.sort(by: { $0.x < $1.x})
//
//            let set = LineChartDataSet(entries: lineChartEntry1, label: "\(retrievedExercise[x].exerciseTitle)")
//            dataSets.append(set)
//            print("APPENDED")
////            dataEntry.append(ChartDataEntry(x: Double(weight) ?? 0, y: Double(weight) ?? 0))
//            group2.leave()
//        }
//
//        group2.notify(queue: .main) {
//            self.setData(entries: self.dataSets)
////            self.dataEntry.sort(by: { $0.x < $1.x})
////            self.setData(entries: self.dataEntry)
//            print("DATA SETS \(self.dataSets)")
////            self.dataSets.sort(by: { $0.x < $1.x})
//
//
//        }
//
//        print("DATA ENTRY \(dataEntry)")
//    }

//    let minimumTimeInterval = retrievedExerciseMax.values.compactMap({$0})
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
