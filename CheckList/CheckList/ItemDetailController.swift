//
//  ItemDetailController.swift
//  CheckList
//
//  Created by Dehelean Andrei on 9/6/16.
//  Copyright © 2016 Dehelean Andrei. All rights reserved.
//

import UIKit

class ItemDetailController: UITableViewController, UITextFieldDelegate {
    
    var itemToEdit: ChecklistItem?
    weak var delegate: ItemDetailControllerDelegate?
    var dueDate = NSDate()
    var datePickerVisible = false
        
    @IBOutlet weak var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit {
            title = "Edit item"
            inputTextField.text = item.text
            doneButton.enabled = true
            shouldRemindSwitch.on = item.shouldRemind
            dueDate = item.dueDate
        }
        updateDateLabel()
    }
    
    func updateDateLabel() {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        dueDateLabel.text = formatter.stringFromDate(dueDate)
    }
    
    @IBAction func handleCancel(sender: AnyObject) {
        delegate?.itemDetailControllerDidCancel(self)
    }
    
    @IBAction func handleDone(sender: AnyObject) {
        if let item = self.itemToEdit {
            item.text = inputTextField.text!
            item.shouldRemind = shouldRemindSwitch.on
            item.dueDate = dueDate
            item.scheduleNotification()
            delegate?.itemDetailController(self, didFinishedEditingItem: item)
        } else {
            let text = inputTextField.text!
            let item = ChecklistItem()
            item.checked = false
            item.text = text
            item.scheduleNotification()
            item.shouldRemind = shouldRemindSwitch.on
            item.dueDate = dueDate
            delegate?.itemDetailController(self, didFinishedAddingItem: item)
        }
    }
    
    @IBAction func dateChanged(sender: AnyObject) {
        dueDate = datePicker.date
        updateDateLabel()
    }
    
    func showDatePicker() {
        datePickerVisible = true
        
        let indexOfDateRow = NSIndexPath(forRow: 1, inSection: 1)
        let indexOfPicker = NSIndexPath(forRow: 2, inSection: 1)
        
        if let cell = tableView.cellForRowAtIndexPath(indexOfDateRow) {
            cell.detailTextLabel?.textColor = cell.detailTextLabel?.tintColor
        }
        
        tableView.beginUpdates()
        
        tableView.insertRowsAtIndexPaths([indexOfPicker], withRowAnimation: .Fade)
        tableView.reloadRowsAtIndexPaths([indexOfDateRow], withRowAnimation: .None)
        
        tableView.endUpdates()
        datePicker.setDate(dueDate, animated: true)
    }
    
    func hideDatePicker() {
        if datePickerVisible {
            datePickerVisible = false
            
            let indexDateRow = NSIndexPath(forRow: 1, inSection: 1)
            let indexDatePicker = NSIndexPath(forRow: 2, inSection: 1)
            
            if let cell = tableView.cellForRowAtIndexPath(indexDateRow) {
                cell.detailTextLabel?.textColor = UIColor.darkGrayColor()
            }
            
            tableView.beginUpdates()
            tableView.reloadRowsAtIndexPaths([indexDateRow], withRowAnimation: .None)
            tableView.deleteRowsAtIndexPaths([indexDatePicker], withRowAnimation: .Fade)
            tableView.endUpdates()
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.inputTextField.becomeFirstResponder()
        
    }
    @IBAction func shouldRemindToggled(sender: AnyObject) {
        if shouldRemindSwitch.on {
            let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Sound], categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldText: NSString = self.inputTextField.text!
        let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        
        doneButton.enabled = newText.length > 0
        
        return true
    }
}


// MARK: -UITableView methods
extension ItemDetailController {
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.section == 1 && indexPath.row == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 2 {
            return datePickerCell
        } else {
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 && datePickerVisible {
            return 3
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2 {
            return 217
        } else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        inputTextField.resignFirstResponder()
        
        if indexPath.section == 1 && indexPath.row == 1 {
            if !datePickerVisible {
                showDatePicker()
            } else {
                hideDatePicker()
            }
        }
    }
    
    override func tableView(tableView: UITableView, indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
        let newIndexPath: NSIndexPath?
        if indexPath.section == 1 && indexPath.row == 2 {
            newIndexPath = NSIndexPath(forRow: 0, inSection: indexPath.section)
            return super.tableView(tableView, indentationLevelForRowAtIndexPath: newIndexPath!)
        }
        return super.tableView(tableView, indentationLevelForRowAtIndexPath: indexPath)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        hideDatePicker()
    }
}

protocol ItemDetailControllerDelegate: class {
    func itemDetailControllerDidCancel(controller: ItemDetailController)
    func itemDetailController(controller: ItemDetailController, didFinishedAddingItem item: ChecklistItem)
    func itemDetailController(controller: ItemDetailController, didFinishedEditingItem item: ChecklistItem)
}