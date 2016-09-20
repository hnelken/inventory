//
//  PasswordViewController.swift
//  Inventory
//
//  Created by Harry Nelken on 7/28/16.
//  Copyright © 2016 Da Legna. All rights reserved.
//

import UIKit

class PasswordViewController: UIViewController {

    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    @IBOutlet weak var fourButton: UIButton!
    @IBOutlet weak var fiveButton: UIButton!
    @IBOutlet weak var sixButton: UIButton!
    @IBOutlet weak var sevenButton: UIButton!
    @IBOutlet weak var eightButton: UIButton!
    @IBOutlet weak var nineButton: UIButton!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var charOne: UILabel!
    @IBOutlet weak var charTwo: UILabel!
    @IBOutlet weak var charThree: UILabel!
    @IBOutlet weak var charFour: UILabel!
    
    @IBOutlet weak var passwordLabel: ShadowLabel!
    @IBOutlet weak var entryLabel: ShadowLabel!
    
    @IBOutlet weak var logoImage: UIImageView!
    
    private var charNum: Int = 1
    private var entry: String = ""
    private var opened: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        formatButtons()
        hideElements()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func enterPressed(sender: AnyObject) {
        
        guard opened else {
            opened = true
            showElements()
            
            return
        }
        
        // Check password
        if charNum == 5 {
            if entry == kPassword {
                performSegueWithIdentifier(kPasswordSegue, sender: self)
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
    
    @IBAction func backPressed(sender: AnyObject) {
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
        entry = entry.substringToIndex(entry.endIndex.predecessor())
    }
    
    @IBAction func numberPressed(sender: AnyObject) {
        let num = (sender as! UIView).tag
        entry.appendContentsOf("\(num)")
        
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
    
    private func hideElements() {
        // Hidden
        passwordLabel.hidden = true
        entryLabel.hidden = true
        backButton.hidden = true
        
        oneButton.hidden = true
        twoButton.hidden = true
        threeButton.hidden = true
        fourButton.hidden = true
        fiveButton.hidden = true
        sixButton.hidden = true
        sevenButton.hidden = true
        eightButton.hidden = true
        nineButton.hidden = true
        
        // Alphas
        self.passwordLabel.alpha = 0
        self.entryLabel.alpha = 0
        self.backButton.alpha = 0
        
        self.oneButton.alpha = 0
        self.twoButton.alpha = 0
        self.threeButton.alpha = 0
        self.fourButton.alpha = 0
        self.fiveButton.alpha = 0
        self.sixButton.alpha = 0
        self.sevenButton.alpha = 0
        self.eightButton.alpha = 0
        self.nineButton.alpha = 0
    }
    
    private func showElements() {
        // Hidden
        passwordLabel.hidden = false
        entryLabel.hidden = false
        backButton.hidden = false
        
        oneButton.hidden = false
        twoButton.hidden = false
        threeButton.hidden = false
        fourButton.hidden = false
        fiveButton.hidden = false
        sixButton.hidden = false
        sevenButton.hidden = false
        eightButton.hidden = false
        nineButton.hidden = false
        
        // Animate alphas
        UIView.animateWithDuration(1.0, animations: {
            self.passwordLabel.alpha = 1
            self.entryLabel.alpha = 1
            self.backButton.alpha = 1
            
            self.oneButton.alpha = 1
            self.twoButton.alpha = 1
            self.threeButton.alpha = 1
            self.fourButton.alpha = 1
            self.fiveButton.alpha = 1
            self.sixButton.alpha = 1
            self.sevenButton.alpha = 1
            self.eightButton.alpha = 1
            self.nineButton.alpha = 1
            
            self.logoImage.alpha = 0
            
            self.enterButton.setTitle("Enter",
                forState: .Normal)
            
            }, completion: { (status) in
                self.logoImage.hidden = true
        })
    }
    
    // Rounds the corners of all buttons
    private func formatButtons() {
        // Button 1
        oneButton.layer.cornerRadius =
            oneButton.frame.width/2
        oneButton.clipsToBounds = true
        
        // Button 2
        twoButton.layer.cornerRadius =
            twoButton.frame.width/2
        twoButton.clipsToBounds = true
        
        // Button 3
        threeButton.layer.cornerRadius =
            threeButton.frame.width/2
        threeButton.clipsToBounds = true
        
        // Button 4
        fourButton.layer.cornerRadius =
            fourButton.frame.width/2
        fourButton.clipsToBounds = true
        
        // Button 5
        fiveButton.layer.cornerRadius =
            fiveButton.frame.width/2
        fiveButton.clipsToBounds = true
        
        // Button 6
        sixButton.layer.cornerRadius =
            sixButton.frame.width/2
        sixButton.clipsToBounds = true
        
        // Button 7
        sevenButton.layer.cornerRadius =
            sevenButton.frame.width/2
        sevenButton.clipsToBounds = true
        
        // Button 8
        eightButton.layer.cornerRadius =
            eightButton.frame.width/2
        eightButton.clipsToBounds = true
        
        // Button 9
        nineButton.layer.cornerRadius =
            nineButton.frame.width/2
        nineButton.clipsToBounds = true
        
        // Enter button
        enterButton.layer.cornerRadius =
            enterButton.frame.height/2
        enterButton.clipsToBounds = true
    }
}
