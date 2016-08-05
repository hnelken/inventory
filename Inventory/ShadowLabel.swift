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
    
    override func drawTextInRect(rect: CGRect) {
        let offset = CGSize(width: 2, height: 2)
        let colorValues: [CGFloat] = [0, 0, 0, 0.8]
    
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
    
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let color = CGColorCreate(colorSpace, colorValues)
        CGContextSetShadowWithColor(context, offset, 5, color)
    
        super.drawTextInRect(rect)
    
        CGContextRestoreGState(context);
    }

}
