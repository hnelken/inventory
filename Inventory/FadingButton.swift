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
    let kButtonInactiveAlpha: CGFloat = 0.2
    let kButtonActiveAlpha: CGFloat = 0.8

    private var showing = true
    private var filled = false  // Highlight status of pencil buttons
    
    override func drawRect(rect: CGRect) {
        // Round the corners symmetrically
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
 
    func show() {
        // Return if button is already showing
        guard !self.showing else {
            return
        }
        
        // Animate button into view
        self.showing = true
        UIView.animateWithDuration(0.25, animations: {
            self.alpha = self.kButtonActiveAlpha
            }, completion: { (status) in
                self.userInteractionEnabled = true
        })
    }
    
    func hide(animated: Bool) {
        // Return if button is already hidden
        guard self.showing else {
            return
        }
        
        // Hide button via fade animation
        self.userInteractionEnabled = false
        self.showing = false
        if !animated {
            self.alpha = kButtonInactiveAlpha
        }
        else {
            UIView.animateWithDuration(0.25, animations: {
                self.alpha = self.kButtonInactiveAlpha
            })
        }
    }
    
    func toggleHighlight() {
        // Toggle highlighted pencil image (for edit buttons only)
        if filled {
            self.userInteractionEnabled = true
            self.setImage(UIImage(named: kWhitePencilImage), forState: .Normal)
        }
        else {
            self.userInteractionEnabled = false
            self.setImage(UIImage(named: kYellowPencilImage), forState: .Normal)
        }
        self.filled = !self.filled
    }
}
