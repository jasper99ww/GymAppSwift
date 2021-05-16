



struct RetrievedWorkout {
    let workoutTitle: String
    let exerciseTitle: String
    let weight: String
    let reps: String
    let sets: String
    let date: Date
   
    
}

struct RetrievedWorkoutMax {
    
    let workoutTitle: String
    let exerciseTitle: String
    let sets: Int
    let maxWeight: Int
    let maxReps: Int
    let date: Date
//    let max: [String:String]

}

struct HighlightedExercise {
    
    let reps: Int
    let sets: Int
    
}

import UIKit
import Charts
import Firebase

class ProgressChartViewController: UIViewController, ChartViewDelegate {

    var workoutTitle = UILabel()
    var lineChartEntry1 = [ChartDataEntry]()
    @IBOutlet weak var selectAlert: UIBarButtonItem!
    let formatter = DateFormatter()
    var dateCount: Int = 0
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var retrievedExercise: [String: [RetrievedWorkout]] = [:]
//    @IBOutlet weak var lineChart2: LineChartView!
    @IBOutlet weak var lineChart: LineChartView!
    @IBOutlet weak var viewChart: UIView!
    @IBOutlet weak var selectedExercise: UILabel!
    
    var dataEntry: [ChartDataEntry] = []
    
    var dataSets: [LineChartDataSet] = [LineChartDataSet]()
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    var arrayOfTitles: [String] = []
    var arrayOfTitleDocuments:  [String: [String]]? = [:]
    
    var retrievedExerciseMax: [String: [RetrievedWorkoutMax]] = [:]
    
    var int = 0
    
    
    @IBOutlet weak var weightValue: UILabel!
    @IBOutlet weak var repsValue: UILabel!
    @IBOutlet weak var changeValue: UILabel!
    @IBOutlet weak var weightView: UIView!
    @IBOutlet weak var repsView: UIView!
    @IBOutlet weak var changeView: UIView!
    
    @IBOutlet weak var selectBy: UIView!
    @IBOutlet weak var selectByButton: UIButton!
    var highlightedValue: [HighlightedExercise] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lineChart.delegate = self
        retrieveArrays()
        retrieveDocumentsArray()
        
