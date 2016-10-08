//
//  AppDelegate.swift
//  Inventory
//
//  Created by Harry Nelken on 7/27/16.
//  Copyright © 2016 Da Legna. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var items = [Item]()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Create fetch request for items in cart
        let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: kItemEntityName)
        
        do {
            let results =
                try managedObjectContext.fetch(fetchRequest)
            items = results
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        if items.count == 0 {
            print("Database empty")
            installDatabase()
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        //self.saveContext()
    }

    
    // MARK: - Public API
    
    func addItemToInventory(_ item: InventoryItem) {
        
        // Create cart item
        let entity = NSEntityDescription.entity(forEntityName: kItemEntityName, in: managedObjectContext)
        let newItem = Item(entity: entity!, insertInto: managedObjectContext)
        
        // Make changes to item entity
        newItem.name = item.name
        newItem.special = item.special
        newItem.group = Int32(item.group)
        newItem.quantity = Int32(item.quantity)
        newItem.unitType = Int32(item.unitType)
        newItem.imageName = item.imageName
        newItem.inCart = item.inCart
        
        // Save context
        do {
            try managedObjectContext.save()
            items.append(newItem)
        } catch let error as NSError  {
            print("Could not add item to inventory \(error), \(error.userInfo)")
        }
    }
    
    
    // MARK: - Private API
    fileprivate func installDatabase() {
        
        //----FILL "kItems" FROM SERVER HERE-----//
        /*->->-CHANGE THIS->->*/installTestData()
        //---------------------------------------//
        
        // Add entries in CoreData for each inventory item
        for i in 0...kGroups.count - 1 {
            let group = kItems[i]
            
            if group != nil || group!.count > 0 {
                for j in 0...group!.count - 1 {
                    let item = InventoryItem(name: group![j], group: i, special: false)
                    addItemToInventory(item)
                }
            }
        }
        print("Added default items to CoreData")
    }
    
    fileprivate func installTestData() {
        for i in 0...kGroups.count - 1 {
            kItems[i] = [
                "\(kGroups[i]) - Item 1",
                "\(kGroups[i]) - Item 2",
                "\(kGroups[i]) - Item 3",
                "\(kGroups[i]) - Item 4",
                "\(kGroups[i]) - Item 5"
            ]
        }
    }
    
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "uk.co.plymouthsoftware.core_data" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "InventoryModel", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("Inventory.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

}

