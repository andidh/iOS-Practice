//
//  IconPickerDelegate.swift
//  CheckList
//
//  Created by Dehelean Andrei on 9/7/16.
//  Copyright © 2016 Dehelean Andrei. All rights reserved.
//

import UIKit

protocol IconPickerDelegate: class {
    func iconPicker(picker: IconPickerController, didPickIconWithName name: String)
}

class IconPickerController: UITableViewController {
    
    weak var delegate: IconPickerDelegate?
    
    let icons = ["No Icon", "Appointments", "Birthdays", "Chores", "Drinks", "Folder", "Groceries", "Inbox", "Photos", "Trips" ]
}

extension IconPickerController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("IconCell", forIndexPath: indexPath)
        
        let icon = icons[indexPath.row]
        cell.imageView?.image = UIImage(named: icon)
        cell.textLabel?.text = icon
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let delegate = delegate {
            let name = icons[indexPath.row]
            delegate.iconPicker(self, didPickIconWithName: name)
        }
    }
}