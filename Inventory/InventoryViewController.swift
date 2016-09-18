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
    private var itemQuantity: Int?
    private var itemUnit: Int?
    private var itemGroup: Int?
    private var itemName: String?
    private var itemImage: UIImage?
    private var imageCaches: [Int : [UIImage]] = [:]
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - IB Actions
    
    @IBAction func unwindToTable(segue: UIStoryboardSegue) {
    
    }
    
    
    // MARK: - Table View Datasource / Delegate
    
    // numberOfSections
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return kGroups.count
    }
    
    // numberOfRowsInSection
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    // titleForHeaderInSection
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return kGroups[section]
    }
    
    // cellForRow
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(kInventoryCellID) as! InventoryTableCell
        
        cell.backgroundColor = UIColor.clearColor()
        cell.cellTitle.text = "Item Number \(indexPath.row)"
        
        // Get image cache for section
        var sectionCache: [UIImage] = []
        if let cache = imageCaches[indexPath.section] {
            sectionCache = cache
        }
        
        // Check for image cache hit
        if sectionCache.count > indexPath.row {
            cell.cellImageView.image = sectionCache[indexPath.row]
        }
        else if let placeHolderImage = UIImage(named: "cup.png") {
            // Otherwise use a placeholder image and attempt to download the real image
            sectionCache.append(placeHolderImage)
            cell.cellImageView.image = placeHolderImage
            imageCaches[indexPath.section] = sectionCache
            
            //
            // ADD IMAGE DOWNLOAD OPERATION TO QUEUE HERE
            //
        }
        
        return cell
    }
    
    // didSelectRow
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        itemQuantity = 25
        itemUnit = 2
        itemGroup = indexPath.section
        itemName = "Item Number \(indexPath.row)"
        itemImage = UIImage(named: "cup.png")
        
        performSegueWithIdentifier(kItemSelectSegue, sender: self)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let vc = segue.destinationViewController as? SelectedItemViewController {
            vc.initQuantity = itemQuantity
            vc.initUnit = itemUnit
            vc.initGroup = itemGroup
            vc.initName = itemName
            vc.initImage = itemImage
        }
    }

}
