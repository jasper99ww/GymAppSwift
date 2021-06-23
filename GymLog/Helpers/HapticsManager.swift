//
//  HapticsManager.swift
//  GymLog
//
//  Created by Kacper P on 22/06/2021.
//

import UIKit

final class HapticsManager {
    
    static let shared = HapticsManager()
    
    private init() {}
    
    public func selectionVibrate() {
      
        DispatchQueue.main.async {
            let selectionFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
        selectionFeedbackGenerator.prepare()
        selectionFeedbackGenerator.impactOccurred()
        }
    }
    
    public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        let notificationGenerator = UINotificationFeedbackGenerator()
        notificationGenerator.prepare()
        notificationGenerator.notificationOccurred(type)
    }
}
