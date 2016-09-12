//
//  SelectedItemViewController.swift
//  Inventory
//
//  Created by Harry Nelken on 9/6/16.
//  Copyright © 2016 Da Legna. All rights reserved.
//

import UIKit

class SelectedItemViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // CG Constants
    let kButtonInactiveAlpha: CGFloat = 0.2
    let kButtonActiveAlpha: CGFloat = 0.8

    // Public References
    var initSpecial: Bool = false
    var initGroup: String?
    var initName: String?
    weak var initImage: UIImage?
    
    // Private Variables
    private var selectedQuantity = 0
    private var selectedUnit = 0
    private var special = false
    private var amountChanged = false
    private var saveShowing = false
    
    // IB Outlets
    @IBOutlet weak var quantitySlider: UISlider!
    
    @IBOutlet weak var unitLabel: ShadowLabel!
    @IBOutlet weak var quantityLabel: ShadowLabel!
    @IBOutlet weak var itemGroupLabel: ShadowLabel!
    @IBOutlet weak var itemNameLabel: ShadowLabel!
    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var flipView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var editImageButton: UIButton!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var deleteItemButton: UIButton!
    @IBOutlet weak var saveChangesButton: UIButton!
    @IBOutlet weak var specialButton: UIButton!
    
    @IBOutlet weak var nameField: UITextField!
    
    
    // MARK: - View Controller 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add touch recognizer to hide text fields
        let touch = UITapGestureRecognizer(target: self, action: .tapHandler)
        view.addGestureRecognizer(touch)
        
        // Display selected item settings
        if initSpecial {
            special = initSpecial
            specialButton.setImage(UIImage(named: kYellowStarImage), forState: .Normal)
        }
        
        if let group = initGroup {
            itemGroupLabel.text = group
        }
        
        if let name = initName {
            itemNameLabel.text = name
        }
        
        if let image = initImage {
            itemImageView.image = image
        }

        // Preselect rows in picker view
        pickerView.selectRow(0, inComponent: 0, animated: false)
        pickerView.selectRow(0, inComponent: 1, animated: false)
        
        // Hide/format buttons in view
        hideSaveButton(false)
        formatButtons()
        
        // Hide text fields
        nameField.hidden = true
        
        // Hide picker view
        pickerView.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - IB Actions
    
    @IBAction func specialPressed(sender: AnyObject) {
        
        let imageName: String
        if special {
            special = false
            imageName = kWhiteStarImage
        }
        else {
            special = true
            imageName = kYellowStarImage
        }
        specialButton.setImage(UIImage(named: imageName), forState: .Normal)
        changesMade()
    }
    
    @IBAction func addToCartPressed(sender: AnyObject) {
    }
    
    @IBAction func savePressed(sender: AnyObject) {
    }
    
    @IBAction func deletePressed(sender: AnyObject) {
    }
    
    @IBAction func editImagePressed(sender: AnyObject) {
    }
  
    @IBAction func editGroupPressed(sender: AnyObject) {
        // Flip to picker
    }
    
    @IBAction func editNamePressed(sender: AnyObject) {
        nameField.text = itemNameLabel.text
        nameField.hidden = false
        itemNameLabel.hidden = true
        nameField.becomeFirstResponder()
    }
    
    @IBAction func editUnitPressed(sender: AnyObject) {
        // Flip to picker
    }
    
    @IBAction func sliderMoved(sender: AnyObject) {
        quantityLabel.text = "\(Int(quantitySlider.value))"
    }
    
    
    // MARK: - Picker View Datasource/Delegate
    
    // numberOfComponents
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // numberOfRowsInComponent
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return kGroups.count
    }
    
    // titleForRow
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return kGroups[row]
    }
    
    // didSelectRow
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
        /*if amountChanged {    // Check if changes have been reverted
            if selectedQuantity == pickerView.selectedRowInComponent(kQuantityIndex) &&
                selectedUnit == pickerView.selectedRowInComponent(kUnitIndex) {
                
                // Changes have been reverted
                amountChanged = false
            }
        }
        else if component == kQuantityIndex {  // Item quantity
            if selectedQuantity != row {
                // Changes have been made
                amountChanged = true
            }
        }
        else if component == kUnitIndex {  // Unit type
            if selectedUnit != row {
                // Changes have been made
                amountChanged = true
            }
        }
        else {
            print("ERROR: Unexpected picker view component index")
        }
        
        // Signal that changes have been made
        changesMade() */
    }
    
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let vc = segue.destinationViewController as? InventoryViewController {
            //vc.rowChanged
        }
    }
    
    
    // MARK: - Private API
    
    func tapHandler(sender: UIGestureRecognizer) {
        if sender.state == .Ended && !nameField.hidden {
            itemNameLabel.text = nameField.text
            nameField.resignFirstResponder()
            nameField.hidden = true
            itemNameLabel.hidden = false
            changesMade()
        }
    }
    
    private func formatButtons() {
        // Corner radii
        editImageButton.layer.cornerRadius = editImageButton.frame.height / 2
        addToCartButton.layer.cornerRadius = addToCartButton.frame.height / 2
        deleteItemButton.layer.cornerRadius = deleteItemButton.frame.height / 2
        saveChangesButton.layer.cornerRadius = saveChangesButton.frame.height / 2
        
        // Clip buttons to bounds
        editImageButton.clipsToBounds = true
        addToCartButton.clipsToBounds = true
        deleteItemButton.clipsToBounds = true
        saveChangesButton.clipsToBounds = true
    }
    
    private func changesMade() {
        let changesMade = (amountChanged || special != initSpecial || initName != itemNameLabel.text)
        
        if changesMade {
            if !saveShowing {
                showSaveButton()
            }
        }
        else if saveShowing {
            hideSaveButton(true)
        }
        else {
            print("ERROR: Unexpected change status")
        }
    }
    
    private func showSaveButton() {
        // Animate save button into view
        UIView.animateWithDuration(0.1, animations: {
            self.saveChangesButton.alpha = self.kButtonActiveAlpha
            
            }, completion: { (status) in
                self.saveChangesButton.userInteractionEnabled = true
        })
        
        saveShowing = true
    }
    
    private func hideSaveButton(animated: Bool) {
        // Hide save button via fade animation
        saveChangesButton.userInteractionEnabled = false
        
        if !animated {
            saveChangesButton.alpha = kButtonInactiveAlpha
        }
        else {
            UIView.animateWithDuration(0.1, animations: {
                self.saveChangesButton.alpha = self.kButtonInactiveAlpha
            })
        }
        
        saveShowing = false
    }
    
    

}
