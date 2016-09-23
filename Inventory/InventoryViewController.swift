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
    fileprivate var imageCaches: [Int : [UIImage]] = [:]
    
    fileprivate var sectionItems: [Int : [InventoryItem]] = [
        :
    ]
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()

        for i in 0...kGroups.count - 1 {
            sectionItems[i] = [
                InventoryItem(name: "Item", group: i, special: false),
                InventoryItem(name: "Item", group: i, special: false),
                InventoryItem(name: "Item", group: i, special: false),
                InventoryItem(name: "Item", group: i, special: false),
                InventoryItem(name: "Item", group: i, special: false)
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
        
        guard let items = sectionItems[indexPath.section] else {
            print("ERROR: Data not available for index path \(indexPath)")
            return cell
        }
        
        guard items.count > indexPath.row else {
            print("ERROR: Data not available for index path \(indexPath)")
            return cell
        }
        
        let item = items[indexPath.row]
        cell.cellTitle.text = "\(item.name) \(indexPath.row)"
        cell.cellNumber.text = "\(item.quantity)"
        cell.cellImageView.image = getImageFromCache(indexPath: indexPath)
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    // didSelectRow
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemQuantity = 25
        itemUnit = 2
        itemGroup = (indexPath as NSIndexPath).section
        itemName = "Item Number \((indexPath as NSIndexPath).row)"
        itemImage = UIImage(named: "cup.png")
        
        performSegue(withIdentifier: kItemSelectSegue, sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? SelectedItemViewController {
            vc.initQuantity = itemQuantity
            vc.initUnit = itemUnit
            vc.initGroup = itemGroup
            vc.initName = itemName
            vc.initImage = itemImage
        }
    }

    
    // MARK: - Private API
    fileprivate func getImageFromCache(indexPath: IndexPath) -> UIImage {
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
}
