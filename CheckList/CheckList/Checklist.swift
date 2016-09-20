//
//  Checklist.swift
//  CheckList
//
//  Created by Dehelean Andrei on 9/6/16.
//  Copyright © 2016 Dehelean Andrei. All rights reserved.
//

import UIKit

class Checklist: NSObject, NSCoding {
    var name: String
    var items = [ChecklistItem]()
    var iconName: String
    
    init(name: String, icon: String) {
        self.name = name
        self.iconName = icon
        super.init()
    }
    
    convenience init(name: String) {
        self.init(name: name, icon: "No Icon")
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("Name") as! String
        items = aDecoder.decodeObjectForKey("Items") as! [ChecklistItem]
        iconName = aDecoder.decodeObjectForKey("IconName") as! String
        super.init()

    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "Name")
        aCoder.encodeObject(items, forKey: "Items")
        aCoder.encodeObject(iconName, forKey: "IconName")
    }
    
    func getUncheckedCount() -> Int {
        var count = 0
        for item in items where !item.checked {
            count += 1
        }
        return count
    }
    
    
    
    
}
