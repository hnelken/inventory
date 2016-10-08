//
//  ShoppingCartViewController.swift
//  Inventory
//
//  Created by Harry Nelken on 10/5/16.
//  Copyright © 2016 Da Legna. All rights reserved.
//

import UIKit
import CoreData

class ShoppingCartViewController: UIViewController, UITableViewDataSource {
    
    var items = [Item]()
    
    @IBOutlet weak var shoppingCart: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get managed object context
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        // Create fetch request for items in cart
        let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: kItemEntityName)
        
        //3
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            appDelegate.items = results
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        items = appDelegate.items
        shoppingCart.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - UITableView Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: kItemCellID) as? InventoryTableCell else {
            print("ERROR: Inventory table cell could not be dequeued")
            return InventoryTableCell()
        }
        
        // Get item for index path and fill cell with item info
        let item = items[indexPath.row]
        
        if let name = item.name {
            cell.cellTitle.text = "\(name)"
        }
        cell.cellNumber.text = "\(item.quantity) \(kUnits[Int(item.unitType)])"
        cell.cellImageView.image = getImage(for: indexPath)
        
        cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        
        
        return cell
    }
    
    fileprivate func removeItemFromCart(_ cartItem: NSManagedObject) {
        
        // Get managed object context
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        // Delete item from store
        managedContext.delete(cartItem)
        
        // Save context
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not remove item from cart \(error), \(error.userInfo)")
        }
    }
    
    fileprivate func getImage(for indexPath: IndexPath) -> UIImage {
        guard let placeHolderImage = UIImage(named: "cup.png") else {
            print("ERROR: Couldn't retrieve placeholder image")
            return UIImage()
        }
        return placeHolderImage
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
