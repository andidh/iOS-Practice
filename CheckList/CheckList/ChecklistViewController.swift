//
//  ViewController.swift
//  CheckList
//
//  Created by Dehelean Andrei on 9/5/16.
//  Copyright © 2016 Dehelean Andrei. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailControllerDelegate {
    
    var checklist: Checklist!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = checklist.name
    }
    
    func configureTextForCell(cell: UITableViewCell, withChecklistItem item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    func configureCheckmarkForCell(cell: UITableViewCell, withChecklistItem item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        label.textColor = view.tintColor
        if item.checked {
            label.text = "✔︎"
        } else {
            label.text = ""
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "addNewItemSegue" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let itemDetailController = navigationController.topViewController as! ItemDetailController
            itemDetailController.delegate = self
        } else if segue.identifier == "editItemSegue" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let itemDetailController = navigationController.topViewController as! ItemDetailController
            itemDetailController.delegate = self
            
            if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
                let item = checklist.items[indexPath.row]
                itemDetailController.itemToEdit = item
            }
        }
    }
    func itemDetailControllerDidCancel(controller: ItemDetailController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
   
    func itemDetailController(controller: ItemDetailController, didFinishedAddingItem item: ChecklistItem) {
        let newIndex = checklist.items.count
        checklist.items.append(item)
        let indexPath = NSIndexPath(forRow: newIndex, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func itemDetailController(controller: ItemDetailController, didFinishedEditingItem item: ChecklistItem) {
        if let index = checklist.items.indexOf(item) {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0))
            configureTextForCell(cell!, withChecklistItem: item)
        }
        dismissViewControllerAnimated(true, completion: nil)
    
    }
    
}


// MARK: -UITableView methods
extension ChecklistViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("checklistCell", forIndexPath: indexPath)
        
        let item = checklist.items[indexPath.row]
        
        configureTextForCell(cell, withChecklistItem: item)
        configureCheckmarkForCell(cell, withChecklistItem: item)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = self.tableView.cellForRowAtIndexPath(indexPath) {
            let item = checklist.items[indexPath.row]
            item.toggleChecked()
            configureCheckmarkForCell(cell, withChecklistItem: item)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            checklist.items.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
        
    }
}