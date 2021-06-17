//
//  LoginViewController.swift
//  GymLog
//
//  Created by Barbara Podgórska on 21/02/2021.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
        setUpElements()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        checkUserInfo()
//    }
    
    func setUpElements() {
        
        // Hide the error label
        errorLabel.alpha = 0
        

        Utilities.styleFilledButton(loginButton)
     
    }
    

    @IBAction func loginTapped(_ sender: UIButton) {
        
        if let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            
            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                if  error != nil {
                    // Can't sign in
                    self.errorLabel.text = error!.localizedDescription
                    self.errorLabel.alpha = 1
                    return
                } else {
                    self.performSegue(withIdentifier: "loginToHome", sender: self)
                 
                }
            }
        }
    }
    
 

    
    
//        // Signing in the user
//        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
//
//            if error != nil {
//                // Couldn't sign in
//                self.errorLabel.text = error!.localizedDescription
//                self.errorLabel.alpha = 1
//            }
//            else {
//
//                let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
//
//                self.view.window?.rootViewController = homeViewController
//                self.view.window?.makeKeyAndVisible()
//            }
//        }
//    }
    
    
    
}
