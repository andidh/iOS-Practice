//
//  ImageResize.swift
//  Location App
//
//  Created by Dehelean Andrei on 9/18/16.
//  Copyright © 2016 Dehelean Andrei. All rights reserved.
//

import Foundation
import UIKit


extension UIImage {
    func resizeimageWithBounds(bounds: CGSize) -> UIImage {
        let horizontalRatio = bounds.width / self.size.width
        let verticalRatio = bounds.height / self.size.height
        let ratio = min(horizontalRatio, verticalRatio)
        
        let newSize = CGSize(width: self.size.width * ratio, height: self.size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        drawInRect(CGRect(origin: CGPoint.zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}