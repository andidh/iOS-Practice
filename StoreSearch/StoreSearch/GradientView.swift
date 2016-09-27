//
//  GradientView.swift
//  StoreSearch
//
//  Created by Dehelean Andrei on 9/22/16.
//  Copyright © 2016 Dehelean Andrei. All rights reserved.
//

import UIKit

class GradientView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clearColor()
        autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        backgroundColor = UIColor.clearColor()
        autoresizingMask = [.FlexibleWidth, .FlexibleHeight]

    }
    
    override func drawRect(rect: CGRect) {
        let components: [CGFloat] = [ 0, 0, 0, 0.3, 0, 0, 0, 0.7 ]
        let locations: [CGFloat] = [ 0, 1 ]
        // 2
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2)
        // 3
        let x = CGRectGetMidX(bounds)
        let y = CGRectGetMidY(bounds)
        let point = CGPoint(x: x, y : y)
        let radius = max(x, y)
        // 4
        let context = UIGraphicsGetCurrentContext()
        CGContextDrawRadialGradient(context, gradient, point, 0, point, radius, .DrawsAfterEndLocation)
    
    }
}
