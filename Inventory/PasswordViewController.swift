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
    
    @IBOutlet weak var charOne: UILabel!
    @IBOutlet weak var charTwo: UILabel!
    @IBOutlet weak var charThree: UILabel!
    @IBOutlet weak var charFour: UILabel!
    
    var charNum = 1
    var entry = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        oneButton.layer.cornerRadius = oneButton.frame.width/2
        oneButton.clipsToBounds = true
        
        twoButton.layer.cornerRadius = twoButton.frame.width/2
        twoButton.clipsToBounds = true
        
        threeButton.layer.cornerRadius = threeButton.frame.width/2
        threeButton.clipsToBounds = true
        
        fourButton.layer.cornerRadius = fourButton.frame.width/2
        fourButton.clipsToBounds = true
        
        fiveButton.layer.cornerRadius = fiveButton.frame.width/2
        fiveButton.clipsToBounds = true
        
        sixButton.layer.cornerRadius = sixButton.frame.width/2
        sixButton.clipsToBounds = true
        
        sevenButton.layer.cornerRadius = sevenButton.frame.width/2
        sevenButton.clipsToBounds = true
        
        eightButton.layer.cornerRadius = eightButton.frame.width/2
        eightButton.clipsToBounds = true
        
        nineButton.layer.cornerRadius = nineButton.frame.width/2
        nineButton.clipsToBounds = true
        
        enterButton.layer.cornerRadius = enterButton.frame.height/2
        enterButton.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func enterPressed(sender: AnyObject) {
        // Check password
        if charNum == 5 {
            if entry == password {
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
            charOne.text = dotChar
            charNum += 1
        case 2:
            charTwo.text = dotChar
            charNum += 1
        case 3:
            charThree.text = dotChar
            charNum += 1
        case 4:
            charFour.text = dotChar
            charNum += 1
        default:
            break
        }
        
        print(entry)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
