//
//  RestaurantManager.swift
//  FoodPin
//
//  Created by Dehelean Andrei on 7/14/16.
//  Copyright © 2016 Dehelean Andrei. All rights reserved.
//

import UIKit

class RestaurantManager: NSObject {

    static var restaurants = [Restaurant]()
    
    class func addRestaurant(rest: Restaurant){
        restaurants.append(rest)
    }
}
