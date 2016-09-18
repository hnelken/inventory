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
    var initSpecial: Bool?
    var initQuantity: Int?
    var initUnit: Int?
    var initGroup: Int?
    var initName: String?
    weak var initImage: UIImage?
    
    // Private Variables
    private var lastGroupRow = 0
    private var lastQuantityRow = 0
    private var lastUnitRow = 0
    private var isSpecial = false
    private var amountChanged = false
    private var saveShowing = false
    private var editingGroup = false
    private var canSave = false
    
    // IB Outlets=
    @IBOutlet weak var itemGroupLabel: ShadowLabel!
    @IBOutlet weak var itemNameLabel: ShadowLabel!
    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var amountPicker: UIPickerView!
    @IBOutlet weak var groupPicker: UIPickerView!
    
    @IBOutlet weak var flipView: UIView!
    
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
        
        // Get special status of item
        if let special = initSpecial {
            isSpecial = special
        }
        else {
            isSpecial = false
            initSpecial = false
        }
        
        // Show special status via button color
        if isSpecial {
            specialButton.setImage(UIImage(named: kYellowStarImage), forState: .Normal)
        }
        else {
            specialButton.setImage(UIImage(named: kWhiteStarImage), forState: .Normal)
        }
        
        // Fill in initial item group, name, and image
        if let group = initGroup {
            itemGroupLabel.text = kGroups[group]
            lastGroupRow = group + 1
        }
        else {
            lastGroupRow = 0
            initGroup = -1
        }
        
        if let name = initName {
            itemNameLabel.text = name
        }
        
        if let image = initImage {
            itemImageView.image = image
        }

        // Get item quantity
        if let quantity = initQuantity {
            lastQuantityRow = quantity + 1
        }
        else {
            lastQuantityRow = 0
            initQuantity = -1
        }
        
        // Get unit of measurement
        if let unit = initUnit {
            lastUnitRow = unit + 1
        }
        else {
            lastUnitRow = 0
            initUnit = -1
        }
        
        // Display group, quantity, and unit of measurement in picker views
        amountPicker.selectRow(lastQuantityRow, inComponent: kQuantityComponent, animated: false)
        amountPicker.selectRow(lastUnitRow, inComponent: kUnitComponent, animated: false)
        groupPicker.selectRow(lastGroupRow, inComponent: kGroupComponent, animated: false)
        
        // Format views
        formatButtons()
        
        // Hide necessary views
        hideSaveButton(false)
        nameField.hidden = true
        groupPicker.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - IB Actions
    
    @IBAction func specialPressed(sender: AnyObject) {
        
        let imageName: String
        if isSpecial {
            isSpecial = false
            imageName = kWhiteStarImage
        }
        else {
            isSpecial = true
            imageName = kYellowStarImage
        }
        specialButton.setImage(UIImage(named: imageName), forState: .Normal)
        
        // Check if the UI should change
        checkForChanges()
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
        flipPickerView()
    }
    
    @IBAction func editNamePressed(sender: AnyObject) {
        nameField.text = itemNameLabel.text
        nameField.hidden = false
        itemNameLabel.hidden = true
        nameField.becomeFirstResponder()
    }
    
    
    // MARK: - Picker View Datasource/Delegate
    
    // numberOfComponents
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return pickerView == groupPicker ? 1 : 2
    }
    
    // numberOfRowsInComponent
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == groupPicker {
            return kGroups.count + 1
        }
        else {  // Amount picker
            return (component == kQuantityComponent ? 100 : 5) + 1
        }
    }
    
    // titleForRow
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        // Check if the item group is being edited
        if pickerView == groupPicker {
            // Return item group name selections
            return row == 0 ? "< Group >" : kGroups[row - 1]
        }
        else {  // Amount picker
            if component == kQuantityComponent {
                // Return quantity selections
                return row == 0 ? "< Amount >" : "\(row - 1)"
            }
            else {
                // Return unit type selections
                return row == 0 ? "< Units >" : "\(row - 1)'s"
            }
        }
    }
    
    // didSelectRow
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
        if pickerView == amountPicker {
            itemQuantityOrUnitChanged(component, row: row)
        }
    }
    
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //if let vc = segue.destinationViewController as? InventoryViewController {
            //vc.rowChanged
        //}
    }

    
    // MARK: - Gesture Handlers
    
    func tapHandler(sender: UIGestureRecognizer) {
        if sender.state == .Ended {
            // Check if the item name of group was being edited
            if !nameField.hidden {
                // Name editing should end, replace text and hide text field
                itemNameLabel.text = nameField.text
                nameField.resignFirstResponder()
                nameField.hidden = true
                itemNameLabel.hidden = false
            }
            else if editingGroup {
                // Get group selection
                lastGroupRow = groupPicker.selectedRowInComponent(kGroupComponent)
                
                // Display valid selection via label
                if lastGroupRow != 0 {
                    itemGroupLabel.text = kGroups[lastGroupRow - 1]
                    flipPickerView()
                }
            }
            
            // Check if the UI should change
            checkForChanges()
        }
    }
    
    
    // MARK: - Private API
    
    private func flipPickerView() {
        // Flip and reload the picker
        if !editingGroup {
            editingGroup = true
            UIView.transitionWithView(self.flipView,
                                      duration: 0.75,
                                      options: .TransitionFlipFromLeft,
                                      animations: {
                                        self.amountPicker.hidden = true
                                        self.groupPicker.hidden = false
                }, completion: nil)
        }
        else {
            editingGroup = false
            UIView.transitionWithView(self.flipView,
                                      duration: 0.75,
                                      options: .TransitionFlipFromRight,
                                      animations: {
                                        self.amountPicker.hidden = false
                                        self.groupPicker.hidden = true
                }, completion: nil)
        }
    }
    
    private func itemQuantityOrUnitChanged(component: Int, row: Int) {
        
        // Disallow saving for top row (with "<Select ...>" text)
        guard row != 0 else {
            amountChanged = false
            if saveShowing {
                hideSaveButton(true)
            }
            return
        }
        
        // Save selection
        switch component {
        case kQuantityComponent:
            // Item quantity
            lastQuantityRow = row
        case kUnitComponent:
            // Unit of measurement
            lastUnitRow = row
        default:
            break
        }
        
        // Check if last selections are different from the initial values
        amountChanged = lastQuantityRow != initQuantity! + 1
            || lastUnitRow != initUnit! + 1
        
        // Check if the UI should change
        checkForChanges()
    }
    
    private func checkForChanges() {
        // Check if the amount/unit, special status, item name, or group changed
        let changesMade = amountChanged || initSpecial != isSpecial
            || initName != itemNameLabel.text || kGroups[initGroup!] != itemGroupLabel.text
        
        // Show or hide the save button depending on the results
        if changesMade {
            if !saveShowing {
                showSaveButton()
            }
        }
        else if saveShowing {
            hideSaveButton(true)
        }
    }
    
    private func showSaveButton() {
        // Animate save button into view
        saveShowing = true
        UIView.animateWithDuration(0.25, animations: {
                self.saveChangesButton.alpha = self.kButtonActiveAlpha
            }, completion: { (status) in
                self.saveChangesButton.userInteractionEnabled = true
        })
    }
    
    private func hideSaveButton(animated: Bool) {
        // Hide save button via fade animation
        saveChangesButton.userInteractionEnabled = false
        saveShowing = false
        
        if !animated {
            saveChangesButton.alpha = kButtonInactiveAlpha
        }
        else {
            UIView.animateWithDuration(0.25, animations: {
                self.saveChangesButton.alpha = self.kButtonInactiveAlpha
            })
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
    

}
