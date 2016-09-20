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
    private var changesMade = false
    private var editingGroup = false
    private var editingName = false
    private var canSave = false
    
    // IB Outlets=
    @IBOutlet weak var pickerLabel: ShadowLabel!
    @IBOutlet weak var itemGroupLabel: ShadowLabel!
    @IBOutlet weak var itemNameLabel: ShadowLabel!
    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var amountPicker: UIPickerView!
    @IBOutlet weak var groupPicker: UIPickerView!
    
    @IBOutlet weak var flipView: UIView!
    
    @IBOutlet weak var editGroupButton: FadingButton!
    @IBOutlet weak var editNameButton: FadingButton!
    @IBOutlet weak var editImageButton: FadingButton!
    @IBOutlet weak var addToCartButton: FadingButton!
    @IBOutlet weak var deleteItemButton: FadingButton!
    @IBOutlet weak var saveChangesButton: FadingButton!
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
            lastGroupRow = group
        }
        else {
            lastGroupRow = 0
            initGroup = 0
        }
        
        if let name = initName {
            itemNameLabel.text = name
        }
        
        if let image = initImage {
            itemImageView.image = image
        }

        // Get item quantity
        if let quantity = initQuantity {
            lastQuantityRow = quantity
        }
        else {
            lastQuantityRow = 0
            initQuantity = 0
        }
        
        // Get unit of measurement
        if let unit = initUnit {
            lastUnitRow = unit
        }
        else {
            lastUnitRow = 0
            initUnit = 0
        }
        
        // Display group, quantity, and unit of measurement in picker views
        amountPicker.selectRow(lastQuantityRow, inComponent: kQuantityComponent, animated: false)
        amountPicker.selectRow(lastUnitRow, inComponent: kUnitComponent, animated: false)
        groupPicker.selectRow(lastGroupRow, inComponent: kGroupComponent, animated: false)
        
        // Hide necessary views
        saveChangesButton.hide(false)
        nameField.hidden = true
        groupPicker.hidden = true
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //if let vc = segue.destinationViewController as? InventoryViewController {
        //vc.rowChanged
        //}
    }
    
    
    // MARK: - Picker View Datasource/Delegate
    
    // numberOfComponents
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return pickerView == groupPicker ? 1 : 2
    }
    
    // numberOfRowsInComponent
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == groupPicker {
            return kGroups.count
        }
        else {  // Amount picker
            return (component == kQuantityComponent ? 100 : 5)
        }
    }
    
    // titleForRow
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        // Check if the item group is being edited
        if pickerView == groupPicker {
            // Return item group name selections
            return kGroups[row]
        }
        else {  // Amount picker
            if component == kQuantityComponent {
                // Return quantity selections
                return "\(row)"
            }
            else {
                // Return unit type selections
                return "\(row)'s"
            }
        }
    }
    
    // didSelectRow
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == amountPicker {
            itemQuantityOrUnitChanged(component, row: row)
        }
    }

    
    // MARK: - Gesture Handlers
    
    func tapHandler(sender: UIGestureRecognizer) {
        if sender.state == .Ended {
            //endAllEditing()
        }
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
        // End editing if in progress
        if editingGroup || editingName {
            endAllEditing()
        }
        else {  // Otherwise function as delete button
            // Throw alert view
        }
    }
    
    @IBAction func editImagePressed(sender: AnyObject) {
    }
  
    @IBAction func editGroupPressed(sender: AnyObject) {
        startEditingGroup()
    }
    
    @IBAction func editNamePressed(sender: AnyObject) {
        startEditingName()
    }
    
    
    // MARK: - Private API
    
    private func startEditingName() {
        editingName = true
        
        // Show and fill text field, hiding label
        nameField.text = itemNameLabel.text
        nameField.hidden = false
        itemNameLabel.hidden = true
        
        // Handle buttons
        deleteItemButton.setTitle(kDoneButtonTitle, forState: .Normal)
        editNameButton.toggleHighlight()
        editGroupButton.hide(true)
        editImageButton.hide(true)
        addToCartButton.hide(true)
        saveChangesButton.hide(true)
        
        // Bring up keyboard
        nameField.becomeFirstResponder()
    }
    
    private func stopEditingName() {
        editingName = false
        
        // Change and show label and hide text field and keyboard
        itemNameLabel.text = nameField.text
        nameField.resignFirstResponder()
        itemNameLabel.hidden = false
        nameField.hidden = true
        
        // Handle buttons
        deleteItemButton.setTitle(kDeleteButtonTitle, forState: .Normal)
        editNameButton.toggleHighlight()
        editGroupButton.show()
        editImageButton.show()
        addToCartButton.show()
        // Save button is accounted for in checkForChanges()
    }
    
    private func startEditingGroup() {
        editingGroup = true
        
        // Handle buttons
        deleteItemButton.setTitle(kDoneButtonTitle, forState: .Normal)
        editGroupButton.toggleHighlight()
        editNameButton.hide(true)
        editImageButton.hide(true)
        addToCartButton.hide(true)
        saveChangesButton.hide(true)
        
        flipPickerView()
    }
    
    private func stopEditingGroup() {
        editingGroup = false
        
        // Get group selection
        lastGroupRow = groupPicker.selectedRowInComponent(kGroupComponent)
        
        // Change text label
        itemGroupLabel.text = kGroups[lastGroupRow]
        
        // Handle buttons
        deleteItemButton.setTitle(kDeleteButtonTitle, forState: .Normal)
        editGroupButton.toggleHighlight()
        editNameButton.show()
        editImageButton.show()
        addToCartButton.show()
        // Save button is accounted for in checkForChanges()
        
        flipPickerView()
    }
    
    private func endAllEditing() {
        // Check if the item name or group was being edited
        if editingName {
            stopEditingName()
        }
        else if editingGroup {
            stopEditingGroup()
        }
        
        // Check if the UI should change
        checkForChanges()
    }
    
    private func flipPickerView() {
        // Flip and reload the picker
        if editingGroup {
            // Editing just began, flip to group picker
            UIView.transitionWithView(self.flipView,
                                      duration: 0.75,
                                      options: .TransitionFlipFromLeft,
                                      animations: {
                                        self.pickerLabel.text = "Current item group:"
                                        self.amountPicker.hidden = true
                                        self.groupPicker.hidden = false
                }, completion: nil)
        }
        else {
            // Editing just ended, flip to quantity/units picker
            UIView.transitionWithView(self.flipView,
                                      duration: 0.75,
                                      options: .TransitionFlipFromRight,
                                      animations: {
                                        self.pickerLabel.text = "Current amount in stock:"
                                        self.amountPicker.hidden = false
                                        self.groupPicker.hidden = true
                }, completion: nil)
        }
    }
    
    private func itemQuantityOrUnitChanged(component: Int, row: Int) {
        
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
        amountChanged = lastQuantityRow != initQuantity!
            || lastUnitRow != initUnit!
        
        // Check if the UI should change
        checkForChanges()
    }
    
    private func checkForChanges() {
        // Check if the amount/unit, special status, item name, or group changed
        changesMade = amountChanged || initSpecial != isSpecial
            || initName != itemNameLabel.text || kGroups[initGroup!] != itemGroupLabel.text
        
        // Show or hide the save button depending on the results
        if changesMade {
            saveChangesButton.show()
        }
        else {
            saveChangesButton.hide(true)
        }
    }
}
