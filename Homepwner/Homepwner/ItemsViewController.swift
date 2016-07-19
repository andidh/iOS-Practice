//
//  ViewController.swift
//  Homepwner
//
//  Created by Dehelean Andrei on 7/14/16.
//  Copyright © 2016 Dehelean Andrei. All rights reserved.
//

import UIKit

class ItemsViewController : UITableViewController {

    var itemStore: ItemStore!
    var imageStore: ImageStore!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        navigationItem.leftBarButtonItem = editButtonItem()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    @IBAction func addNewItem(sender: AnyObject) {
        
        itemStore.addItem("New object", valueInDollars: 99, serialNumber: "xckjdks")
    
        let index = itemStore.allItems.count - 1
        let indexPath = NSIndexPath(forRow: index, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let item = itemStore.allItems[indexPath.row]
            let title = "Delete \(item.name)"
            let message = "Are you sure you want to delete it?"
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
            ac.addAction(UIAlertAction(title: "cancel", style: .Cancel, handler: nil))
            let action = UIAlertAction(title: "Delete", style: .Destructive, handler: {
                (action) -> Void in
                self.itemStore.removeItem(item)
                self.imageStore.deleteImageForKey(item.imageKey)
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            })
            ac.addAction(action)
            presentViewController(ac, animated: true, completion: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let index = tableView.indexPathForSelectedRow?.row {
                let item = itemStore.allItems[index]
                let detailView = segue.destinationViewController as! DetailViewController
                detailView.item = item
                detailView.imageStore = imageStore
            }}
    }
}


extension ItemsViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("itemCell", forIndexPath: indexPath) as! ItemCell
        
        cell.updateLabels()
        let item = itemStore.allItems[indexPath.row]
        cell.item = item
        
        return cell
    }

}