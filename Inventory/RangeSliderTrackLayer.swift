//
//  RangeSliderTrackLayer.swift
//  RangeSlider
//
//  Created by Harry Nelken on 10/15/16.
//  Copyright © 2016 Harry Nelken. All rights reserved.
//

import UIKit
import QuartzCore

class RangeSliderTrackLayer: CALayer {
    weak var rangeSlider: RangeSlider?
    
    override func draw(in ctx: CGContext) {
        if let slider = rangeSlider {
            // Clip
            let cornerRadius = bounds.height * slider.curvaceousness / 2.0
            let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
            ctx.addPath(path.cgPath)
            
            // Fill the track
            /*
            ctx.setFillColor(slider.trackTintColor.cgColor)
            ctx.addPath(path.cgPath)
            ctx.fillPath()
            */
            
            // Fill the lower range
            ctx.setFillColor(slider.trackLowerTintColor.cgColor)
            var lowerPosition = CGFloat(slider.positionForValue(slider.minimumValue))
            var upperPosition = CGFloat(slider.positionForValue(slider.lowerValue))
            var rect = CGRect(x: lowerPosition, y: 0.0, width: upperPosition - lowerPosition, height: bounds.height)
            ctx.fill(rect)
            
            // Fill the middle range
            ctx.setFillColor(slider.trackMiddleTintColor.cgColor)
            lowerPosition = CGFloat(slider.positionForValue(slider.lowerValue))
            upperPosition = CGFloat(slider.positionForValue(slider.upperValue))
            rect = CGRect(x: lowerPosition, y: 0.0, width: upperPosition - lowerPosition, height: bounds.height)
            ctx.fill(rect)
            
            // Fill the upper range
            ctx.setFillColor(slider.trackUpperTintColor.cgColor)
            lowerPosition = CGFloat(slider.positionForValue(slider.upperValue))
            upperPosition = CGFloat(slider.positionForValue(slider.maximumValue))
            rect = CGRect(x: lowerPosition, y: 0.0, width: upperPosition - lowerPosition, height: bounds.height)
            ctx.fill(rect)
        }
    }
}
