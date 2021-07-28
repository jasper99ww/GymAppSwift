//
//  NotificationCenter+Extension.swift
//  GymLog
//
//  Created by Kacper P on 27/07/2021.
//

import UIKit

@objc protocol KeyboardNotificationDelegate: NSObjectProtocol {
    func keyboardWillBeShown(notification: NSNotification)
    func keyboardWillBeHidden(notification: NSNotification)
}

extension KeyboardNotificationDelegate {
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
