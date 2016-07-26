//
//  RoundedImageView.swift
//  chat
//
//  Created by Andrei Dehelean on 7/21/16.
//  Copyright © 2016 Imprezzio Global. All rights reserved.
//

import UIKit

class RoundedImageView: UIImageView {

    override func awakeFromNib() {
        let width = self.frame.size.width
        self.layer.cornerRadius = width/2
        self.clipsToBounds = true
    }

}
