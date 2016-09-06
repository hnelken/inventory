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
    var itemName: String?
    weak var itemImage: UIImage?
    
    // Private Variables
    private var selectedQuantity = 0
    private var selectedUnit = 0
    private var changesMade = false
    
    // IB Outlets
    @IBOutlet weak var itemCategoryLabel: ShadowLabel!
    @IBOutlet weak var itemNameLabel: ShadowLabel!
    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var editCategoryButton: UIButton!
    @IBOutlet weak var editNameButton: UIButton!
    @IBOutlet weak var editImageButton: UIButton!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var deleteItemButton: UIButton!
    @IBOutlet weak var saveChangesButton: UIButton!
    
    
    // MARK: - View Controller 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set picture and title for selected item
        if let name = itemName {
            itemNameLabel.text = name
        }
        
        if let image = itemImage {
            itemImageView.image = image
        }

        // Preselect rows in picker view
        pickerView.selectRow(0, inComponent: 0, animated: false)
        pickerView.selectRow(0, inComponent: 1, animated: false)
        
        // Hide/format buttons in view
        hideSaveButton(false)
        formatButtons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - IB Actions
    
    @IBAction func addToCartPressed(sender: AnyObject) {
    }
    
    @IBAction func savePressed(sender: AnyObject) {
    }
    
    @IBAction func deletePressed(sender: AnyObject) {
    }
    
    @IBAction func editImagePressed(sender: AnyObject) {
    }
  
    @IBAction func editCategoryPressed(sender: AnyObject) {
    }
    
    @IBAction func editNamePressed(sender: AnyObject) {
    }
    
    
    // MARK: - Picker View Datasource/Delegate
    
    // numberOfComponents
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    // numberOfRowsInComponent
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (component == 0) ? 100 : 5
    }
    
    // titleForRow
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (component == 0) ? "\(row + 1)" : "unit \(row)"
    }
    
    // didSelectRow
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
        if changesMade {    // Check if changes have been reverted
            if selectedQuantity == pickerView.selectedRowInComponent(kQuantityIndex) &&
                selectedUnit == pickerView.selectedRowInComponent(kUnitIndex) {
                
                // Changes have been reverted
                changesMade = false
                hideSaveButton(true)
            }
        }
        else if component == kQuantityIndex {  // Item quantity
            if selectedQuantity != row {
                // Changes have been made
                changesMade = true
                showSaveButton()
            }
        }
        else if component == kUnitIndex {  // Unit type
            if selectedUnit != row {
                // Changes have been made
                changesMade = true
                showSaveButton()
            }
        }
        else {
            print("ERROR: Unexpected picker view component index")
        }
    }
    
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let vc = segue.destinationViewController as? InventoryViewController {
            //vc.rowChanged
        }
    }
    
    
    // MARK: - Private API
    
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
    
    private func showSaveButton() {
        // Animate save button into view
        UIView.animateWithDuration(0.1, animations: {
            self.saveChangesButton.alpha = self.kButtonActiveAlpha
            
            }, completion: { (status) in
                self.saveChangesButton.userInteractionEnabled = true
        })
    }
    
    private func hideSaveButton(animated: Bool) {
        saveChangesButton.userInteractionEnabled = false
        
        if !animated {
            saveChangesButton.alpha = kButtonInactiveAlpha
        }
        else {
            UIView.animateWithDuration(0.1, animations: {
                self.saveChangesButton.alpha = self.kButtonInactiveAlpha
            })
        }
    }

}
