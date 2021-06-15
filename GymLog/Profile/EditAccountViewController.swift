//
//  EditAccountViewController.swift
//  GymLog
//
//  Created by Kacper P on 15/06/2021.
//

import UIKit

class EditAccountViewController: UIViewController {

    @IBOutlet weak var newLabel: UILabel!
    @IBOutlet weak var newValue: UITextField!
    var first: String?
    var second: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newLabel.text = first
        newValue.text = second
print("OTWARTE")
    }
    

}
