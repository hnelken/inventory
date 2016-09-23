//
//  ShadowLabel.swift
//  Inventory
//
//  Created by Harry Nelken on 8/5/16.
//  Copyright © 2016 Da Legna. All rights reserved.
//

import UIKit

class ShadowLabel: UILabel {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func drawText(in rect: CGRect) {
        let offset = CGSize(width: 2, height: 2)
        let colorValues: [CGFloat] = [0, 0, 0, 0.8]
    
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
    
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let color = CGColor(colorSpace: colorSpace, components: colorValues)
        context?.setShadow(offset: offset, blur: 5, color: color)
    
        super.drawText(in: rect)
    
        context?.restoreGState();
    }
    
    func hide() {
        self.alpha = 0
        self.isHidden = true
    }
    
    func show() {
        self.isHidden = false
        self.alpha = 1
    }

}