        setUpNavigationBarItems()
        controlSegmentSetUp()
        setUpViews()
        getData(title: "Workout4")
        
        
//        setChartProperties()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
          
       
    }
    
    override func viewDidLayoutSubviews() {
    

  
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("RETRIEVED WORKOUT MAX \(retrievedExerciseMax)")
        print("RETRIEVED WORKOUT N \(retrievedExercise)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWorkoutSelection" {
            let popup = segue.destination as! ProgressPopUpView
            popup.selectedWorkoutChart = { text in

                self.workoutTitle.text = text
               
                self.getData(title: text)
                self.lineChart.notifyDataSetChanged()
//                self.setChartProperties()
            }
        
        }
    }

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

        print("DATE COUNT \(dateCount)")
        lineChart.xAxis.labelFont = .systemFont(ofSize: 12)
        lineChart.xAxis.axisLineColor = .white
        lineChart.xAxis.labelTextColor = .white
        lineChart.xAxis.drawGridLinesEnabled = false

        lineChart.legend.font = .systemFont(ofSize: 10)
        
        lineChart.legend.textColor = .white
        
        
//        self.lineChart.animate(xAxisDuration: 0.04 * Double(self.lineChartEntry1.count))
        self.lineChart.animate(xAxisDuration: 0.04 * Double(self.lineChartEntry1.count), easingOption: .easeInElastic)
//        self.lineChart.animate(xAxisDuration: 0.04 * Double(self.lineChartEntry1.count), yAxisDuration: 0.04 * Double(self.lineChartEntry1.count))
       
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        let dataSetIndex = highlight.dataSetIndex

        let stringValue = String(format: "%.0f", highlight.y) 
        
        if let entryData = entry.data as? HighlightedExercise {
            
            // ZROBIC STRZALKE ZIELONA I CZERWONA W ZALEZNOSCI OD SPADKU
            
            if entry.x > 0 {
                let previousEntry = dataSets[dataSetIndex][Int(entry.x - 1)]
                print("first  \(Int(previousEntry.y))")
                print("second \(Int(highlight.y))")
                let previousEntryData = Int((((highlight.y) - (previousEntry.y)) / (previousEntry.y)) * 100)
                changeValue.text = String("\(previousEntryData)%")
                print("ENTRY \(previousEntryData)")
                
                if previousEntryData > 0 {
                    changeValue.textColor = .green
                    changeValue.text = String("+\(previousEntryData)%")
//                    arrowImage.image = UIImage(systemName: "arrow.up")
//                    arrowImage.tintColor = .green
                } else {
//                    arrowImage.image = UIImage(systemName: "arrow.down")
//                    arrowImage.tintColor = .red
//                    changeValue.text = String("\(previousEntryData)%")
                    changeValue.textColor = .red
                }
                
            }
            
            let repsEntryData = String(entryData.reps)
            repsValue.text = repsEntryData
            weightValue.text = "\(stringValue)kg"
        
        
            
//            let percentageProgress = (highlight.y)
            
        }
        
       
        
        
//        let previousEntry = entry.x.advanced(by: -1) as? ChartDataEntry
//        let previousEntryData = previousEntry?.data as? HighlightedExercise
//        let pr = previousEntryData?.reps
//        let pr2 = previousEntryData?.sets
//        let pr3 = entry.y.advanced(by: -1)
//        print("PREVIOUS KG \(pr3)")
//        print("PREVIOUS REPS \(pr)")
//        print("PREVIOUS SETS \(pr2)")
        
    }
    
    
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

   
    func findMaxValue() {
        dateCount = 0
        var referenceTimeInterval: TimeInterval = 0

        if let minTimeInterval = (retrievedExerciseMax.compactMap({$0.value}).compactMap({$0.compactMap({$0.date})}).min(by: {$0[0].timeIntervalSince1970 < $1[0].timeIntervalSince1970}))?.min() {
            
            referenceTimeInterval = minTimeInterval.timeIntervalSince1970

        }

       
        lineChartEntry1 = []
        dataSets = []
        let group2 = DispatchGroup()

        
        let dateFormatter = DateFormatter()
        
        lineChart.xAxis.valueFormatter = ChartXAxisFormatter(referenceTimeInterval: referenceTimeInterval, dateFormatter: dateFormatter)
            
        var numberOfColors = 0
        let colors = [UIColor.red, UIColor.green, UIColor.purple, UIColor.gray,  UIColor.white]
        
        for (key, value) in retrievedExerciseMax {
            group2.enter()
            numberOfColors += 1
            lineChartEntry1 = []
            for values in value {
               
                let date = values.date
//                let setsInt = Int(values.sets)
                dateCount += 1
                let timeInterval = date.timeIntervalSince1970
                let xValue = (timeInterval - referenceTimeInterval) / (3600 * 24)
                
                let maxWeight = Double(values.maxWeight)
                
                let highlightedValue = HighlightedExercise(reps: values.maxReps, sets: values.sets)
                
                lineChartEntry1.append(ChartDataEntry(x: xValue, y: Double(maxWeight), data: highlightedValue))
                
            }
            
            lineChartEntry1.sort(by: { $0.x < $1.x})

            let set = LineChartDataSet(entries: lineChartEntry1, label: "\(key)")
            set.setColor(colors[numberOfColors])
                dataSets.append(set)
            
            group2.leave()
        }
        
        group2.notify(queue: .main) {
            self.setData(entries: self.dataSets)
            print("DATA \(self.dataSets.count)")
            print("DATA SETS \(self.dataSets)")
            print("date count \(self.dateCount)")
        }
    }
        
    
    
    func getData(title: String) {
        
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        let group = DispatchGroup()
        
        retrievedExercise = [:]
        retrievedExerciseMax = [:]
//        for title in arrayOfTitles {
        if let dictionaryOfTitleDocuments = arrayOfTitleDocuments {
           
        for document in dictionaryOfTitleDocuments["\(title)"]! {
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
                            
                            if let date = data["date"] as? String, let maxWeight = max["weight"], let maxReps = max["doneReps"] {
                                
                                guard let dateFormattedToDate = self.formatter.date(from: date) else {return}
                               
                                let newModelMax = RetrievedWorkoutMax(workoutTitle: "\(title)", exerciseTitle: "\(document)", sets: (docSets.count), maxWeight: maxWeight, maxReps: maxReps,date: dateFormattedToDate)
                                self.retrievedExerciseMax["\(document)", default: []].append(newModelMax)
                                
                
                            for _ in docSets {
                            self.int += 1
                                if let weight = docSets["\(self.int)"]?["kg"], let reps = docSets["\(self.int)"]?["reps"] {
                                    
                                    let newModel = RetrievedWorkout(workoutTitle: "\(title)", exerciseTitle: "\(document)", weight: weight, reps: reps, sets: "\(self.int)", date: dateFormattedToDate)

                            self.retrievedExercise["\(document)", default: []].append(newModel)
                         
                        }
                        }
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
                print("OK DONE DONE")
                print("RETRIEVED \(self.retrievedExercise)")
                self.findMaxValue()
            }
}
    
    
//    }
    
    func retrieveArrays() {
        
        if let arrayTitles = UserDefaults.standard.object(forKey: "workoutsName") as? [String] {
            arrayOfTitles = arrayTitles
        }
        print("\(arrayOfTitles)")
        
    }
    
    func retrieveDocumentsArray() {
        
        if let arrayTitleDocuments = UserDefaults.standard.object(forKey: "dictionaryOfTitleDocuments") as? [String: [String]] {
            arrayOfTitleDocuments = arrayTitleDocuments
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
