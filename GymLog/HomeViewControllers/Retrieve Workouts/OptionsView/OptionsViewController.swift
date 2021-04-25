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
    
    @IBOutlet weak var showView: UIView!
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
       goToShowExercisesView()
        goToEditView()
        goToAddExcerciseView()
        goToStartView()
    }
    
   
    // MARK: - Go To SHOW View
    func goToShowExercisesView() {
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.actionGoToShowExercisesView))
        self.showView.addGestureRecognizer(gesture)
        
    }

    @objc func actionGoToShowExercisesView(sender : UITapGestureRecognizer) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "showWorkout") as? ShowWorkoutViewController else { return }
        vc.titleValue = titleValue
        vc.dayOfWorkoutString = dayOfWorkout
        navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - Go To EDIT View
    func goToEditView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.actionGoToEditView))
        self.editView.addGestureRecognizer(gesture)
    }
    
    @objc func actionGoToEditView(sender : UITapGestureRecognizer) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "editWorkout") as? EditWorkoutViewController else { return }
        vc.titleValue = titleValue
        vc.dayOfWorkoutString = dayOfWorkout
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Go To Add Exercise View
    
    func goToAddExcerciseView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.actionGoToAddExerciseView))
        self.addExerciseView.addGestureRecognizer(gesture)
    }
    
    @objc func actionGoToAddExerciseView(sender : UITapGestureRecognizer) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "addNextExercise") as? AddNextExerciseController else { return }
        vc.titleValue = titleValue
        vc.dayOfWorkoutString = dayOfWorkout
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    // MARK: - Go To Start Training View
    func goToStartView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.actionGoToStartView))
        self.startView.addGestureRecognizer(gesture)
    }
    
    @objc func actionGoToStartView(sender : UITapGestureRecognizer) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "startView") as? StartViewController else { return }
        vc.titleValue = titleValue
        vc.dayOfWorkout = dayOfWorkout
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    // MARK: - UI/UX Design
    
    func shadowsForViews() {
        
        setUpShadowsForViews(view: startView)
        setUpShadowsForViews(view: editView)
        setUpShadowsForViews(view: addExerciseView)
        setUpShadowsForViews(view: showView)
        
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
