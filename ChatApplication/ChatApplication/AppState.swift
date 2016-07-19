//
//  AppState.swift
//  ChatApplication
//
//  Created by Dehelean Andrei on 7/19/16.
//  Copyright © 2016 Dehelean Andrei. All rights reserved.
//

import UIKit

class AppState: NSObject {

    static let sharedInstance = AppState()
    
    var signedIn = false
    var displayName : String?
}
