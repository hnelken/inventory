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
        
        //formatButtons()
        hideElements()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        /*
        // Hidden
        passwordLabel.isHidden = true
        entryLabel.isHidden = true
        backButton.isHidden = true
        
        oneButton.isHidden = true
        twoButton.isHidden = true
        threeButton.isHidden = true
        fourButton.isHidden = true
        fiveButton.isHidden = true
        sixButton.isHidden = true
        sevenButton.isHidden = true
        eightButton.isHidden = true
        nineButton.isHidden = true
        
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
 */
    }
    
    fileprivate func showElements() {
        /* Hidden
        passwordLabel.isHidden = false
        entryLabel.isHidden = false
        backButton.isHidden = false
        
        oneButton.isHidden = false
        twoButton.isHidden = false
        threeButton.isHidden = false
        fourButton.isHidden = false
        fiveButton.isHidden = false
        sixButton.isHidden = false
        sevenButton.isHidden = false
        eightButton.isHidden = false
        nineButton.isHidden = false
        */
        
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
            
            /*
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
            */
            
            self.logoImage.alpha = 0
            
            self.enterButton.setTitle("Enter",
                for: UIControlState())
            
            }, completion: { (status) in
                self.logoImage.isHidden = true
        })
    }
    
    // Rounds the corners of all buttons
    fileprivate func formatButtons() {
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
