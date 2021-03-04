//
//  MainTabBarController.swift
//  GymLog
//
//  Created by Barbara Podgórska on 28/02/2021.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
       
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

}
