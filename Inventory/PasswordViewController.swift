//
//  PasswordViewController.swift
//  Inventory
//
//  Created by Harry Nelken on 7/28/16.
//  Copyright © 2016 Da Legna. All rights reserved.
//

import UIKit

class PasswordViewController: UIViewController {

    @IBOutlet weak var oneButton: FadingButton!
    @IBOutlet weak var twoButton: FadingButton!
    @IBOutlet weak var threeButton: FadingButton!
    @IBOutlet weak var fourButton: FadingButton!
    @IBOutlet weak var fiveButton: FadingButton!
    @IBOutlet weak var sixButton: FadingButton!
    @IBOutlet weak var sevenButton: FadingButton!
    @IBOutlet weak var eightButton: FadingButton!
    @IBOutlet weak var nineButton: FadingButton!
    @IBOutlet weak var enterButton: FadingButton!
    @IBOutlet weak var backButton: FadingButton!
    
    @IBOutlet weak var charOne: UILabel!
    @IBOutlet weak var charTwo: UILabel!
    @IBOutlet weak var charThree: UILabel!
    @IBOutlet weak var charFour: UILabel!
    
    @IBOutlet weak var passwordLabel: ShadowLabel!
    @IBOutlet weak var entryLabel: ShadowLabel!
    
    @IBOutlet weak var logoImage: UIImageView!
    
    fileprivate var charNum: Int = 1
    fileprivate var entry: String = ""
    fileprivate var opened: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        hideElements()
    }
    
    override func viewDidLayoutSubviews() {
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func enterPressed(_ sender: AnyObject) {
        
        guard opened else {
            opened = true
            showElements()
            
            return
        }
        
        // Check password
        if charNum == 5 {
            if entry == kPassword {
                performSegue(withIdentifier: kPasswordSegue, sender: self)
            }
            else {
                charNum = 1
                charOne.text = ""
                charTwo.text = ""
                charThree.text = ""
                charFour.text = ""
                entry = ""
            }
        }
    }
    
    @IBAction func backPressed(_ sender: AnyObject) {
        charNum -= 1
        
        switch charNum {
        case 1:
            charOne.text = ""
        case 2:
            charTwo.text = ""
        case 3:
            charThree.text = ""
        case 4:
            charFour.text = ""
        default:
            break
        }
        entry = entry.substring(to: entry.characters.index(before: entry.endIndex))
    }
    
    @IBAction func numberPressed(_ sender: AnyObject) {
        let num = (sender as! UIView).tag
        entry.append("\(num)")
        
        switch charNum {
        case 1:
            charOne.text = kDotChar
            charNum += 1
        case 2:
            charTwo.text = kDotChar
            charNum += 1
        case 3:
            charThree.text = kDotChar
            charNum += 1
        case 4:
            charFour.text = kDotChar
            charNum += 1
        default:
            break
        }
    }

    
    // MARK: - Private API
    
    fileprivate func hideElements() {
        // Labels
        self.passwordLabel.hide()
        self.entryLabel.hide()
        
        // Buttons
        self.backButton.hide()
        self.oneButton.hide()
        self.twoButton.hide()
        self.threeButton.hide()
        self.fourButton.hide()
        self.fiveButton.hide()
        self.sixButton.hide()
        self.sevenButton.hide()
        self.eightButton.hide()
        self.nineButton.hide()
    }
    
    fileprivate func showElements() {
        
        // Animate alphas
        UIView.animate(withDuration: 1.0, animations: {
            
            // Labels
            self.passwordLabel.show()
            self.entryLabel.show()
            
            // Buttons
            self.backButton.enable()
            self.oneButton.enable()
            self.twoButton.enable()
            self.threeButton.enable()
            self.fourButton.enable()
            self.fiveButton.enable()
            self.sixButton.enable()
            self.sevenButton.enable()
            self.eightButton.enable()
            self.nineButton.enable()
            
            self.logoImage.alpha = 0
            
            self.enterButton.setTitle("Enter",
                for: UIControlState())
            
            }, completion: { (status) in
                self.logoImage.isHidden = true
        })
    }
}
