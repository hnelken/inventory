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
    override func draw(_ rect: CGRect) {
        
        // Drawing code
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = rect
        gradient.colors = [UIColor.lightGray.cgColor, UIColor.gray.cgColor]
        layer.insertSublayer(gradient, at: 0)
    }
 

}
