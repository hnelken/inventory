//
//  BrickView.swift
//  Inventory
//
//  Created by Harry Nelken on 8/5/16.
//  Copyright © 2016 Da Legna. All rights reserved.
//

import UIKit

class BrickView: UIView {

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        let bricks = UIImageView(frame: frame)
        bricks.image = UIImage(named: "brick.jpg")
        addSubview(bricks)
        sendSubviewToBack(bricks)
    }
 

}
