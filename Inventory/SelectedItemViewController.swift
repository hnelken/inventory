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
    var initGroup: Int?
    var initName: String?
    weak var initImage: UIImage?
    
    // Private Variables
    private var selectedQuantity = 26
    private var selectedUnit = 1
    private var isSpecial = false
    private var amountChanged = false
    private var saveShowing = false
    private var editingGroup = false
    
    // IB Outlets=
    @IBOutlet weak var itemGroupLabel: ShadowLabel!
    @IBOutlet weak var itemNameLabel: ShadowLabel!
    @IBOutlet weak var itemImageView: UIImageView!
    
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
        if let special = initSpecial {
            isSpecial = special
            if isSpecial {
                specialButton.setImage(UIImage(named: kYellowStarImage), forState: .Normal)
            }
            else {
                specialButton.setImage(UIImage(named: kWhiteStarImage), forState: .Normal)
            }
        }
        
        if let group = initGroup {
            itemGroupLabel.text = kGroups[group]
        }
        
        if let name = initName {
            itemNameLabel.text = name
        }
        
        if let image = initImage {
            itemImageView.image = image
        }

        // Preselect rows in picker view
        if editingGroup {
            editingGroup = false
        }
        pickerView.selectRow(selectedQuantity, inComponent: kQuantityComponent, animated: false)
        pickerView.selectRow(selectedUnit, inComponent: kUnitComponent, animated: false)
        
        // Hide/format buttons in view
        hideSaveButton(false)
        formatButtons()
        
        // Hide text fields
        nameField.hidden = true
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
        flipPickerView(true)
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
    
    
    // MARK: - Picker View Datasource/Delegate
    
    // numberOfComponents
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return editingGroup ? 1 : 2
    }
    
    // numberOfRowsInComponent
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if editingGroup {
            return kGroups.count + 1
        }
        else {
            return component == kQuantityComponent ? 101 : 6
        }
    }
    
    // titleForRow
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // Check if the item group is being edited
        if editingGroup {
            // Return item group name selections
            return row == 0 ? "<Select Group>" : kGroups[row - 1]
        }
        else if component == kQuantityComponent {
            // Return quantity selections
            return row == 0 ? "<Select Quantity>" : "\(row - 1)"
        }
        else {
            // Return unit type selections
            return row == 0 ? "<Select Unit Type>" : "Unit type \(row)"
        }
    }
    
    // didSelectRow
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
        if !editingGroup {
            itemQuantityOrUnitChanged(component, row: row)
        }
    }
    
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let vc = segue.destinationViewController as? InventoryViewController {
            //vc.rowChanged
        }
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
                // Check if a new group was selected
                let selectedGroup = pickerView.selectedRowInComponent(kGroupComponent) - 1
                if selectedGroup != -1 {
                    itemGroupLabel.text = kGroups[selectedGroup]
                }
                flipPickerView(false)
            }
            checkForChanges()
        }
    }
    
    
    // MARK: - Private API
    
    private func flipPickerView(toGroup: Bool) {
        // Flip and reload the picker
        if toGroup {
            editingGroup = true
            UIView.transitionWithView(self.pickerView, duration: 0.5, options: .TransitionFlipFromRight, animations: {
                self.pickerView.reloadAllComponents()
                }, completion: nil)
        }
        else {
            editingGroup = false
            UIView.transitionWithView(self.pickerView, duration: 0.5, options: .TransitionFlipFromLeft, animations: {
                self.pickerView.reloadAllComponents()
                }, completion: nil)
        }
    }
    
    private func itemQuantityOrUnitChanged(component: Int, row: Int) {
        // Respond to selection in quantity/unit picker view depending on current changes status
        if amountChanged {  // Changes have been made previously
            // Check if ALL changes have been reverted
            if selectedQuantity == pickerView.selectedRowInComponent(kQuantityComponent) &&
                selectedUnit == pickerView.selectedRowInComponent(kUnitComponent) {
                
                // Changes have been reverted
                amountChanged = false
            }
        }
        else {  // No changes have been made yet
            // Check for changes in...
            switch component {
            // Item quantity
            case kQuantityComponent:
                amountChanged = selectedQuantity != row
            // Unit of measurement
            case kUnitComponent:
                amountChanged = selectedUnit != row
            default:
                // Otherwise previous selection was reselected
                return
            }
        }
        
        // Signal that changes have been made
        checkForChanges()
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
    
    private func checkForChanges() {
        // Check if the amount/unit, special status, item name, or group changed
        let changesMade = (amountChanged || isSpecial != initSpecial
            || initName != itemNameLabel.text || kGroups[initGroup!] != itemGroupLabel.text)
        
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
