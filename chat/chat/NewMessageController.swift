//
//  NewMessageController.swift
//  chat
//
//  Created by Andrei Dehelean on 7/21/16.
//  Copyright © 2016 Imprezzio Global. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    var users = [User]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(NewMessageController.handleCancel))
        self.fetchUsers()
    }
    
    func handleCancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func fetchUsers() {
        DB.sharedInstance.ref.child("users").observeEventType(.ChildAdded, withBlock: {
            snapshot in
            if let values = snapshot.value as? [String:String] {
                let user = User()
                user.name = values[Constants.UserDBFields.name]
                user.email = values[Constants.UserDBFields.email]
                if let photoURL  = values[Constants.UserDBFields.photoURL] {
                    user.profileImage = photoURL
                }
                
                if user.name != FIRAuth.auth()?.currentUser?.displayName {
                    self.users.append(user)
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.collectionView.reloadData()})
                }
            }, withCancelBlock: nil)
    }
}


extension NewMessageController {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.CustomCell.cellID, forIndexPath: indexPath) as! newMessageCustomCell
        
        let user = users[indexPath.row]
        
        cell.nameLabel.text = user.name
        cell.emailLabel.text = user.email
        if let imageURLString = user.profileImage where user.profileImage != "" {
            let imageURL = NSURL(string: imageURLString)
            let data = NSData(contentsOfURL: imageURL!)
            let image = UIImage(data: data!)
            cell.profileImage.image = image
        }
        
        return cell
    }
    
    
    // Resize the cell so that they stretch to the whole width of the screen
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let height = CGFloat(60)
        return CGSizeMake(collectionView.bounds.size.width, height)
    }
}