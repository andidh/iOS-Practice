//
//  Restaurant.swift
//  FoodPin
//
//  Created by Dehelean Andrei on 7/14/16.
//  Copyright © 2016 Dehelean Andrei. All rights reserved.
//

import UIKit

class Restaurant: NSObject {
    
    var name:String
    var location:String
    var type:String
    var image: UIImage
    
    init(name:String, location:String, type:String, image:UIImage){
        self.name = name
        self.location = location
        self.type = type
        self.image = image
    }
    
}
