//
//  CaloriesResultViewController.swift
//  GymLog
//
//  Created by Kacper P on 08/07/2021.
//

import UIKit

class CaloriesResultViewController: UIViewController {

    
    @IBOutlet weak var caloriesAmount: UILabel!
    var calories = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        caloriesAmount.text = String(calories)
     
    }


}
