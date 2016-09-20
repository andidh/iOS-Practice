//
//  DataModel.swift
//  CheckList
//
//  Created by Dehelean Andrei on 9/7/16.
//  Copyright © 2016 Dehelean Andrei. All rights reserved.
//

import Foundation


class DataModel {
    var lists = [Checklist]()
 
    var indexOfSelectedChecklist: Int {
        get {
            return NSUserDefaults.standardUserDefaults().integerForKey("ChecklistIndex")
        }
        set {
            NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: "ChecklistIndex")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    init() {
        loadData()
        registerDefaults()
        handleFirstTime()
    }
    
    // MARK :- saving data
    
    func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        return paths[0]
    }
    
    func dataFilePath() -> String {
        return (documentsDirectory() as NSString).stringByAppendingString("Checklists.plist")
    }
    
    func saveData() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(lists, forKey: "Checklists")
        archiver.finishEncoding()
        data.writeToFile(dataFilePath(), atomically: true)
    }
    
    func loadData() {
        let path = dataFilePath()
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            if let data = NSData(contentsOfFile: path) {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                self.lists = unarchiver.decodeObjectForKey("Checklists") as! [Checklist]
                unarchiver.finishDecoding()
                sortChecklists()
                
            }
        }
    }
    
    func registerDefaults() {
        let value = ["ChecklistIndex":-1, "FirstTime":true, "ChecklistItemID":0]
        NSUserDefaults.standardUserDefaults().registerDefaults(value)
    }
    
    func handleFirstTime() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let firstTime = defaults.boolForKey("FirstTime")
        if firstTime {
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            indexOfSelectedChecklist = 0
            defaults.setBool(false, forKey: "FirstTime")
            defaults.synchronize()
        }
    }
    
    func sortChecklists() {
        lists.sortInPlace { (item1, item2) -> Bool in
            return item1.name.localizedStandardCompare(item2.name) == .OrderedAscending
        }
    }
    
    
    class func nextChecklistItemID() -> Int {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let itemID = userDefaults.integerForKey("ChecklistItemID")
        userDefaults.setInteger(itemID + 1, forKey: "ChecklistItemID")
        userDefaults.synchronize()
        return itemID
    }
    
}