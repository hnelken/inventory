//
//  InventoryViewController.swift
//  Inventory
//
//  Created by Harry Nelken on 7/28/16.
//  Copyright © 2016 Da Legna. All rights reserved.
//

import UIKit

class InventoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Private Variables
    fileprivate var itemQuantity: Int?
    fileprivate var itemUnit: Int?
    fileprivate var itemGroup: Int?
    fileprivate var itemName: String?
    fileprivate var itemImage: UIImage?
    fileprivate var selectedIndex: IndexPath = IndexPath(row: 0, section: 0)
    fileprivate var groups: [Int: [String: Any]] = [:]
    fileprivate var groupOpen: [Bool] = [Bool]()
    fileprivate var firstTime: Bool = true
    
    // MARK: - IB Outlets
    @IBOutlet weak var inventoryTable: UITableView!
    
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Style the tab bar
        let color = UIColor(colorLiteralRed: 92/255, green: 94/255, blue: 102/255, alpha: 1)
        tabBarController?.tabBar.barTintColor = color
        tabBarController?.tabBar.tintColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshInventory()
    }
    
    
    // MARK: - IB Actions
    
    @IBAction func unwindToTable(_ segue: UIStoryboardSegue) {
    
    }
    
    
    // MARK: - Table View Datasource / Delegate
    
    // numberOfSections
    func numberOfSections(in tableView: UITableView) -> Int {
        return groups.count
    }
    
    // numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        // Check if section is open
        if getOpenStatus(for: section) {
            // Open sections show all items and a header
            return getItems(in: section).count + 1
        }
        else {
            // Closed sections show only the header
            return 1
        }
    }
    
    // heightForRow
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 50
        }
        else {
            return 91
        }
    }
    
    // cellForRow
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = getCell(for: indexPath)
        
        if indexPath.row == 0 {
            // Section cell
            cell.cellTitle.text = kGroups[indexPath.section]
            cell.backgroundColor = UIColor.clear
        
            if getOpenStatus(for: indexPath.section) {
                cell.arrowView.image = UIImage(named: kOpenGroupImage)
            }
            else {
                cell.arrowView.image = UIImage(named: kClosedGroupImage)
            }
        }
        else {  // Normal item cell
            // Get item for index path and fill cell with item info
            if let item = getItem(for: indexPath) {
                cell.cellTitle.text = "\(item.name!)"
                cell.cellNumber.text = "\(item.quantity) \(kUnits[Int(item.unitType)])"
                cell.cellImageView.image = getImage(for: indexPath)
            }
            if indexPath.row != getItems(in: indexPath.section).count - 1 {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            }
        }
        
        return cell
    }
    
    // didSelectRow
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            toggleOpenStatus(for: indexPath.section)
        }
        else {
            // Save selected index and perform segue
            selectedIndex = indexPath
            performSegue(withIdentifier: kItemSelectSegue, sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? SelectedItemViewController {
            
            // Get item info and image to pass to detail view
            vc.initImage = getImage(for: selectedIndex)
            if let item = getItem(for: selectedIndex) {
                vc.initItem = item
            }
        }
    }

    
    // MARK: - Private API
    
    // Refreshes the inventory data source
    fileprivate func refreshInventory() {
        for group in 0...kGroups.count - 1 {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            groups[group] = [
                kGroupImagesKey : [UIImage](),
                kGroupItemsKey : appDelegate.getItems(in: group)
            ]
            
            if firstTime {
                groupOpen.append(false)
            }
        }
        
        if !firstTime {
            inventoryTable.reloadData()
        }
        else {
            firstTime = false
        }
    }
    
    // Returns whether the given group list has dropped down or not
    fileprivate func getOpenStatus(for group: Int) -> Bool {
        if groupOpen.count > group {
            return groupOpen[group]
        }
        return false
    }
    
    // Toggles a group drop down list
    fileprivate func toggleOpenStatus(for group: Int) {
        if groupOpen.count > group {
            inventoryTable.reloadData()
            groupOpen[group] = !groupOpen[group]
            let section = NSIndexSet(index: group)
            inventoryTable.reloadSections((section as IndexSet), with: .none)
        }
    }
    
    // Returns the image cache for the given group
    fileprivate func getImageCache(for group: Int) -> [UIImage] {
        if let groupDict = groups[group] {
            if let cache = groupDict[kGroupImagesKey] as? [UIImage] {
                return cache
            }
        }
        return [UIImage]()
    }
    
    // Appends a new image to the cache for the given group
    fileprivate func addImageToCache(for group: Int, image: UIImage) {
        if var groupDict = groups[group] {
            if var cache = groupDict[kGroupImagesKey] as? [UIImage] {
                // Otherwise use a placeholder image and attempt to download the real image
                cache.append(image)
                groupDict[kGroupImagesKey] = cache
            }
        }
    }
    
    // Returns the items belonging to the given group
    fileprivate func getItems(in group: Int) -> [Item] {
        if let groupDict = groups[group] {
            if let items = groupDict[kGroupItemsKey] as? [Item] {
                return items
            }
        }
        return [Item]()
    }
    
    // Returns the cell with the correct identifier based on the given index path
    fileprivate func getCell(for indexPath: IndexPath) -> InventoryTableCell {
        
        let cellID: String
        if indexPath.row == 0 {
            cellID = kGroupCellID
        }
        else {
            cellID = kItemCellID
        }
        
        guard let cell = inventoryTable.dequeueReusableCell(withIdentifier: cellID) as? InventoryTableCell else {
            print("ERROR: Inventory table cell could not be dequeued")
            return InventoryTableCell()
        }
        return cell
    }
    
    // Returns the image for the item at the given index path
    fileprivate func getImage(for indexPath: IndexPath) -> UIImage {
        
        // Get image cache for section
        var cache: [UIImage] = getImageCache(for: indexPath.section)
        if cache.count > indexPath.row - 1 {
            return cache[indexPath.row - 1]
        }
        
        // Cache missed, try to get placeholder image while downloading
        
        //
        // ADD IMAGE DOWNLOAD OPERATION TO QUEUE HERE
        //
        
        guard let placeHolderImage = UIImage(named: "cup.png") else {
            print("ERROR: Couldn't retrieve placeholder image")
            return UIImage()
        }
        addImageToCache(for: indexPath.section, image: placeHolderImage)
        
        return placeHolderImage
    }
    
    // Returns the item object from the given index path
    fileprivate func getItem(for indexPath: IndexPath) -> Item? {
        
        // Get the items from the same group
        let items = getItems(in: indexPath.section)
        
        // Ensure the index path is not out of bounds
        if items.count > indexPath.row - 1 {
            // Return the item for the index path
            return items[indexPath.row - 1]
        }
        else {
            print("ERROR: Data not available for index path \(indexPath)")
            return nil
        }
    }
}
