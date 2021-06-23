//
//  MinutesTimerView.swift
//  GymLog
//
//  Created by Barbara Podgórska on 15/04/2021.
//

import UIKit

class MinutesTimerView: UIViewController {

    var timer:Timer = Timer()
    var count:Int = 0
    var label: ((String) -> Void)?
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
        
    }
    
    @objc func timerCounter() {
        count += 1
        let time = secondsToHoursMinutesSeconds(seconds: count)
        let timeString = makeTimeString(minutes: time.0, seconds: time.1)
        label?(timeString)
    }
    
    func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int) {
        return (((seconds % 3600) / 60), ((seconds % 3600) % 60) )
    }
    
    func makeTimeString(minutes: Int, seconds: Int) -> String {
        
        var timeString = ""
        timeString += String(format: "%02d", minutes)
        timeString += ":"
        timeString += String(format: "%02d", seconds)
        return timeString
    }
    
    
}


