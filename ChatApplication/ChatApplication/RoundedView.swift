//
//  RoundedView.swift
//  ChatApplication
//
//  Created by Dehelean Andrei on 7/19/16.
//  Copyright © 2016 Dehelean Andrei. All rights reserved.
//

import UIKit

class RoundedView: UIView {
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
    
}
