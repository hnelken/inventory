//
//  Constants.swift
//  Inventory
//
//  Created by Harry Nelken on 7/28/16.
//  Copyright © 2016 Da Legna. All rights reserved.
//

import Foundation


// STORYBOARD CONSTANTS
let kInventoryCellID = "inventoryCell"

let kPasswordSegue = "passwordSegue"
let kQuantitySegue = "quantitySegue"
let kBackSegue = "backToTable"

// INVENTORY CONSTANTS
let kGroups = [
    "Drinks", "Produce", "Dairy", "Frozen Goods",
    "Paper Goods", "Detergents/Chemicals", "Nuts/Sweets",
    "Cheese", "Meats", "Non-Perishables", "Spices/Herbs"
]

// CONVENIENCE
let dotChar = "•"
let password = "1376"
public extension String {
    var NS: NSString { return (self as NSString) }
}