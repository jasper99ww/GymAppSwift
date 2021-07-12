//
//  SupportViewController.swift
//  GymLog
//
//  Created by Kacper P on 08/07/2021.
//

import UIKit
import MessageUI

struct FeedBack {
    let recipients = "String"
    let subject: String
    let body: String
}

class SupportViewController: NSObject, MFMailComposeViewControllerDelegate {

//    private var feedback: FeedBack
    private var completion: ((Result<MFMailComposeResult, Error>) -> Void)?
    
    override init() {
        super.init()
    }
    
    func showMailComposer(on viewController: UIViewController, completion:(@escaping(Result<MFMailComposeResult, Error>) -> Void)) {
        
        guard MFMailComposeViewController.canSendMail() else {
            return Alert.showBasicAlert(on: viewController, with: "Failed to open support dialog", message: "Please come back later or send email through App Store")
        }

        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["kacperus4@onet.eu"])
        self.completion = completion

        viewController.present(composer, animated: true)
        }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if let error = error {
            completion?(.failure(error))
        }
                switch result {
                case .cancelled:
                    print("Cancelled")
                case .failed:
                    completion?(.success(.failed))
                case .saved:
                    completion?(.success(.saved))
                case .sent:
                    completion?(.success(.sent))
                default:
                    print("OK")
                }
        
        controller.dismiss(animated: true)
    }
}


