//
//  ProfileController.swift
//  chat
//
//  Created by Andrei Dehelean on 7/21/16.
//  Copyright © 2016 Imprezzio Global. All rights reserved.
//

import UIKit
import Firebase

class ProfileController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: RoundedImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(ProfileController.handleCancel))
        fetchCurrentUser()
        self.profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ProfileController.changeProfileImage)))
        self.profileImage.userInteractionEnabled = true
    }
    
    func handleCancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func changeProfileImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalPhoto = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalPhoto
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImage.image = selectedImage
            updateProfileURL(selectedImage)
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
 
    
    func updateProfileURL(image: UIImage) {
        let storageRef = FIRStorage.storage().reference().child("profile-images").child("\(emailField.text!)" + ".jpg")
        let data = UIImageJPEGRepresentation(image, 0.5)
        storageRef.putData(data!, metadata: nil) {
            metadata, error in
            if error != nil {
                print(error)
                return
            }
            let downloadURL = metadata!.downloadURL()?.absoluteString
            
            //Update DB with the new photoURL
            let uid = (FIRAuth.auth()?.currentUser?.uid)!
            let photoRef = DB.sharedInstance.ref.child("users").child(uid)
            let newValue = [Constants.UserDBFields.photoURL:downloadURL!]
            photoRef.updateChildValues(newValue)
        }
        
    }
    
    func fetchCurrentUser() {
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        DB.sharedInstance.ref.child("users").child(uid!).observeSingleEventOfType(.Value, withBlock: {
            snapshot in
            let dictionary = snapshot.value as! [String:String]
            self.nameField.text = dictionary[Constants.UserDBFields.name]
            self.emailField.text = dictionary[Constants.UserDBFields.email]
            if let imageURLString = dictionary[Constants.UserDBFields.photoURL] where dictionary[Constants.UserDBFields.photoURL] != "" {
                let imageURL = NSURL(string: imageURLString)
                let data = NSData(contentsOfURL: imageURL!)
                let image = UIImage(data: data!)
                self.profileImage.image = image
            } else {
                self.profileImage.image = UIImage(named: "contact")
            }
        })
        
    }
    @IBAction func logoutButtonPressed(sender: AnyObject) {
        do {
            try FIRAuth.auth()?.signOut()
            let vc = storyboard?.instantiateViewControllerWithIdentifier("loginController") as! LoginController
            presentViewController(vc, animated: true, completion: nil)
        } catch {
            print("error")
        }
    }


}
