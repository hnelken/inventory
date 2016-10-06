//
//  FadingButton.swift
//  Inventory
//
//  Created by Harry Nelken on 9/20/16.
//  Copyright © 2016 Da Legna. All rights reserved.
//

import UIKit

class FadingButton: UIButton {
    
    // CG Constants
    let kButtonHiddenAlpha: CGFloat = 0
    let kButtonInactiveAlpha: CGFloat = 0.2
    let kButtonActiveAlpha: CGFloat = 0.8

    fileprivate var showing = true
    fileprivate var filled = false  // Highlight status of pencil buttons
    
    override func draw(_ rect: CGRect) {
        // Round the corners symmetrically
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
 
    func enable() {
        // Return if button is already showing
        guard !self.showing else {
            return
        }
        
        // Fill alpha and enable button
        self.showing = true
        self.isHidden = false
        self.alpha = self.kButtonActiveAlpha
        self.isUserInteractionEnabled = true
    }
    
    func disable() {
        // Return if button is already disabled
        guard self.showing else {
            return
        }
        
        // Reduce alpha and disable button
        self.isUserInteractionEnabled = false
        self.alpha = kButtonInactiveAlpha
        self.showing = false
    }
    
    func hide() {
        guard !self.isHidden else {
            return
        }
        
        // Hide button entirely
        self.isUserInteractionEnabled = false
        self.alpha = kButtonHiddenAlpha
        self.showing = false
        self.isHidden = true
    }
    
    func toggleHighlight() {
        // Toggle highlighted pencil image (for edit buttons only)
        if filled {
            self.isUserInteractionEnabled = true
            self.setImage(UIImage(named: kWhitePencilImage), for: UIControlState())
        }
        else {
            self.isUserInteractionEnabled = false
            self.setImage(UIImage(named: kYellowPencilImage), for: UIControlState())
        }
        self.filled = !self.filled
    }
}
