//
//  ChecklistItem.swift
//  Checklists
//
//  Created by M.I. Hollemans on 27/07/15.
//  Copyright © 2015 Razeware. All rights reserved.
//

import UIKit

class ChecklistItem: NSObject, NSCoding {
    var text = ""
    var checked = false
    var dueDate = NSDate()
    var shouldRemind = false
    var itemID: Int
    
  
    func toggleChecked() {
        checked = !checked
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(text, forKey: "Text")
        aCoder.encodeBool(checked, forKey: "Checked")
        aCoder.encodeObject(dueDate, forKey: "DueDate")
        aCoder.encodeBool(shouldRemind, forKey: "ShouldRemind")
        aCoder.encodeInteger(itemID, forKey: "ItemID")
    }
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObjectForKey("Text") as! String
        checked = aDecoder.decodeBoolForKey("Checked")
        dueDate = aDecoder.decodeObjectForKey("DueDate") as! NSDate
        shouldRemind = aDecoder.decodeBoolForKey("ShouldRemind")
        itemID = aDecoder.decodeIntegerForKey("ItemID")
        super.init()
    }
    
    override init() {
        itemID = DataModel.nextChecklistItemID()
        super.init()
    }
    
    deinit {
        if let notification = notificationForThisItem() {
            UIApplication.sharedApplication().cancelLocalNotification(notification)
        }
    }
    
    func scheduleNotification() {
        let existingNotification =  notificationForThisItem()
        if let item = existingNotification {
            UIApplication.sharedApplication().cancelLocalNotification(item)
        }
        
        if shouldRemind && dueDate.compare(NSDate()) != .OrderedAscending {
            let notification = UILocalNotification()
            notification.fireDate = dueDate
            notification.timeZone = NSTimeZone.localTimeZone()
            notification.alertBody = text
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.userInfo = ["ItemID":itemID]
            
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
            
        }
    }
    
    func notificationForThisItem() -> UILocalNotification? {
        let allNotifications = UIApplication.sharedApplication().scheduledLocalNotifications!
        for item in allNotifications {
            if let number = item.userInfo?["ItemID"] as? Int where number == itemID {
                return item
            }
        }
        return nil
    }
}
