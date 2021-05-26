



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
    let sets: String
    let max: Int
    let date: Date
//    let max: [String:String]
    
    
    
}

import UIKit
import Charts
import Firebase

class ProgressChartViewController: UIViewController, ChartViewDelegate {

    @IBOutlet weak var weightView: UIView!
    @IBOutlet weak var repsView: UIView!
    @IBOutlet weak var setsView: UIView!
    @IBOutlet weak var changeView: UIView!
    let formatter = DateFormatter()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveArrays()
        retrieveDocumentsArray()
        
        setUpNavigationBarItems()
        
        getData(title: "Workout4")
        
        lineChart.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        setChartProperties()
    }

    func setUpNavigationBarItems() {

        let workoutTitle = UILabel()
        workoutTitle.text = "Upper"
        workoutTitle.textColor = .white
        navigationItem.title = workoutTitle.text
        cornerRadiusForViews()
    }
    
    func cornerRadiusForViews() {
        weightView.layer.cornerRadius = 20
        repsView.layer.cornerRadius = 20
        setsView.layer.cornerRadius = 20
        changeView.layer.cornerRadius = 20
    }
    
    
    func setChartProperties() {
 
        viewChart.layer.cornerRadius = 20
            lineChart.backgroundColor = .clear
            
            lineChart.rightAxis.enabled = false
        
            let yAxis = lineChart.leftAxis
            yAxis.labelFont = .boldSystemFont(ofSize: 8)
        yAxis.setLabelCount(6, force: false)
            yAxis.labelTextColor = .white
            yAxis.axisLineColor = .clear
            yAxis.labelPosition = .outsideChart
            yAxis.drawGridLinesEnabled = true

          
            lineChart.xAxis.labelPosition = .bottom
        lineChart.xAxis.labelFont = .boldSystemFont(ofSize: 8)
        lineChart.xAxis.setLabelCount(retrievedExercise.values.count, force: false)
        lineChart.xAxis.axisLineColor = .white
        lineChart.xAxis.labelTextColor = .white
        lineChart.xAxis.drawGridLinesEnabled = false
    //        chartView.animate(xAxisDuration: 1)
    
    }
    
    func setData(entries: [LineChartDataSet]) {

        for set in entries {

        set.mode = .cubicBezier
        set.drawCirclesEnabled = true
        set.circleColors = set.colors
        set.drawCircleHoleEnabled = false
        set.lineWidth = 3
        
//        set.fill = set.colors
//        set.fillAlpha = 0.6
//        set.drawFilledEnabled = true
            
        set.drawHorizontalHighlightIndicatorEnabled = false
        set.highlightColor = .red
        }
//        let data = LineChartData(dataSet: set)
        let data = LineChartData(dataSets: entries)
        lineChart.data = data
        data.setDrawValues(true)

    }

   

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
    
    func findMaxValue() {
        
        var referenceTimeInterval: TimeInterval = 0

        if let minTimeInterval = (retrievedExerciseMax.compactMap({$0.value}).compactMap({$0.compactMap({$0.date})}).min(by: {$0[0].timeIntervalSince1970 < $1[0].timeIntervalSince1970}))?.min() {
            
            referenceTimeInterval = minTimeInterval.timeIntervalSince1970

        }

        var lineChartEntry1 = [ChartDataEntry]()
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
                let timeInterval = date.timeIntervalSince1970
                let xValue = (timeInterval - referenceTimeInterval) / (3600 * 24)
                
                let maxWeight = Double(values.max)

                lineChartEntry1.append(ChartDataEntry(x: xValue, y: Double(maxWeight)))
                
            }
            
            lineChartEntry1.sort(by: { $0.x < $1.x})

            let set = LineChartDataSet(entries: lineChartEntry1, label: "\(key)")
            set.setColor(colors[numberOfColors])
                dataSets.append(set)
            
            group2.leave()
        }
        
        group2.notify(queue: .main) {
            self.setData(entries: self.dataSets)

            print("DATA SETS \(self.dataSets)")
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
        
                        if let docSets = data["Sets"] as? [String: [String:String]] {
                            
                            if let date = data["date"] as? String, let max = data["Max"] as? Int {
                                
                                guard let dateFormattedToDate = self.formatter.date(from: date) else {return}
                                
                                let newModelMax = RetrievedWorkoutMax(workoutTitle: "\(title)", exerciseTitle: "\(document)", sets: "\(docSets.count)", max: max, date: dateFormattedToDate)
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

extension UINavigationItem {
    func setTitle(title:String, subtitle:String) {
        
        let one = UILabel()
        one.text = title
        one.font = UIFont.systemFont(ofSize: 17)
        one.sizeToFit()
        
        let two = UILabel()
        two.text = subtitle
        two.font = UIFont.systemFont(ofSize: 12)
        two.textAlignment = .center
        two.sizeToFit()
        
        let stackView = UIStackView(arrangedSubviews: [one, two])
        stackView.distribution = .equalCentering
        stackView.axis = .vertical
        stackView.alignment = .center
        
        let width = max(one.frame.size.width, two.frame.size.width)
        stackView.frame = CGRect(x: 0, y: 0, width: width, height: 35)
        
        one.sizeToFit()
        two.sizeToFit()
        
        self.titleView = stackView
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
