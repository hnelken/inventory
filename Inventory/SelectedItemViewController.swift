//
//  SelectedItemViewController.swift
//  Inventory
//
//  Created by Harry Nelken on 9/6/16.
//  Copyright © 2016 Da Legna. All rights reserved.
//

import UIKit

class SelectedItemViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    private var selectedQuantity = 0
    private var selectedUnit = 0
    private var changesMade = false
    
    @IBOutlet weak var itemLabel: ShadowLabel!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var editImageButton: UIButton!
    @IBOutlet weak var editLabelButton: UIButton!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var deleteItemButton: UIButton!
    @IBOutlet weak var saveChangesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        formatButtons()
        hideSaveButton(false)
        pickerView.selectRow(0, inComponent: 0, animated: false)
        pickerView.selectRow(0, inComponent: 1, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Private API
    
    private func formatButtons() {
        editImageButton.layer.cornerRadius = editImageButton.frame.height / 2
        addToCartButton.layer.cornerRadius = addToCartButton.frame.height / 2
        deleteItemButton.layer.cornerRadius = deleteItemButton.frame.height / 2
        saveChangesButton.layer.cornerRadius = saveChangesButton.frame.height / 2
        
        editImageButton.clipsToBounds = true
        addToCartButton.clipsToBounds = true
        deleteItemButton.clipsToBounds = true
        saveChangesButton.clipsToBounds = true
    }
    
    private func showSaveButton() {
        UIView.animateWithDuration(0.2, animations: {
            self.saveChangesButton.alpha = 0.8
        
            }, completion: { (status) in
                self.saveChangesButton.userInteractionEnabled = true
        })
    }
    
    private func hideSaveButton(animated: Bool) {
        saveChangesButton.userInteractionEnabled = false
        
        if !animated {
            saveChangesButton.alpha = 0.2
        }
        else {
            UIView.animateWithDuration(0.2, animations: {
                self.saveChangesButton.alpha = 0.2
            })
        }
    }
    

    // MARK: - IBActions
    
    @IBAction func addToCartPressed(sender: AnyObject) {
    }
    
    @IBAction func savePressed(sender: AnyObject) {
    }
    
    @IBAction func deletePressed(sender: AnyObject) {
    }
    
    @IBAction func editImagePressed(sender: AnyObject) {
    }
    
    @IBAction func editLabelPressed(sender: AnyObject) {
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let vc = segue.destinationViewController as? InventoryViewController {
            //vc.rowChanged
        }
    }

}
