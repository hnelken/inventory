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
let kItemSelectSegue = "itemSelectSegue"
let kBackSegue = "backToTableSegue"

// INVENTORY CONSTANTS
let kGroups = [
    "Cheese", "Dairy", "Drinks", "Detergents/Chemicals",
    "Frozen Goods", "Meats", "Non-Perishables",
    "Nuts/Sweets", "Paper Goods", "Produce",
    "Spices/Herbs"
]

let kGroupComponent = 0
let kQuantityComponent = 0
let kUnitComponent = 1

// FILENAME CONSTANTS
let kWhiteStarImage = "star-white"
let kYellowStarImage = "star-yellow"

// CONVENIENCE
let dotChar = "•"
let password = "9999"

public extension String {
    var NS: NSString { return (self as NSString) }
}

public extension Selector {
    static let tapHandler = #selector(SelectedItemViewController.tapHandler(_:))
}