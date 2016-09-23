//
//  SelectedItemViewController.swift
//  Inventory
//
//  Created by Harry Nelken on 9/6/16.
//  Copyright © 2016 Da Legna. All rights reserved.
//

import UIKit

class SelectedItemViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    // CG Constants
    let kButtonInactiveAlpha: CGFloat = 0.2
    let kButtonActiveAlpha: CGFloat = 0.8

    // Public References
    var initItem: InventoryItem?
    weak var initImage: UIImage?
    
    var initSpecial: Bool!
    var initQuantity: Int!
    var initUnit: Int!
    var initGroup: Int!
    var initName: String!
    
    // Private Variables
    fileprivate var lastGroupRow = 0
    fileprivate var lastQuantityRow = 0
    fileprivate var lastUnitRow = 0
    fileprivate var isSpecial = false
    fileprivate var amountChanged = false
    fileprivate var changesMade = false
    fileprivate var editingGroup = false
    fileprivate var editingName = false
    fileprivate var canSave = false
    
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
        
        // Get item passed via segue if available
        let item: InventoryItem
        if let thisItem = initItem {
            item = thisItem
        }
        else {
            item = InventoryItem(name: "(default)", group: 0, special: false)
        }
        
        // Transfer settings from selected item
        
        // - Special
        isSpecial = item.special
        initSpecial = item.special
        
        // - Group
        initGroup = item.group
        lastGroupRow = item.group
        
        // - Name
        initName = item.name
        
        // - Quantity
        initQuantity = item.quantity
        lastQuantityRow = initQuantity
        
        // - Units of measurement
        initUnit = item.units
        lastUnitRow = initUnit
        
        
        // Display settings from selected item
        
        // - Show item image
        if let image = initImage {
            itemImageView.image = image
        }
        
        // - Show special status via button color
        if isSpecial {
            specialButton.setImage(UIImage(named: kYellowStarImage), for: UIControlState())
        }
        else {
            specialButton.setImage(UIImage(named: kWhiteStarImage), for: UIControlState())
        }
        
        // - Show item group and name
        itemGroupLabel.text = kGroups[initGroup]
        itemNameLabel.text = initName
        
        // - Show current selections in picker views
        groupPicker.selectRow(lastGroupRow, inComponent: kGroupComponent, animated: false)
        amountPicker.selectRow(lastQuantityRow, inComponent: kQuantityComponent, animated: false)
        amountPicker.selectRow(lastUnitRow, inComponent: kUnitComponent, animated: false)
        
        // Hide necessary views
        saveChangesButton.disable()
        nameField.isHidden = true
        groupPicker.isHidden = true
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //if let vc = segue.destinationViewController as? InventoryViewController {
        //vc.rowChanged
        //}
    }
    
    
    // MARK: - Text Field Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        endAllEditing()
        
        return true
    }
    
    
    // MARK: - Picker View Datasource/Delegate
    
    // numberOfComponents
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerView == groupPicker ? 1 : 2
    }
    
    // numberOfRowsInComponent
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == groupPicker {
            return kGroups.count
        }
        else {  // Amount picker
            return (component == kQuantityComponent ? 100 : 5)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let font = UIFont(name: "HelveticaNeue-Light", size: 20.0)
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        
        let attributes: [String : Any] = [
            NSFontAttributeName: font,
            NSParagraphStyleAttributeName: style
        ]
        
        let attributedTitle: NSAttributedString
        
        // Check if the item group is being edited
        if pickerView == groupPicker {
            // Return item group name selections
            attributedTitle = NSAttributedString(string: kGroups[row], attributes: attributes)
        }
        else {  // Amount picker
            if component == kQuantityComponent {
                // Return quantity selections
                attributedTitle = NSAttributedString(string: "\(row)", attributes: attributes)
            }
            else {
                // Return unit type selections
                attributedTitle = NSAttributedString(string: "\(row)'s", attributes: attributes)
            }
        }
        
        return attributedTitle
    }
    
    // didSelectRow
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == amountPicker {
            itemQuantityOrUnitChanged(component, row: row)
        }
    }

    
    // MARK: - Gesture Handlers
    
    func tapHandler(_ sender: UIGestureRecognizer) {
        if sender.state == .ended && editingName {
            endAllEditing()
        }
    }

    
    // MARK: - IB Actions
    
    @IBAction func specialPressed(_ sender: AnyObject) {
        
        let imageName: String
        if isSpecial {
            isSpecial = false
            imageName = kWhiteStarImage
        }
        else {
            isSpecial = true
            imageName = kYellowStarImage
        }
        specialButton.setImage(UIImage(named: imageName), for: UIControlState())
        
        // Check if the UI should change
        checkForChanges()
    }
    
    @IBAction func addToCartPressed(_ sender: AnyObject) {
    }
    
    @IBAction func savePressed(_ sender: AnyObject) {
    }
    
    @IBAction func deletePressed(_ sender: AnyObject) {
        // End editing if in progress
        if editingGroup || editingName {
            endAllEditing()
        }
        else {  // Otherwise function as delete button
            // Throw alert view
        }
    }
    
    @IBAction func editImagePressed(_ sender: AnyObject) {
    }
  
    @IBAction func editGroupPressed(_ sender: AnyObject) {
        startEditingGroup()
    }
    
    @IBAction func editNamePressed(_ sender: AnyObject) {
        startEditingName()
    }
    
    
    // MARK: - Private API
    
    fileprivate func startEditingName() {
        editingName = true
        
        // Show and fill text field, hiding label
        nameField.text = itemNameLabel.text
        nameField.isHidden = false
        itemNameLabel.isHidden = true
        
        // Handle buttons
        deleteItemButton.setTitle(kDoneButtonTitle, for: UIControlState())
        editNameButton.toggleHighlight()
        
        UIView.animate(withDuration: kButtonFadeDuration, animations: {
            self.editGroupButton.disable()
            self.editImageButton.disable()
            self.addToCartButton.disable()
            self.saveChangesButton.disable()
            }, completion: nil)
        
        // Bring up keyboard
        nameField.becomeFirstResponder()
    }
    
    fileprivate func stopEditingName() {
        editingName = false
        
        // Change and show label and hide text field and keyboard
        itemNameLabel.text = nameField.text
        nameField.resignFirstResponder()
        itemNameLabel.isHidden = false
        nameField.isHidden = true
        
        // Handle buttons
        deleteItemButton.setTitle(kDeleteButtonTitle, for: UIControlState())
        editNameButton.toggleHighlight()
        
        UIView.animate(withDuration: kButtonFadeDuration, animations: {
            self.editGroupButton.enable()
            self.editImageButton.enable()
            self.addToCartButton.enable()
            }, completion: nil)
        // Save button is accounted for in checkForChanges()
    }
    
    fileprivate func startEditingGroup() {
        editingGroup = true
        
        // Handle buttons
        deleteItemButton.setTitle(kDoneButtonTitle, for: UIControlState())
        editGroupButton.toggleHighlight()
        
        UIView.animate(withDuration: kButtonFadeDuration, animations: {
            self.editNameButton.disable()
            self.editImageButton.disable()
            self.addToCartButton.disable()
            self.saveChangesButton.disable()
            }, completion: nil)
    
        flipPickerView()
    }
    
    fileprivate func stopEditingGroup() {
        editingGroup = false
        
        // Get group selection
        lastGroupRow = groupPicker.selectedRow(inComponent: kGroupComponent)
        
        // Change text label
        itemGroupLabel.text = kGroups[lastGroupRow]
        
        // Handle buttons
        deleteItemButton.setTitle(kDeleteButtonTitle, for: UIControlState())
        editGroupButton.toggleHighlight()
        UIView.animate(withDuration: kButtonFadeDuration, animations: {
            self.editNameButton.enable()
            self.editImageButton.enable()
            self.addToCartButton.enable()
            }, completion: nil)
        
        // Save button is accounted for in checkForChanges()
        
        flipPickerView()
    }
    
    fileprivate func endAllEditing() {
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
    
    fileprivate func flipPickerView() {
        // Flip and reload the picker
        if editingGroup {
            // Editing just began, flip to group picker
            UIView.transition(with: self.flipView,
                              duration: 0.75,
                              options: .transitionFlipFromLeft,
                              animations: {
                                self.pickerLabel.text = "Current item group:"
                                self.amountPicker.isHidden = true
                                self.groupPicker.isHidden = false
                }, completion: nil)
        }
        else {
            // Editing just ended, flip to quantity/units picker
            UIView.transition(with: self.flipView,
                              duration: 0.75,
                              options: .transitionFlipFromRight,
                              animations: {
                                self.pickerLabel.text = "Current amount in stock:"
                                self.amountPicker.isHidden = false
                                self.groupPicker.isHidden = true
                }, completion: nil)
        }
    }
    
    fileprivate func itemQuantityOrUnitChanged(_ component: Int, row: Int) {
        
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
    
    fileprivate func checkForChanges() {
        // Check if the amount/unit, special status, item name, or group changed
        changesMade = amountChanged || initSpecial != isSpecial
            || initName != itemNameLabel.text || kGroups[initGroup] != itemGroupLabel.text
        
        // Show or hide the save button depending on the results
        if changesMade {
            UIView.animate(withDuration: kButtonFadeDuration, animations: {
                self.saveChangesButton.enable()
                }, completion: nil)
        }
        else {
            UIView.animate(withDuration: kButtonFadeDuration, animations: {
                self.saveChangesButton.disable()
                }, completion: nil)
        }
    }
}
