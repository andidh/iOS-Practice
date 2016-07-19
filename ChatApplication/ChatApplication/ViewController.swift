//
//  ViewController.swift
//  ChatApplication
//
//  Created by Dehelean Andrei on 7/19/16.
//  Copyright © 2016 Dehelean Andrei. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    // MARK : -IBOutlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get reference of the Database
        ref = FIRDatabase.database().reference()
    }
    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        if let user = FIRAuth.auth()?.currentUser {
//            signIn(user)
//        }
//    }

    @IBAction func signUpButtonPressed(sender: AnyObject) {
        guard let email = emailField.text, password = passwordField.text else {
            return
        }
        
        FIRAuth.auth()?.createUserWithEmail(email, password: password) {
            user, error in
            if error != nil {
                print("User logged in ")
                self.login(email, password: password)
            } else {
                print("User create")
                
                // Saving the dates to DB
                guard let uid = user?.uid, username = self.usernameField.text else {
                    return
                }
                
                let userReference = self.ref.child("users").child(uid)
                let values = [Constants.UserFields.NameField: username, Constants.UserFields.EmailField: email]
                userReference.setValue(values)
                self.login(email, password: password)
            }
        }
    }
    
    func login(email: String, password: String) {
        FIRAuth.auth()?.signInWithEmail(email, password: password) {
            user, error in
            if error != nil {
                print("Error: \(error?.localizedDescription)")
            }
            self.signIn(user!)
        }

        
    }

    func signIn(user: FIRUser?) {
        AppState.sharedInstance.displayName = user?.displayName ?? user?.email
        AppState.sharedInstance.signedIn = true
        
        NSNotificationCenter.defaultCenter().postNotificationName(Constants.NotificationKeys.SignedIn, object: nil, userInfo: nil)
        performSegueWithIdentifier(Constants.Segues.signInSegue, sender: nil)
    }
}

