//
//  ViewController.swift
//  GymLog
//
//  Created by Barbara Podgórska on 20/02/2021.
//

import UIKit
import FirebaseAuth

class MainViewController: UIViewController {
    
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        setUpElements()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if Auth.auth().currentUser != nil {
            DispatchQueue.main.async {
                           self.performSegue(withIdentifier: "autoLogin", sender: self)
            }
    }
    }
        
//        if Auth.auth().currentUser != nil  {
//            DispatchQueue.main.async {
//                self.performSegue(withIdentifier: "autoLogin", sender: self)
//            }
//        }
        
    
   
   


    func setUpElements() {
        
        Utilities.titleAnimation(titleLabel)
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(loginButton)
        
    }
    
//    func checkUserInfo() {
//        if Auth.auth().currentUser != nil {
//
//            let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
//
//            self.view.window?.rootViewController = homeViewController
//            self.view.window?.makeKeyAndVisible()
//
//        } else {
//            return }
//    }
    
}

