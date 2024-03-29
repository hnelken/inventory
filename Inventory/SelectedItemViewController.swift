//
//  SelectedItemViewController.swift
//  Inventory
//
//  Created by Harry Nelken on 9/6/16.
//  Copyright © 2016 Da Legna. All rights reserved.
//

import UIKit
import CoreData

class SelectedItemViewController: UIViewController, AKPickerViewDataSource, AKPickerViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    // MARK: - Public References
    var initItem: InventoryItem?
    weak var initImage: UIImage?
    
    // MARK: - Private Variables
    fileprivate var initSpecial: Bool!
    fileprivate var initQuantity: Int!
    fileprivate var initUnit: Int!
    fileprivate var initGroup: Int!
    fileprivate var initName: String!
    
    fileprivate var lastGroupRow = 0
    fileprivate var lastQuantityRow = 0
    fileprivate var lastUnitRow = 0
    fileprivate var isSpecial = false
    fileprivate var editingGroup = false
    fileprivate var editingName = false
    
    // MARK: - IB Outlets
    // -    Labels
    @IBOutlet weak var pickerLabel: ShadowLabel!
    @IBOutlet weak var itemGroupLabel: ShadowLabel!
    @IBOutlet weak var itemNameLabel: ShadowLabel!
    @IBOutlet weak var amountLabel: ShadowLabel!
    
    // -    Text Fields
    @IBOutlet weak var nameField: UITextField!
    
    // -    Misc. Views
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var groupPicker: UIPickerView!
    @IBOutlet weak var unitPicker: AKPickerView!
    
    // -    Buttons
    @IBOutlet weak var minusButton: FadingButton!
    @IBOutlet weak var plusButton: FadingButton!
    @IBOutlet weak var editGroupButton: FadingButton!
    @IBOutlet weak var editNameButton: FadingButton!
    @IBOutlet weak var editImageButton: FadingButton!
    @IBOutlet weak var addToCartButton: FadingButton!
    @IBOutlet weak var deleteItemButton: FadingButton!
    @IBOutlet weak var saveChangesButton: FadingButton!
    @IBOutlet weak var specialButton: UIButton!
    
    // -    AutoLayout Constraints
    @IBOutlet weak var pickerViewWidth: NSLayoutConstraint!
    @IBOutlet weak var pickerViewCenter: NSLayoutConstraint!
    @IBOutlet weak var amountViewWidth: NSLayoutConstraint!
    @IBOutlet weak var amountViewCenter: NSLayoutConstraint!
    
    
    // MARK: - View Controller 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add touch recognizer to hide text field during editing
        let touch = UITapGestureRecognizer(target: self, action: .tapHandler)
        view.addGestureRecognizer(touch)
        
        // Get item passed via segue if available
        let item: InventoryItem
        if let thisItem = initItem {
            item = thisItem
        }
        else {  // Otherwise make a dummy one for safety
            item = InventoryItem(name: "(default)", group: 0, special: false)
        }
        
        // Transfer settings from selected item
        // -    Special
        isSpecial = item.special
        initSpecial = item.special
        
        // -    Group
        initGroup = item.group
        lastGroupRow = item.group
        
        // -    Name
        initName = item.name
        
        // -    Quantity
        initQuantity = item.quantity
        lastQuantityRow = initQuantity
        
        // -    Units of measurement
        initUnit = item.unitType
        lastUnitRow = initUnit
        
        // Display settings from selected item
        // -    Show item image
        if let image = initImage {
            itemImageView.image = image
        }
        
        // -    Show special status via button color
        if isSpecial {
            specialButton.setImage(UIImage(named: kYellowStarImage), for: UIControlState())
        }
        else {
            specialButton.setImage(UIImage(named: kWhiteStarImage), for: UIControlState())
        }
        
        // -    Show item group and name
        itemGroupLabel.text = kGroups[initGroup]
        itemNameLabel.text = initName
        groupPicker.selectRow(lastGroupRow, inComponent: kGroupComponent, animated: false)
        
        // -    Show item quantity
        amountLabel.text = "\(lastQuantityRow)"
        
        // -    Show units of measurement
        unitPicker.selectItem(lastUnitRow, animated: false)
        
        // Hide necessary views
        saveChangesButton.disable()
        nameField.isHidden = true
        groupPicker.isHidden = false
        
        // Format views via constraints
        amountViewCenter.constant = 0
        pickerViewCenter.constant = view.frame.width
       // groupPicker.isHidden = true
        amountViewWidth.constant = view.frame.width - 40
        pickerViewWidth.constant = view.frame.width - 40
        
        // Set horizontal picker delegate / data source
        unitPicker.dataSource = self
        unitPicker.delegate = self
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //if let vc = segue.destinationViewController as? InventoryViewController {
        //vc.rowChanged
        //}
    }
    
    
    // MARK: - Text Field Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Stop editing and save
        endAllEditing(true)
        
        return true
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
        label.font = UIFont(name: kFontName, size: 20.0)
        label.textAlignment = .center
        label.attributedText = NSAttributedString(string: kUnits[item],
                                                  attributes: [NSForegroundColorAttributeName: UIColor.white])
    }
    
    func pickerView(_ pickerView: AKPickerView, didSelectItem item: Int) {
        lastUnitRow = item
        checkForChanges()
    }
    
    
    // MARK: - Picker View Datasource / Delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return kGroups.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let title = getAttributedPickerTitle(for: row)
        guard let label = view as? ShadowLabel else {
            let pickerLabel = ShadowLabel()
            pickerLabel.font = UIFont(name: kFontName, size: 22.0)
            pickerLabel.textAlignment = .center
            pickerLabel.attributedText = title
            return pickerLabel
        }
        label.attributedText = title
        return label
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
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
        addItemToCart(initItem!)
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
        checkForChanges()
    }
    
    @IBAction func minusPressed(_ sender: AnyObject) {
        lastQuantityRow -= 1
        amountLabel.text = "\(lastQuantityRow)"
        checkForChanges()
    }
    
    
    // MARK: - Private API
    
    fileprivate func addItemToCart(_ item: InventoryItem) {
        
        // Get managed object context
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        // Create cart item
        let entity = NSEntityDescription.entity(forEntityName: "CartItem", in: managedContext)
        let cartItem = CartItem(entity: entity!, insertInto: managedContext)
        
        // Make changes to item entity
        cartItem.name = item.name
        cartItem.special = item.special
        cartItem.group = Int32(item.group)
        cartItem.quantity = Int32(item.quantity)
        cartItem.unitType = Int32(item.unitType)
        cartItem.imageName = item.imageName
        
        // Save context
        do {
            try managedContext.save()
            appDelegate.items.append(cartItem)
        } catch let error as NSError  {
            print("Could not add item to cart \(error), \(error.userInfo)")
        }
    }
    
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
    
        slideViews(true)
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
        
        slideViews(true)
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
    
    fileprivate func slideViews(_ slide: Bool) {
        view.layoutIfNeeded()
        
        // Check which transition is occurring
        
        if editingGroup {   //  Beginning editing
            //  Slide views to show group picker view
            amountViewCenter.constant = -self.view.frame.width
            pickerViewCenter.constant = 0
        }
        else {  //  Editing is ending
            // Slide views to show amount/units view
            amountView.isHidden = false
            amountViewCenter.constant = 0
            pickerViewCenter.constant = self.view.frame.width
        }
        
        // Animate changes
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
            }, completion: { (status) in
                if self.editingGroup {
                    self.amountView.isHidden = true
                }
        })
        
        
    }
    
    fileprivate func checkForChanges() {
        // Check if the amount/unit, special status, item name, or group changed
        let changesMade = initQuantity != lastQuantityRow
            || initUnit != lastUnitRow
            || initSpecial != isSpecial
            || initName != itemNameLabel.text
            || kGroups[initGroup] != itemGroupLabel.text
        
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
