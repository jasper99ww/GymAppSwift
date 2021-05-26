//
//  PopUpCalendarViewController.swift
//  GymLog
//
//  Created by Kacper P on 09/05/2021.
//

import UIKit

class PopUpCalendarViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var datasource: [String] = ["FBW", "Upper", "Lower"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        datasource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return datasource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    

    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var selectButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.dataSource = self
        picker.delegate = self
    }
    


    @IBAction func selectButtonTapped(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
}
