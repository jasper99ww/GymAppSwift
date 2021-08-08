//
//  ProgressPopUpView.swift
//  GymLog
//
//  Created by Kacper P on 29/05/2021.
//

import UIKit

class ProgressPopUpView: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
        
    var workouts: [String] = ["FBW", "UPPER", "LOWER"]
    let screenWidth = UIScreen.main.bounds.width - 20
    let screenHeight = UIScreen.main.bounds.height / 7
    let vc = UIViewController()
    var selectedRow = 0
    var selectedWorkoutChart: ((_ data: String) -> ())?

    override func viewDidLoad() {
     getWorkoutsTitle()
      alert()
    }

    func getWorkoutsTitle() {
      if let workoutsRetrieved = UserDefaults.standard.object(forKey: "workoutsName") as? [String] {
     workouts = workoutsRetrieved
        workouts.insert("All workouts", at: 0)
      }
      print("\(workouts) TO workouts")
    }

    func alert() {

      vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)

      let alert = UIAlertController(title: "Select Exercise", message: "", preferredStyle: .actionSheet)
      let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 200))
      pickerView.dataSource = self
      pickerView.delegate = self
      pickerView.selectRow(selectedRow, inComponent: 0, animated: false)
      
      
      alert.view.addSubview(pickerView)
      pickerView.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor).isActive = true
      
      let TitleString = NSAttributedString(string: "Select Exercise", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.backgroundColor : UIColor.clear])
      alert.setValue(TitleString, forKey: "attributedTitle")
      alert.setValue(vc, forKey: "contentViewController")
     
      
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel,handler: { (UIAlertAction) in
          self.dismiss(animated: true, completion: nil)
          
      })
      
      cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
      
      alert.addAction(cancelAction)

      
      alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { (UIAlertAction) in
          self.dismiss(animated: true, completion: nil)
          self.selectedRow = pickerView.selectedRow(inComponent: 0)
          let selected = self.workouts[self.selectedRow]
          print("\(selected) SELECTED")
          self.selectedWorkoutChart?(selected)
          
      }))
      
      self.present(alert, animated: true, completion: nil)
      
    }


    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
      return workouts[row]
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
      return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      return workouts.count
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
      return 50
    }


    }

    
    

//
//        var dataSource: [String] = ["FBW", "UPPER", "LOWER"]
//    var exercises: [String] = ["BLA", "dA", "De"]
//        let screenWidth = UIScreen.main.bounds.width - 20
//        let screenHeight = UIScreen.main.bounds.height / 7
//        let vc = UIViewController()
//        var selectedRow = 0
//        var selectedWorkout: ((_ data: String) -> ())?
//
//        override func viewDidLoad() {
//           getWorkoutsTitle()
//            alert()
//        }
//
//        func getWorkoutsTitle() {
//            if let workoutName = UserDefaults.standard.object(forKey: "workoutsName") as? [String] {
//            dataSource = workoutName
//                dataSource.insert("ALL WORKOUTS", at: 0)
//            }
//            print("\(dataSource) TO DATASOURCE")
//        }
//
//        func alert() {
//
//            vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
//
//            let alert = UIAlertController(title: "Select workout", message: "", preferredStyle: .actionSheet)
//
//            let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 200))
//            stackView.translatesAutoresizingMaskIntoConstraints = false
//            stackView.axis = NSLayoutConstraint.Axis.horizontal
//            stackView.distribution = UIStackView.Distribution.fillEqually
//            stackView.alignment = UIStackView.Alignment.fill
////            stackView.spacing = 10
//
//            let pickerView1 = UIPickerView(frame: CGRect(x: 0, y: 0, width: 0, height: 100))
//
//            pickerView1.dataSource = self
//            pickerView1.delegate = self
//            pickerView1.selectRow(selectedRow, inComponent: 0, animated: false)
//            pickerView1.tag = 0
//
//            let pickerView2 = UIPickerView(frame: CGRect(x: 0, y: 0, width: 0, height: 100))
//            pickerView2.dataSource = self
//            pickerView2.delegate = self
//            pickerView2.selectRow(selectedRow, inComponent: 0, animated: false)
//            pickerView2.tag = 1
//
//            stackView.addArrangedSubview(pickerView1)
//            stackView.addArrangedSubview(pickerView2)
//
//            alert.view.addSubview(stackView)
//
//            stackView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
//            stackView.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor).isActive = true
//
//
//            let TitleString = NSAttributedString(string: "Select workout", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.backgroundColor : UIColor.clear])
//            alert.setValue(TitleString, forKey: "attributedTitle")
//            alert.setValue(vc, forKey: "contentViewController")
//
//
//            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel,handler: { (UIAlertAction) in
//                self.dismiss(animated: true, completion: nil)
//
//            })
//
//            cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
//
//            alert.addAction(cancelAction)
//
//
//            alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { (UIAlertAction) in
//                self.dismiss(animated: true, completion: nil)
//                self.selectedRow = pickerView1.selectedRow(inComponent: 0)
//                let selected = self.dataSource[self.selectedRow]
//                print("\(selected) SELECTED")
//                self.selectedWorkout?(selected)
//
//            }))
//
//            self.present(alert, animated: true, completion: nil)
//
//        }
//
//
//        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//            print("COUNTERS \(dataSource[row]) i \(exercises.count)")
//            switch pickerView.tag {
//            case 0:
//                return dataSource[row]
//            case 1:
//                return exercises[row]
//            default:
//                return "Data not found"
//            }
//        }
//
//        func numberOfComponents(in pickerView: UIPickerView) -> Int {
//            return 1
//        }
//
//        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//            print("COUNTERS \(dataSource.count) i \(exercises.count)")
//            switch pickerView.tag {
//            case 1:
//                return dataSource.count
//            case 2:
//                return exercises.count
//            default:
//                return 1
//            }
//        }
//
//        func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
//            return 50
//        }
//    }
