//
//  CircleMarker.swift
//  GymLog
//
//  Created by Kacper P on 02/07/2021.
//

import Foundation
import UIKit
import Charts

class CircleMarker: MarkerImage {
    
var color: UIColor
var radius: CGFloat = 4

public init(color: UIColor) {
   self.color = color
   super.init()
}

override func draw(context: CGContext, point: CGPoint) {
   let circleRect = CGRect(x: point.x - radius, y: point.y - radius, width: radius * 2, height: radius * 2)
    
    context.setFillColor(UIColor.clear.cgColor)
    
//    context.setStrokeColor(color.cgColor)
   context.fillEllipse(in: circleRect)
   
   context.restoreGState()
    }
}
