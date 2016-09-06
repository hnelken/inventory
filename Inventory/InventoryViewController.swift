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
    private var itemName: String?
    private var itemImage: UIImage?
    private var cellCache: [InventoryTableCell] = []
    
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
        
        //if cellCache.count < indexPath.row {
            let cell = tableView.dequeueReusableCellWithIdentifier(kInventoryCellID) as! InventoryTableCell
        
            cell.cellTitle.text = "Item Number \(indexPath.row)"
            cell.cellImageView.image = UIImage(named: "cup.png")
            cell.backgroundColor = UIColor.clearColor()
            
            //cellCache.append(cell)
            
            return cell
        //}
        //else {
            //return cellCache[indexPath.row]
        //}
    }
    
/*    // willDisplayCell
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
    } */
    
    // didSelectRow
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        itemName = "Item Number \(indexPath.row)"
        itemImage = UIImage(named: "cup.png")
        
        performSegueWithIdentifier(kItemSelectSegue, sender: self)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let vc = segue.destinationViewController as? SelectedItemViewController {
            vc.itemName = itemName
            vc.itemImage = itemImage
        }
    }

}
