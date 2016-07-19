//
//  RoundedButton.swift
//  ChatApplication
//
//  Created by Dehelean Andrei on 7/19/16.
//  Copyright © 2016 Dehelean Andrei. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {

    override func awakeFromNib() {
        self.layer.cornerRadius = 25 
        self.clipsToBounds = true
    }

}
