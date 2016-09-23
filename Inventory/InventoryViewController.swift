//
//  InventoryViewController.swift
//  Inventory
//
//  Created by Harry Nelken on 7/28/16.
//  Copyright © 2016 Da Legna. All rights reserved.
//

import UIKit

class InventoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Private Variables
    fileprivate var itemQuantity: Int?
    fileprivate var itemUnit: Int?
    fileprivate var itemGroup: Int?
    fileprivate var itemName: String?
    fileprivate var itemImage: UIImage?
    fileprivate var selectedIndex: IndexPath = IndexPath(row: 0, section: 0)
    fileprivate var imageCaches: [Int : [UIImage]] = [:]
    fileprivate var sectionItems: [Int : [InventoryItem]] = [
        :
    ]
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()

        for i in 0...kGroups.count - 1 {
            sectionItems[i] = [
                InventoryItem(name: "\(kGroups[i])-Item 1", group: i, special: false),
                InventoryItem(name: "\(kGroups[i])-Item 2", group: i, special: false),
                InventoryItem(name: "\(kGroups[i])-Item 3", group: i, special: false),
                InventoryItem(name: "\(kGroups[i])-Item 4", group: i, special: false),
                InventoryItem(name: "\(kGroups[i])-Item 5", group: i, special: false)
            ]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        guard let items = sectionItems[section] else {
            return 0
        }
        return items.count
    }
    
    // titleForHeaderInSection
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return kGroups[section]
    }
    
    // cellForRow
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: kInventoryCellID) as? InventoryTableCell else {
            print("ERROR: Inventory table cell could not be dequeued")
            return InventoryTableCell()
        }
        
        // Get item for index path and fill cell with item info
        if let item = getItem(for: indexPath) {
            cell.cellTitle.text = "\(item.name)"
            cell.cellNumber.text = "\(item.quantity)"
            cell.cellImageView.image = getImage(for: indexPath)
        }
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    // didSelectRow
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Save selected index and perform segue
        selectedIndex = indexPath
        performSegue(withIdentifier: kItemSelectSegue, sender: self)
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
    
    fileprivate func getImage(for indexPath: IndexPath) -> UIImage {
        // Get image cache for section
        var sectionCache: [UIImage] = []
        if let cache = imageCaches[indexPath.section] {
            sectionCache = cache
        }
        
        // Check for image cache hit
        if sectionCache.count > indexPath.row {
            return sectionCache[indexPath.row]
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
        guard items.count > indexPath.row else {
            print("ERROR: Data not available for index path \(indexPath)")
            return nil
        }
        
        // Return the item for the index path
        return items[indexPath.row]
    }
}
