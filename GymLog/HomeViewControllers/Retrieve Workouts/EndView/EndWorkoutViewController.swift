//
//  EndWorkoutViewController.swift
//  GymLog
//
//  Created by Barbara Podgórska on 19/04/2021.
//

import UIKit
import Firebase

class EndWorkoutViewController: UIViewController {
    
    var weightArray = [String?]()
    var setsArray = [String?]()
    var repsArray = [String?]()
    
    
    let user = Auth.auth().currentUser
    var db = Firestore.firestore()
    let start = StartViewController()
    
    @IBOutlet weak var imageCup: UIImageView!
    @IBOutlet weak var totalWeight: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var totalSets: UILabel!
    @IBOutlet weak var sets: UILabel!
    @IBOutlet weak var totalReps: UILabel!
    @IBOutlet weak var reps: UILabel!
    

    
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      getWeight()
        getSets()
        getReps()
        setUp()
    }
    
    @IBAction func continueButtonTapped(_ sender: UIButton) {
    
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popToRootViewController(animated: true)
       
    }
    
    func setUp() {
        Utilities.styleFilledButton(continueButton)
    }
    
    func getWeight() {
        let sumWeights = weightArray.map {Int($0!) ?? 0}
        let totalLabel = sumWeights.reduce(0,+)
        weight.text = String(totalLabel)
        
    }
    
    func getSets() {
        let sumSets = weightArray.count
        sets.text = String(sumSets)
    }

    func getReps() {
        let sumReps = repsArray.map {Int($0!) ?? 0}
        let sumRepsLabel = sumReps.reduce(0, +)
        reps.text = String(sumRepsLabel)
    }
}
