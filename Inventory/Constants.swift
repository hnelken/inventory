//
//  Constants.swift
//  Inventory
//
//  Created by Harry Nelken on 7/28/16.
//  Copyright © 2016 Da Legna. All rights reserved.
//

import Foundation

// CORE DATA CONSTANTS


// STORYBOARD CONSTANTS
let kItemCellID = "inventoryItemCell"
let kGroupCellID = "inventoryGroupCell"

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
let kUnits = [
    "lbs", "bottles", "cases", "grams", "bags"
]

let kGroupComponent = 0
let kQuantityComponent = 0
let kUnitComponent = 1

// FILENAME CONSTANTS
let kWhitePencilImage = "penic-white"
let kYellowPencilImage = "penic-highlight"
let kWhiteStarImage = "star-white"
let kYellowStarImage = "star-yellow"
let kOpenGroupImage = "down-triangle-white"
let kClosedGroupImage = "right-triangle-white"

// CONVENIENCE
let kButtonFadeDuration = 0.35
let kDeleteButtonTitle = "Delete Item"
let kDoneButtonTitle = "Done"
let kPassword = "9999"
let kDotChar = "•"
let kFontName = "HelveticaNeue"
public extension String {
    var NS: NSString { return (self as NSString) }
}

public extension Selector {
    static let tapHandler = #selector(SelectedItemViewController.tapHandler(_:))
}
