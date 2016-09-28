//
//  SelectedItemViewController.swift
//  Inventory
//
//  Created by Harry Nelken on 9/6/16.
//  Copyright © 2016 Da Legna. All rights reserved.
//

import UIKit

class SelectedItemViewController: UIViewController, AKPickerViewDataSource, AKPickerViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
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
    @IBOutlet weak var amountLabel: ShadowLabel!
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var groupPicker: UIPickerView!
    
    @IBOutlet weak var unitPicker: AKPickerView!
    
    @IBOutlet weak var amountView: UIView!
    
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var editGroupButton: FadingButton!
    @IBOutlet weak var editNameButton: FadingButton!
    @IBOutlet weak var editImageButton: FadingButton!
    @IBOutlet weak var addToCartButton: FadingButton!
    @IBOutlet weak var deleteItemButton: FadingButton!
    @IBOutlet weak var saveChangesButton: FadingButton!
    @IBOutlet weak var specialButton: UIButton!
    
    @IBOutlet weak var pickerViewWidth: NSLayoutConstraint!
    @IBOutlet weak var pickerViewCenter: NSLayoutConstraint!
    @IBOutlet weak var amountViewWidth: NSLayoutConstraint!
    @IBOutlet weak var amountViewCenter: NSLayoutConstraint!
    
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
        groupPicker.selectRow(lastGroupRow, inComponent: kGroupComponent, animated: false)
        
        // - Show item quantity
        amountLabel.text = "\(lastQuantityRow)"
        
        // Hide necessary views
        saveChangesButton.disable()
        nameField.isHidden = true
        groupPicker.isHidden = false
        
        // Format views via constraints
        amountViewCenter.constant = 0
        pickerViewCenter.constant = view.frame.width
        
        amountViewWidth.constant = view.frame.width - 40
        pickerViewWidth.constant = view.frame.width - 40
        
        unitPicker.dataSource = self
        unitPicker.delegate = self
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //if let vc = segue.destinationViewController as? InventoryViewController {
        //vc.rowChanged
        //}
    }
    
    
    // MARK: - AKPickerView Data Source / Delegate
    
    func numberOfItemsInPickerView(_ pickerView: AKPickerView) -> Int {
        return kUnits.count
    }
    
    func pickerView(_ pickerView: AKPickerView, marginForItem item: Int) -> CGSize {
        return CGSize(width: 25, height: 45)
    }
    
    func pickerView(_ pickerView: AKPickerView, titleForItem item: Int) -> String {
        return kUnits[item]
    }
    
    func pickerView(_ pickerView: AKPickerView, configureLabel label: UILabel, forItem item: Int) {
        label.font = UIFont(name: kFontName, size: 24.0)
        label.textAlignment = .center
        label.attributedText = NSAttributedString(string: kUnits[item],
                                                  attributes: [NSForegroundColorAttributeName: UIColor.white])
    }
    
    
    // MARK: - Text Field Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Stop editing and save
        endAllEditing(true)
        
        return true
    }
    
    
    // MARK: - Picker View Datasource / Delegate
    
    // numberOfComponents
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // numberOfRowsInComponent
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return kGroups.count
    }
    
    // viewForRow
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let title = getAttributedPickerTitle(for: row)
        guard let label = view as? ShadowLabel else {
            let pickerLabel = ShadowLabel()
            pickerLabel.font = UIFont(name: kFontName, size: 24.0)
            pickerLabel.textAlignment = .center
            pickerLabel.attributedText = title
            return pickerLabel
        }
        label.attributedText = title
        return label
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    // MARK: - Gesture Handlers
    
    func tapHandler(_ sender: UIGestureRecognizer) {
        if sender.state == .ended && editingName {
            stopEditingName(false)
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
            // Stop editing and save changes
            endAllEditing(true)
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
    
    @IBAction func plusPressed(_ sender: AnyObject) {
        lastQuantityRow += 1
        amountLabel.text = "\(lastQuantityRow)"
        amountChanged = lastQuantityRow != initQuantity
        checkForChanges()
    }
    
    @IBAction func minusPressed(_ sender: AnyObject) {
        lastQuantityRow -= 1
        amountLabel.text = "\(lastQuantityRow)"
        amountChanged = lastQuantityRow != initQuantity
        checkForChanges()
    }
    
    
    // MARK: - Private API
    
    fileprivate func getAttributedPickerTitle(for row: Int) -> NSAttributedString {
        return NSAttributedString(string: kGroups[row], attributes: [
            NSForegroundColorAttributeName: UIColor.white
            ])
    }
    
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
    
    fileprivate func stopEditingName(_ saveChanges: Bool) {
        editingName = false
        
        // Change and show label and hide text field and keyboard
        if saveChanges {
            itemNameLabel.text = nameField.text
        }
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
    
        slideViews()
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
        
        slideViews()
    }
    
    fileprivate func endAllEditing(_ saveChanges: Bool) {
        // Check if the item name or group was being edited
        if editingName {
            stopEditingName(saveChanges)
        }
        else if editingGroup {
            stopEditingGroup()
        }
        
        // Check if the UI should change
        checkForChanges()
    }
    
    fileprivate func slideViews() {
        self.view.layoutIfNeeded()
        
        // Check which transition is occurring
        
        if editingGroup {   //  Beginning editing
            //  Slide views to show group picker view
            self.amountViewCenter.constant = -self.view.frame.width
            self.pickerViewCenter.constant = 0
        }
        else {  //  Editing is endging
            // Slide views to show amount/units view
            self.amountViewCenter.constant = 0
            self.pickerViewCenter.constant = self.view.frame.width
        }
        // Animate changes
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
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
