//
//  ModalAddViewController.swift
//  GymLog
//
//  Created by Barbara Podgórska on 01/04/2021.
//

import UIKit
import Firebase

class ModalAddViewController: UIViewController {
    
    let user = Auth.auth().currentUser
    
    var db = Firestore.firestore()

    @IBOutlet weak var dialogView: UIView!
    
    @IBOutlet weak var newExercise: UITextField!
    @IBOutlet weak var newKg: UITextField!
    @IBOutlet weak var newSets: UITextField!
    @IBOutlet weak var newReps: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    var completionHandler: ((String, String, String, String) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dialogView.layer.cornerRadius = 10
        setUpElements()
        dialogView.backgroundColor = UIColor.init(red: 24/255, green: 24/255, blue: 24/255, alpha: 1)
        
    }
    

    @IBAction func addButtonTapped(_ sender: Any) {
        
        completionHandler?(newExercise.text!, newKg.text!, newSets.text!, newReps.text!)
        
        dismiss(animated: true)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    func setUpElements() {
//        Utilities.styleTextField(newExercise)
//        Utilities.styleTextField(newKg)
//        Utilities.styleTextField(newSets)
//        Utilities.styleTextField(newReps)
        Utilities.styleFilledButton(addButton)
    }
}

extension UIView {
    func applyBlurEffect() {
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
        
    }
}
