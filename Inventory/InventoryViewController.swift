//
//  InventoryViewController.swift
//  Inventory
//
//  Created by Harry Nelken on 7/28/16.
//  Copyright © 2016 Da Legna. All rights reserved.
//

import UIKit

class InventoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var actions: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        actions = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let imageView = UIImageView(frame: CGRectMake(220, 10, 40, 40))
        imageView.image = UIImage(named: "books.png")
        actions.view.addSubview(imageView)
        
        let adjustAction = UIAlertAction(title: "Adjust Quantity", style: .Destructive) {(action) in
            self.performSegueWithIdentifier(kQuantitySegue, sender: self)
        }
        
        let shopCartAction = UIAlertAction(title: "Add to Shopping Cart",
                                           style: .Default,
                                           handler: {(_) in })
        let editAction = UIAlertAction(title: "Edit Item",
                                       style: .Default,
                                       handler: {(_) in })
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .Cancel,
                                         handler: {(_) in })
        actions.addAction(adjustAction)
        actions.addAction(shopCartAction)
        actions.addAction(editAction)
        actions.addAction(cancelAction)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToTable(segue: UIStoryboardSegue) {
    
    }
    
    func cellPressed() {
        // TODO: Make action sheet of options
        
        self.presentViewController(actions, animated: true) { }
        
        // Segue to quantity screen
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return kGroups.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return kGroups[section]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kInventoryCellID) as! InventoryTableCell
        
        cell.cellTitle.text = "Cell Number \(indexPath.row)"
        cell.cellImageView.image = UIImage(named: "cup.png")
        cell.cellButton.layer.cornerRadius = cell.cellButton.frame.height/2
        cell.cellButton.clipsToBounds = true
        
        cell.cellButton.addTarget(self, action: #selector(InventoryViewController.cellPressed), forControlEvents: .TouchUpInside)
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
