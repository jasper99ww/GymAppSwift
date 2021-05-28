



struct RetrievedWorkout {
    let workoutTitle: String
    let exerciseTitle: String
    let sets: String
    let date: Date
    let volume: Int
    
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
    @IBOutlet weak var selectAlert: UIBarButtonItem!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var lineChart: LineChartView!
    @IBOutlet weak var viewChart: UIView!
    @IBOutlet weak var selectedExercise: UILabel!
    
    
    @IBOutlet weak var weightValue: UILabel!
    @IBOutlet weak var repsValue: UILabel!
    @IBOutlet weak var changeValue: UILabel!
    @IBOutlet weak var weightView: UIView!
    @IBOutlet weak var repsView: UIView!
    @IBOutlet weak var changeView: UIView!
    @IBOutlet weak var selectBy: UIView!
    @IBOutlet weak var selectByButton: UIButton!
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
    var int = 0
    var highlightedValue: [HighlightedExercise] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        lineChart.delegate = self
        retrieveArrays()
        retrieveDocumentsArray()
        
        setUpNavigationBarItems()
        controlSegmentSetUp()
        setUpViews()
        getData(title: ["Workout4"])

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("ebe \(retrievedExercise)")
        print("eb1e \(retrievedExerciseMax)")
    }
    
    
    //MARK: - POP UP DATA
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWorkoutSelection" {
            let popup = segue.destination as! ProgressPopUpView
            popup.selectedWorkoutChart = { text in

                self.workoutTitle.text = text
                if text == "ALL WORKOUTS" {
                    self.getData(title: self.arrayOfTitles)
                } else {
                    self.getData(title: [text])
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
            lineChart.extraBottomOffset = 15

            lineChart.rightAxis.enabled = false
        
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

        lineChart.xAxis.labelFont = .systemFont(ofSize: 12)
        lineChart.xAxis.axisLineColor = .white
        lineChart.xAxis.labelTextColor = .white
        lineChart.xAxis.drawGridLinesEnabled = false
        lineChart.legend.font = .systemFont(ofSize: 10)
        
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
            
            let repsEntryData = String(entryData.reps)
            repsValue.text = repsEntryData
            weightValue.text = "\(stringValue)kg"
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

        func findTrainingVolume() {
            
            dateCount = 0
           
            
            lineChartEntry1 = []
            dataSets = []
            let group2 = DispatchGroup()
            
     
           
            
            for (key, value) in retrievedExercise {
                group2.enter()
                numberOfColors += 1
                lineChartEntry1 = []
                for values in value {
//                    print("VALUES \(value)")
                    let date = values.date

                    dateCount += 1
                    let timeInterval = date.timeIntervalSince1970
                    let xValue = (timeInterval - referenceTimeInterval) / (3600 * 24)
                    
                    let volume = values.volume
                                        
                    lineChartEntry1.append(ChartDataEntry(x: xValue, y: Double(volume)))
                
                }
                
                lineChartEntry1.sort(by: { $0.x < $1.x})
                
            
                print("LINE CHART ENTRY BBBBBBBBBBBOO \(lineChartEntry1)")
                let set = LineChartDataSet(entries: lineChartEntry1, label: "\(key)")
                print(" A TO SET \(set)")
//                set.setColor(colors[numberOfColors])
                
                dataSets.append(set)
                group2.leave()
            }
            
            group2.notify(queue: .main) {
                self.setData(entries: self.dataSets)
            }
//            lineChartEntry1 = []
//            dataSets = []
//
//            let group2 = DispatchGroup()
//
//            for (key,value) in retrievedExercise {
//
//                // Trzeba workouty pozbierac do kupy i dopiero append
//                group2.enter()
//                numberOfColors += 1
//                for values in value {
//                    print("value \(value)")
//                let date = values.date
//
//                let timeInterval = date.timeIntervalSince1970
//                let xValue = (timeInterval - referenceTimeInterval) / (3600 * 24)
//
//                    let volume = values.volume
//
//                    lineChartEntry1.append(ChartDataEntry(x: xValue, y: Double(volume)))
//                    print("Volume \(volume)")
//                }
//
//                lineChartEntry1.sort(by: { $0.x < $1.x})
//
//
//                let set = LineChartDataSet(entries: lineChartEntry1, label: "\(key)")
//                set.setColor(colors[numberOfColors])
//                dataSets.append(set)
//
//                group2.leave()
//            }
//
//            group2.notify(queue: .main) {
//                self.setData(entries: self.dataSets)
//                print("DYMY DATA SET \(self.dataSets)")
//
//
//            }
//
//            print("DATA ENTRY \(dataEntry)")
        }

    func findMaxValue() {
        
        dateCount = 0
       
        
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
                
                let highlightedValue = HighlightedExercise(reps: values.maxReps, sets: values.sets)
                
                lineChartEntry1.append(ChartDataEntry(x: xValue, y: Double(maxWeight), data: highlightedValue))
            }
            
            lineChartEntry1.sort(by: { $0.x < $1.x})
            let set = LineChartDataSet(entries: lineChartEntry1, label: "\(key)")
//            set.setColor(colors[numberOfColors])
            
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

    func getData(title: [String]) {
        
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        let group = DispatchGroup()
        
        retrievedExercise = [:]
        retrievedExerciseMax = [:]

        if let dictionaryOfTitleDocuments = arrayOfTitleDocuments {
            for titles in title {
        for document in dictionaryOfTitleDocuments[titles]! {
            group.enter()
        db.collection("users").document("\(user!.uid)").collection("WorkoutsName").document("\(titles)").collection("Exercises").document("\(document)").collection("History").getDocuments(completion:  { (querySnapshot, error) in
            if let error = error {
                print("\(error.localizedDescription)")
            }
            else {
                if let documents = querySnapshot?.documents {
                    
                    for doc in documents {
                        self.int = 0
                    
                        let data = doc.data()
        
                        if let docSets = data["Sets"] as? [String: [String:String]], let max = data["Max"] as? [String:Int], let volume = data["Volume"] as? Int {
                            
                            if let date = data["date"] as? String, let maxWeight = max["weight"], let maxReps = max["doneReps"] {
                                
                                guard let dateFormattedToDate = self.formatter.date(from: date) else {return}
                               
                                let newModelMax = RetrievedWorkoutMax(workoutTitle: titles, exerciseTitle: "\(document)", sets: (docSets.count), maxWeight: maxWeight, maxReps: maxReps,date: dateFormattedToDate, volume: volume)
                                let newModel = RetrievedWorkout(workoutTitle: titles, exerciseTitle: "\(document)", sets: ("\(docSets.count)"), date: dateFormattedToDate, volume: volume)
                                self.retrievedExerciseMax["\(document)", default: []].append(newModelMax)
                                self.retrievedExercise["\(titles)", default: []].append(newModel)
                
//                            for _ in docSets {
//                            self.int += 1
//                                if let weight = docSets["\(self.int)"]?["kg"], let reps = docSets["\(self.int)"]?["reps"] {
//
//                                    let newModel = RetrievedWorkout(workoutTitle: "\(title)", exerciseTitle: "\(document)", weight: weight, reps: reps, sets: "\(self.int)", date: dateFormattedToDate, volume: volume)
//
//                            self.retrievedExercise["\(titles)", default: []].append(newModel)
//
//                        }
//                        }
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
                if title == self.arrayOfTitles {
                self.findTrainingVolume()
            }
                else {
                    self.findMaxValue()
                }
}
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
