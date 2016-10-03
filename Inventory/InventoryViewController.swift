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
    fileprivate var sectionOpen: [Int : Bool] = [:]
    fileprivate var imageCaches: [Int : [UIImage]] = [:]
    fileprivate var sectionItems: [Int : [InventoryItem]] = [:]
    
    
    // MARK: - IB Outlets
    @IBOutlet weak var inventoryTable: UITableView!
    
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0...kGroups.count - 1 {
            sectionItems[i] = [
                InventoryItem(name: "\(kGroups[i]) - Item 1", group: i, special: false),
                InventoryItem(name: "\(kGroups[i]) - Item 2", group: i, special: false),
                InventoryItem(name: "\(kGroups[i]) - Item 3", group: i, special: false),
                InventoryItem(name: "\(kGroups[i]) - Item 4", group: i, special: false),
                InventoryItem(name: "\(kGroups[i]) - Item 5", group: i, special: false)
            ]
            sectionOpen[i] = false
        }
        
        let color = UIColor(colorLiteralRed: 92/255, green: 94/255, blue: 102/255, alpha: 1)
        tabBarController?.tabBar.barTintColor = color
        tabBarController?.tabBar.tintColor = .white
    }
    
    
    // MARK: - IB Actions
    
    @IBAction func unwindToTable(_ segue: UIStoryboardSegue) {
    
    }
    
    
    // MARK: - Table View Datasource / Delegate
    
    // numberOfSections
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionItems.count
    }
    
    // numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let open = sectionOpen[section] else {
            return 1
        }
        
        if open {
            guard let items = sectionItems[section] else {
                return 1
            }
            return items.count + 1
        }
        else {
            return 1
        }
    }
    
    // titleForHeaderInSection
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
        }
        else {  // Normal item cell
            // Get item for index path and fill cell with item info
            if let item = getItem(for: indexPath) {
                cell.cellTitle.text = "\(item.name)"
                cell.cellNumber.text = "\(item.quantity) \(kUnits[item.units])"
                cell.cellImageView.image = getImage(for: indexPath)
            }
        }
        
        return cell
    }
    
    // didSelectRow
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            guard let open = sectionOpen[indexPath.section] else {
                print("ERROR: Section status not found")
                return
            }
            inventoryTable.reloadData()
            sectionOpen[indexPath.section] = !open
            if open {
                // Section is now closed
                
            }
            else {
                // Section just opened
                
            }
            let section = NSIndexSet(index: indexPath.section)
            inventoryTable.reloadSections((section as IndexSet), with: .none)
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
    
    fileprivate func getImage(for indexPath: IndexPath) -> UIImage {
        // Get image cache for section
        var sectionCache: [UIImage] = []
        if let cache = imageCaches[indexPath.section] {
            sectionCache = cache
        }
        
        // Check for image cache hit
        if sectionCache.count > indexPath.row - 1 {
            return sectionCache[indexPath.row - 1]
        }
        
        guard let placeHolderImage = UIImage(named: "cup.png") else {
            print("ERROR: Couldn't retrieve placeholder image")
            return UIImage()
        }
        
        // Otherwise use a placeholder image and attempt to download the real image
        sectionCache.append(placeHolderImage)
        imageCaches[indexPath.section] = sectionCache
        
        //
        // ADD IMAGE DOWNLOAD OPERATION TO QUEUE HERE
        //
        
        return placeHolderImage
    }
    
    fileprivate func getItem(for indexPath: IndexPath) -> InventoryItem? {
        // Safely get the item list for the index path's section
        guard let items = sectionItems[indexPath.section] else {
            print("ERROR: Data not available for index path \(indexPath)")
            return nil
        }
        
        // Ensure the index path is not out of bounds
        guard items.count > indexPath.row - 1 else {
            print("ERROR: Data not available for index path \(indexPath)")
            return nil
        }
        
        // Return the item for the index path
        return items[indexPath.row - 1]
    }
}
