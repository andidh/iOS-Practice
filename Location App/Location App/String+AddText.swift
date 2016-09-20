//
//  String+AddText.swift
//  Location App
//
//  Created by Dehelean Andrei on 9/19/16.
//  Copyright © 2016 Dehelean Andrei. All rights reserved.
//

import Foundation


extension String {
    mutating func addText(text: String?, withSeparator separator: String = "") {
        if let text = text {
            if !isEmpty {
                self += separator
            }
            self += text
        }
    }
}