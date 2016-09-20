//
//  ListDetailController.swift
//  CheckList
//
//  Created by Dehelean Andrei on 9/6/16.
//  Copyright © 2016 Dehelean Andrei. All rights reserved.
//

import UIKit

protocol ListDetailControllerDelegate: class {
    func listDetailControllerDidCancel(controller: ListDetailController)
    func listDetailController(controller: ListDetailController, didFinishAddingChecklist list: Checklist)
    func listDetailController(controller: ListDetailController, didFinishEditingChecklist list: Checklist)
}

class ListDetailController: UITableViewController, UITextFieldDelegate, IconPickerDelegate {
    
    weak var delegate: ListDetailControllerDelegate?
    var checklistToEdit: Checklist?
    var iconName = "No Icon"
    
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = checklistToEdit {
            title = "Edit checklist"
            inputTextField.text = item.name
            doneButton.enabled = true
            iconName = item.iconName
        }
        iconImageView.image = UIImage(named: iconName)
        inputTextField.becomeFirstResponder()
    }
        
    @IBAction func handleDone(sender: AnyObject) {
        if let checklist = checklistToEdit {
            checklist.name = inputTextField.text!
            checklist.iconName = iconName
            delegate?.listDetailController(self, didFinishEditingChecklist: checklist)
        } else {
            let name = inputTextField.text
            let checklist = Checklist(name: name!, icon: iconName)
            delegate?.listDetailController(self, didFinishAddingChecklist: checklist)
        }
    }
    
    @IBAction func handleCancel(sender: AnyObject) {
        delegate?.listDetailControllerDidCancel(self)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldText = inputTextField.text! as NSString
        let newText = oldText.stringByReplacingCharactersInRange(range, withString: string) as NSString
        
        doneButton.enabled = newText.length > 0
        
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PickIcon" {
            let controller = segue.destinationViewController as! IconPickerController
            controller.delegate = self
        }
    }
    
    func iconPicker(picker: IconPickerController, didPickIconWithName name: String) {
        self.iconName = name
        iconImageView.image = UIImage(named: name)
        navigationController?.popViewControllerAnimated(true)
    }
}


extension ListDetailController {
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.section == 1 {
            return indexPath
        } else {
            return nil
        }
        
    }
}
