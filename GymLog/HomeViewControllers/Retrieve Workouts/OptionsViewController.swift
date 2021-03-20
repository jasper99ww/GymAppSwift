//
//  OptionsViewController.swift
//  GymLog
//
//  Created by Barbara Podgórska on 19/03/2021.
//

import UIKit

class OptionsViewController: UIViewController {
    
    @IBOutlet weak var startView: UIView!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var addExerciseView: UIView!
    @IBOutlet weak var showExercisesView: UIView!
    var titleValue: String = ""
    var dayOfWorkout: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.largeTitleDisplayMode = .always
//        setUpTitle()
        self.navigationController?.navigationBar.backgroundColor = UIColor.init(red: 18/255, green: 18/255, blue: 18/255, alpha: 1)
        self.navigationItem.backButtonTitle = ""
        self.navigationItem.title = titleValue
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shadowsForViews()
        gotToShowExercisesView()
    }
    
    func gotToShowExercisesView() {
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.actionGoToShowExercisesView))
        self.showExercisesView.addGestureRecognizer(gesture)
        
    }
    
    @objc func actionGoToShowExercisesView(sender : UITapGestureRecognizer) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "showWorkout") as? ShowWorkoutViewController else { return }
        vc.titleValue = titleValue
        vc.dayOfWorkoutString = dayOfWorkout
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToEditView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.actionGoToEditView))
        self.editView.addGestureRecognizer(gesture)
    }
    
    @objc func actionGoToEditView(sender : UITapGestureRecognizer) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "showWorkout") as? ShowWorkoutViewController else { return }
        vc.titleValue = titleValue
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func shadowsForViews() {
        
        setUpShadowsForViews(view: startView)
        setUpShadowsForViews(view: editView)
        setUpShadowsForViews(view: addExerciseView)
        setUpShadowsForViews(view: showExercisesView)
        
    }
    

}

extension OptionsViewController {
    
    func setUpShadowsForViews(view: UIView) {
    
            view.layer.shadowColor = UIColor.init(red: 26/255, green: 26/255, blue: 26/255, alpha: 1).cgColor
            view.layer.shadowRadius = 5
            view.layer.shadowOpacity = 0.7
            view.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}
