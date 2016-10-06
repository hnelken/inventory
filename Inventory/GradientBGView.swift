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
        //let teal = UIColor(colorLiteralRed: 46/255, green: 190/255, blue: 197/255, alpha: 1)
        //let blue = UIColor(colorLiteralRed: 52/255, green: 145/255, blue: 215/255, alpha: 1)
        //gradient.colors = [teal.cgColor, UIColor.white.cgColor]
        gradient.colors = [UIColor.lightGray.cgColor, UIColor.gray.cgColor]
        layer.insertSublayer(gradient, at: 0)
    }
 

}
