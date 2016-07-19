//
//  Item.swift
//  Homepwner
//
//  Created by Dehelean Andrei on 7/14/16.
//  Copyright © 2016 Dehelean Andrei. All rights reserved.
//

import UIKit

class Item: NSObject, NSCoding {

    var name: String
    var valueInDollars: Int
    var serialNumber: String?
    var date: NSDate
    var imageKey: String
    
    init(name: String, serialNumber: String?, valueInDollars: Int){
        self.name = name
        self.serialNumber = serialNumber
        self.valueInDollars = valueInDollars
        self.date = NSDate()
        self.imageKey = NSUUID().UUIDString
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("name") as! String
        valueInDollars = aDecoder.decodeIntegerForKey("value")
        serialNumber = aDecoder.decodeObjectForKey("serial") as! String?
        date = aDecoder.decodeObjectForKey("date") as! NSDate
        imageKey = aDecoder.decodeObjectForKey("imageKey") as! String
        
        super.init()
    }
    
    
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(serialNumber, forKey: "serial")
        aCoder.encodeObject(date, forKey: "date")
        aCoder.encodeObject(imageKey, forKey: "imageKey")
        aCoder.encodeInteger(valueInDollars, forKey: "value")
    }
}
