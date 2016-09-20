//
//  Functions.swift
//  Location App
//
//  Created by Dehelean Andrei on 9/17/16.
//  Copyright © 2016 Dehelean Andrei. All rights reserved.
//

import Foundation
import UIKit

let applicationDocumentsDirectory: String = {
    let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    return path[0]
}()