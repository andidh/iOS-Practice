//
//  MyTabBarController.swift
//  Location App
//
//  Created by Dehelean Andrei on 9/19/16.
//  Copyright © 2016 Dehelean Andrei. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController {
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func childViewControllerForStatusBarStyle() -> UIViewController? {
        return nil
    }
}
