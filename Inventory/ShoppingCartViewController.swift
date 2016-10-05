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

    var items = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "Item")
        
        //3
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            items = results
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: kItemCellID)
        
        let item = items[indexPath.row]
        cell?.textLabel?.text = item.value(forKey: "name") as? String
        return cell!
    }
    
    fileprivate func addItemToCart(_ item: NSManagedObject) {
        
        // Make changes to item entity
        item.setValue(true, forKey: "inCart")
        
        // Get managed object context
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        // Save context
        do {
            try managedContext.save()
            items.append(item)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    fileprivate func removeItemFromCart(_ item: NSManagedObject) {
        
        // Make changes to item entity
        item.setValue(false, forKey: "inCart")
        
        // Get managed object context
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        // Save context
        do {
            try managedContext.save()
            items.append(item)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
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
