//
//  AllListsController.swift
//  CheckList
//
//  Created by Dehelean Andrei on 9/6/16.
//  Copyright © 2016 Dehelean Andrei. All rights reserved.
//

import UIKit

class AllListsController: UITableViewController, ListDetailControllerDelegate, UINavigationControllerDelegate {
    
    var dataModel: DataModel!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
//        navigationController?.delegate = self
//        let index = dataModel.indexOfSelectedChecklist
//        if index >= 0 && index < dataModel.lists.count {
//            let item = dataModel.lists[index]
//            performSegueWithIdentifier("ShowChecklist", sender: item)
//        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowChecklist" {
            let checklist = sender as! Checklist
            let destinationVC = segue.destinationViewController as! ChecklistViewController
            destinationVC.checklist = checklist
        } else if segue.identifier == "ShowAddList" {
            let navController = segue.destinationViewController as! UINavigationController
            let controller = navController.topViewController as! ListDetailController
            controller.delegate = self
        }
    }

    func listDetailControllerDidCancel(controller: ListDetailController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func listDetailController(controller: ListDetailController, didFinishAddingChecklist list: Checklist) {
        dataModel.lists.append(list)
        
        dataModel.sortChecklists()
        tableView.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func listDetailController(controller: ListDetailController, didFinishEditingChecklist list: Checklist) {
        dataModel.sortChecklists()
        tableView.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
    }

}


extension AllListsController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = cellForTableView(tableView)
        let item = dataModel.lists[indexPath.row]
        cell.textLabel?.text = item.name
        let count = item.getUncheckedCount()
        if item.items.count == 0 {
            cell.detailTextLabel?.text = "(No items)"
        } else if count == 0 {
                cell.detailTextLabel?.text = "All Done"
        } else {
            cell.detailTextLabel?.text = "\(count) Remaining"
        }
    
        cell.imageView?.image = UIImage(named: item.iconName)
        cell.accessoryType = .DetailDisclosureButton
        return cell
    }
    
    private func cellForTableView(tableView: UITableView) -> UITableViewCell {
        let cellId = "CellId"
        if let cell = tableView.dequeueReusableCellWithIdentifier(cellId) {
            return cell
        } else {
            return UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        dataModel.indexOfSelectedChecklist = indexPath.row
        let checklist = dataModel.lists[indexPath.row]
        performSegueWithIdentifier("ShowChecklist", sender: checklist)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            dataModel.lists.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let navController = storyboard?.instantiateViewControllerWithIdentifier("ListDetailNavController") as! UINavigationController
        let controller = navController.topViewController as! ListDetailController
        controller.delegate = self
        controller.checklistToEdit = dataModel.lists[indexPath.row]
        presentViewController(navController, animated: true, completion: nil)
    }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if viewController == self {
            dataModel.indexOfSelectedChecklist = -1
        }
    }
}