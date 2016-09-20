//
//  ViewController.swift
//  chat
//
//  Created by Andrei Dehelean on 7/21/16.
//  Copyright © 2016 Imprezzio Global. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginController: UIViewController, GIDSignInUIDelegate {

    private var dbRef:FIRDatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance().uiDelegate = self
//        GIDSignIn.sharedInstance().delegate = self
        
        GIDSignIn.sharedInstance().signInSilently()

    }

    
//    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
//        if let error = error {
//            print(error.localizedDescription)
//            return
//        }
//        
//        let authentication = user.authentication
//        let credential = FIRGoogleAuthProvider.credentialWithIDToken(authentication.idToken,
//                                                                     accessToken: authentication.accessToken)
//        
//        FIRAuth.auth()?.signInWithCredential(credential, completion: {
//            user, error in
//            if error != nil {
//                print("There is error")
//                return
//            }
//            print("User is logged in")
//            self.performSegueWithIdentifier(Constants.Segues.loginToMainScreenSegue, sender: nil)
//
//            // Check if the user is new, if so, create new user in DB
//            if FIRAuth.auth()?.currentUser == nil {
//                guard let uid = user?.uid else  { return }
//                let userRef = self.dbRef?.child("users").child(uid)
//                var values: [String: String]?
//                if let image = user?.photoURL {
//                    values = [Constants.UserDBFields.name: (user?.displayName)!, Constants.UserDBFields.email : (user?.email)!, Constants.UserDBFields.photoURL : image.absoluteString ]
//                } else {
//                    values = [Constants.UserDBFields.name: (user?.displayName)!, Constants.UserDBFields.email : (user?.email)!, Constants.UserDBFields.photoURL : ""]
//                }
//                userRef?.setValue(values)
//            }
//        })
//    }
//    
//    
//    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: NSError!) {
//        if error != nil {
//            print(error.localizedDescription)
//        }
//        try! FIRAuth.auth()?.signOut()
//    }

}

