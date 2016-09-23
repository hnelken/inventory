//
//  InventoryItem.swift
//  Inventory
//
//  Created by Harry Nelken on 9/23/16.
//  Copyright © 2016 Da Legna. All rights reserved.
//

import Foundation

class InventoryItem {
    
    var imageName: String = "cup.png"
    var name: String = "Item name"
    var group: Int = 0
    var units: Int = 2
    var quantity: Int = 25
    var special: Bool = false
    var indexPath: IndexPath?
    
    init(name: String, group: Int, special: Bool) {
        self.name = name
        self.group = group
        self.special = special
    }
}
