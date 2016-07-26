//
//  MainScreenController.swift
//  chat
//
//  Created by Andrei Dehelean on 7/21/16.
//  Copyright © 2016 Imprezzio Global. All rights reserved.
//

import UIKit

class MainScreenController: UIViewController, UICollectionViewDelegate,  UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.alwaysBounceVertical = true
        navigationItem.leftBarButtonItem  = UIBarButtonItem(title: "My profile", style: .Plain, target: self, action: #selector(MainScreenController.handleProfile))
        
    }
    
    
    func handleProfile() {
        let profileController = self.storyboard?.instantiateViewControllerWithIdentifier("profileController") as! ProfileController
        presentViewController(UINavigationController(rootViewController: profileController), animated: true, completion: nil)
    }
    @IBAction func composeHandler(sender: AnyObject) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("newMessageController") as! NewMessageController
        self.presentViewController(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let vc = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


// MARK : - Collection View Data Source
extension MainScreenController {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.CustomCell.cellID, forIndexPath: indexPath) as! CustomCell
        
        cell.profileImageView.image  = UIImage(named: "contact")
        cell.nameLabel.text = "Andi"
        cell.messageLabel.text = "Hello there!"
        cell.timeLabel.text = "Today"
        
        return cell
    }
    
    
    // Resize the cell so that they stretch to the whole width of the screen
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let height = CGFloat(60)
        return CGSizeMake(collectionView.bounds.size.width, height)
    }
}