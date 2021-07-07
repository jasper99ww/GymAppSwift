//
//  CaloriesActivityPickerView.swift
//  GymLog
//
//  Created by Kacper P on 07/07/2021.
//

import UIKit

class CaloriesActivityPickerView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    public var data: [String]? {
        didSet {
            super.delegate = self
            super.dataSource = self
            self.reloadAllComponents()
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if data != nil {
            return data!.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if data != nil {
            return data![row]
        } else {
            return ""
        }
    }
    
    public var selectedValue: String {
        get {
            if data != nil {
                return data![selectedRow(inComponent: 0)]
            } else {
                return ""
            }
        }
    }
    
   
}
