//
//  InventoryHeaderView.swift
//  Inventory
//
//  Created by Harry Nelken on 10/19/16.
//  Copyright © 2016 Da Legna. All rights reserved.
//

import UIKit

class InventoryHeaderView: UIView {
    
    let group: Int
    let arrow: UIImageView
    
    init(headerSection: Int, frame: CGRect) {
        
        // Initialize
        group = headerSection
        arrow = UIImageView(frame: CGRect(x: frame.width - 35, y: 15, width: 20, height: 20))
        arrow.image = UIImage(named: kClosedGroupImage)
        super.init(frame: frame)
        
        // Customize
        backgroundColor = .gray
        
        let label = ShadowLabel(frame: CGRect(x: 15, y: 15, width: frame.size.width - 35, height: 20))
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.textColor = .white
        label.text = kGroups[group]
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        button.addTarget(self, action: #selector(InventoryViewController.headerSelected(sender:)), for: .touchUpInside)
        button.setTitle("", for: .normal)
        button.backgroundColor = .clear
        
        addSubview(label)
        addSubview(arrow)
        addSubview(button)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
