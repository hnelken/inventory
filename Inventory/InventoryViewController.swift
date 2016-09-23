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
    
    // MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()

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
        return kGroups.count
    }
    
    // numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    // titleForHeaderInSection
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return kGroups[section]
    }
    
    // cellForRow
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: kInventoryCellID) as! InventoryTableCell
        
        cell.backgroundColor = UIColor.clear
        cell.cellTitle.text = "Item Number \((indexPath as NSIndexPath).row)"
        
        // Get image cache for section
        var sectionCache: [UIImage] = []
        if let cache = imageCaches[(indexPath as NSIndexPath).section] {
            sectionCache = cache
        }
        
        // Check for image cache hit
        if sectionCache.count > (indexPath as NSIndexPath).row {
            cell.cellImageView.image = sectionCache[(indexPath as NSIndexPath).row]
        }
        else if let placeHolderImage = UIImage(named: "cup.png") {
            // Otherwise use a placeholder image and attempt to download the real image
            sectionCache.append(placeHolderImage)
            cell.cellImageView.image = placeHolderImage
            imageCaches[(indexPath as NSIndexPath).section] = sectionCache
            
            //
            // ADD IMAGE DOWNLOAD OPERATION TO QUEUE HERE
            //
        }
        
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

}
