//
//  CriteriaOfSelectViewController.swift
//  GymLog
//
//  Created by Kacper P on 29/05/2021.
//

import UIKit

class CriteriaOfSelectViewController: UIViewController {
    
    let screenWidth = UIScreen.main.bounds.width - 20
    let screenHeight = UIScreen.main.bounds.height / 7
    let vc = UIViewController()
    var selectedCriteria: ((_ data: String) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()

        alert()

    }
    

    func alert() {
        
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        
        
        let alert = UIAlertController(title: "Select", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Weight", style: .default, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
            self.selectedCriteria?("Weight")
        }))
        
        alert.addAction(UIAlertAction(title: "Volume", style: .default, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
            self.selectedCriteria?("Volume")
        }))
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in

            self.dismiss(animated: true, completion: nil)
        })
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(cancelAction)
        
        let TitleString = NSAttributedString(string: "Select Exercise", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.backgroundColor : UIColor.clear])
        alert.setValue(TitleString, forKey: "attributedTitle")

        
        self.present(alert, animated: true) {
    
        }
        
       
    }

     
}
