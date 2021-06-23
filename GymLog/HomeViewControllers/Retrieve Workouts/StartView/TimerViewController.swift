
import UIKit
import AVFoundation

class TimerViewController: UIViewController, CAAnimationDelegate {
    
    
    let vibrationsON: Bool = UserDefaults.standard.bool(forKey: "vibrations")
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var newView: UIView!
    
    @IBOutlet weak var restartButton: UIButton!
    
    @IBOutlet weak var startButton: UIButton!
    let minutesTimerView = MinutesTimerView()
    
    let shape = CAShapeLayer()
    var startButtonTapped: Bool = false
    var firstTimeStarted: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
    }
    
    override func viewDidLayoutSubviews() {
        set()
    }
    
    func set() {

        let position = CGPoint(x: newView.frame.width / 2, y: newView.frame.height / 2)
       
        let circlePath = UIBezierPath(arcCenter: position,
                                      radius: 150,
                                      startAngle: -(.pi / 2),
                                      endAngle: (3 * .pi / 2),
                                      clockwise: true)
        
        let trackShape = CAShapeLayer()
        trackShape.path = circlePath.cgPath
        trackShape.fillColor = UIColor.clear.cgColor
        trackShape.lineWidth = 12
        trackShape.strokeColor = UIColor.lightGray.cgColor
        trackShape.position = CGPoint(x: 0, y: 0)
        newView.layer.addSublayer(trackShape)
        
        shape.path = circlePath.cgPath
        shape.lineWidth = 12
        shape.strokeColor = UIColor.green.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeEnd = 0
        newView.layer.addSublayer(shape)
    }
    
    @IBAction func startButton(_ sender: UIButton) {
        
        if startButtonTapped {
            
            startButtonTapped = false
            minutesTimerView.timer.invalidate()
            startButton.setTitle("Start", for: .normal)
            startButton.setTitleColor(UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1), for: .normal)
            pauseLayer(layer: shape)
        }
        else {
            if firstTimeStarted {
            firstTimeStarted = false
            animation()
            }
            self.setTimerInLabel()
            startButtonTapped = true
            startButton.setTitle("STOP", for: .normal)
            startButton.setTitleColor(.red, for: .normal)
            resumeAnimation(layer: shape)
        }
    }
    
    func animation() {
        let duration: TimeInterval = 10

        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.delegate = self
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
     
        shape.add(animation, forKey: "urSoBasic")

    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {

        DispatchQueue.main.async {
            self.minutesTimerView.timer.invalidate()
            if self.vibrationsON == true {
        AudioServicesPlaySystemSoundWithCompletion(kSystemSoundID_Vibrate) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }
            } else {
                print("vibrations are off")
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    @IBAction func restartButtonTapped(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Reset Timer?", message: "Are you sure you would like to reset the Timer?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            //
        }))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
            self.minutesTimerView.count = 0
            self.minutesTimerView.timer.invalidate()
            self.timerLabel.text = "00:00"
            self.startButton.setTitle("Start", for: .normal)
            self.shape.removeAnimation(forKey: "urSoBasic")
            self.firstTimeStarted = true
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
func setTimerInLabel() {
    minutesTimerView.startTimer()
    minutesTimerView.label = { timeLabel in
        self.timerLabel.text = timeLabel
        }
}
    
    func pauseLayer(layer: CALayer) {
        let pausedTime: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }
    
    func resumeAnimation(layer: CALayer) {
        let pausedTime = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
}


