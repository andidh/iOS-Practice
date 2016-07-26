//
//  Firebase.swift
//  chat
//
//  Created by Andrei Dehelean on 7/21/16.
//  Copyright © 2016 Imprezzio Global. All rights reserved.
//

import Foundation
import Firebase

class DB {
    
    static var sharedInstance = DB()
    
    var ref = FIRDatabase.database().reference()
}
