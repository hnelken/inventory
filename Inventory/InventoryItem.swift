//
//  InventoryItem.swift
//  Inventory
//
//  Created by Harry Nelken on 9/23/16.
//  Copyright © 2016 Da Legna. All rights reserved.
//

import Foundation

class InventoryItem {
    
    var name: String
    var group: Int
    var special: Bool
    
    var imageName: String = "cup.png"
    var unitType: Int = 2
    var quantity: Int = 25
    var lowThresh: Int = 5
    var highThresh: Int = 25
    var inCart: Bool = false
    var indexPath: IndexPath?
    
    init(name: String, group: Int, special: Bool) {
        self.name = name
        self.group = group
        self.special = special
    }
}
