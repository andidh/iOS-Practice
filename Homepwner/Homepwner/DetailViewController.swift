//
//  DetailViewController.swift
//  Homepwner
//
//  Created by Dehelean Andrei on 7/16/16.
//  Copyright © 2016 Dehelean Andrei. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var item : Item!
    var imageStore: ImageStore!

    // MARK : IBOutlets
    @IBOutlet var nameField: UITextField!
    @IBOutlet var serialField: UITextField!
    @IBOutlet var valueField: UITextField!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    
    let numberFormatter : NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    let dateFromatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .NoStyle
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
//        self.view.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(DetailViewController.dismissKeyboard)))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        nameField.text = item.name
        serialField.text = item.serialNumber
        valueField.text = numberFormatter.stringFromNumber(item.valueInDollars)
        dateLabel.text = dateFromatter.stringFromDate(item.date)
        
        let key = item.imageKey
        let image = imageStore.imageForKey(key)
        imageView.image = image
        
        navigationItem.title = "Details"

    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        item.name = nameField.text!
        item.serialNumber = serialField.text!
        if let valueText = valueField.text, value = numberFormatter.numberFromString(valueText){
            item.valueInDollars = value.integerValue
        }
    }
    
    func dismissKeyboard() {
//        view.endEditing(true)
        nameField.resignFirstResponder()
    }

    
    @IBAction func addButton(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self

        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            imagePicker.sourceType = .Camera
        } else {
            imagePicker.sourceType = .SavedPhotosAlbum
        }
        
        imagePicker.allowsEditing = false
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        imageStore.setImageForKey(image, forKey: item.imageKey)
        dismissViewControllerAnimated(true, completion: nil)
    }
}

//Handle the keyboard

extension DetailViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
