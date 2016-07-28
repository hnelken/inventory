//
//  GradientBGView.swift
//  Inventory
//
//  Created by Harry Nelken on 7/27/16.
//  Copyright © 2016 Da Legna. All rights reserved.
//

import UIKit

class GradientBGView: UIView {

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        
        // Drawing code
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = rect
        gradient.colors = [UIColor.lightGrayColor().CGColor, UIColor.grayColor().CGColor]
        layer.insertSublayer(gradient, atIndex: 0)
    }
 

}
