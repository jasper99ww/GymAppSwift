//
//  EntryViewController.swift
//  GymLog
//
//  Created by Barbara Podgórska on 01/03/2021.
//

import UIKit

class EntryViewController: UIViewController {
    
    @IBOutlet weak var Number: UITextField!
    
    @IBOutlet weak var Exercise: UITextField!
    
    @IBOutlet weak var kg: UITextField!
    
    @IBOutlet weak var Sets: UITextField!
    
    @IBOutlet weak var Reps: UITextField!
    
    public var completion: ((String, String, String, String, String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))
    }
    
    @objc func didTapSave() {
        if let number = Number.text, !number.isEmpty, let exercise = Exercise.text, !exercise.isEmpty, let Kg = kg.text, !Kg.isEmpty, let sets = Sets.text, !sets.isEmpty, let reps = Reps.text, !reps.isEmpty {
            
            completion?(number, exercise, Kg, sets, reps)
            
        
        }
    }

  
}
