//
//  ItemStore.swift
//  Homepwner
//
//  Created by Dehelean Andrei on 7/14/16.
//  Copyright © 2016 Dehelean Andrei. All rights reserved.
//

import UIKit

class ItemStore {

    var allItems = [Item]()
    
    let archiveURL : NSURL = {
        let documentsDirectories = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.URLByAppendingPathComponent("items.archive")
    }()
    
    init() {
        if let result = NSKeyedUnarchiver.unarchiveObjectWithFile(archiveURL.path!) as? [Item] {
            allItems += result
        }
    }
    
     func addItem(name: String, valueInDollars: Int, serialNumber: String?){
        let item = Item(name: name, serialNumber: serialNumber, valueInDollars: valueInDollars)
        allItems.append(item)
    }
    
    func removeItem(item: Item) {
        if let index = allItems.indexOf(item){
            allItems.removeAtIndex(index)
        }
    }
    
    func saveToFile() -> Bool{
        return NSKeyedArchiver.archiveRootObject(allItems, toFile: archiveURL.path!)
    }
}
