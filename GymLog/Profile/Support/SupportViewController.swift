//
//  SupportViewController.swift
//  GymLog
//
//  Created by Kacper P on 08/07/2021.
//

import UIKit
import MessageUI

class SupportViewController: UIViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        showMailComposer()
    }
    
    func showMailComposer() {
        
        guard MFMailComposeViewController.canSendMail() else {
            return Alert.showBasicAlert(on: self, with: "Failed to open support dialog", message: "Please come back later or send email through App Store")
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["kacperus4@onet.eu"])
        
        present(composer, animated: true)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if let _ = error {
            Alert.showBasicAlert(on: self, with: "Error", message: "There is an error during sending email")
            controller.dismiss(animated: true, completion: nil)
            return
        }
        
        switch result {
        case .cancelled:
            print("Cancelled")
        case .failed:
            print("Failed to send")
        case .saved:
            print("Saved")
        case .sent:
            print("Sent")
        default:
            print("OK")
        }
        controller.dismiss(animated: true)
    }
}
