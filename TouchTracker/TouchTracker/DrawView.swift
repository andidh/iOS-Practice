//
//  DrawView.swift
//  TouchTracker
//
//  Created by Dehelean Andrei on 7/18/16.
//  Copyright © 2016 Dehelean Andrei. All rights reserved.
//

import UIKit

class DrawView: UIView {

    var currentLines = [NSValue: Line]()
    var finishedLines = [Line]()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(DrawView.doubleTapHandler(_:)))
        doubleTapGesture.delaysTouchesBegan = true
        doubleTapGesture.numberOfTouchesRequired = 2
        addGestureRecognizer(doubleTapGesture)
    }
    
    func doubleTapHandler(gesture: UIGestureRecognizer) {
        
        print("recognized")
        
        currentLines.removeAll(keepCapacity: false)
        finishedLines.removeAll(keepCapacity: false)
        
        setNeedsDisplay()
        
    }
    
    func strokeLine(line: Line){
        let path = UIBezierPath()
        path.lineWidth = 10
        path.lineCapStyle = .Round
        
        path.moveToPoint(line.begin)
        path.addLineToPoint(line.end)
        path.stroke()
    }
    
    override func drawRect(rect: CGRect) {

        //draw the finished lines in black
        UIColor.blackColor().setStroke()
        for line in finishedLines {
            strokeLine(line)
        }
        
        for (_, line) in currentLines {
            //draw the current line in red
            UIColor.redColor().setStroke()
            strokeLine(line)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInView(self)
            let newLine = Line(begin: location, end: location)
            let key = NSValue(nonretainedObject: touch)
            currentLines[key] = newLine
        }
        
        setNeedsDisplay()
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
       
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            currentLines[key]?.end = touch.locationInView(self)
        }
        setNeedsDisplay()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            if var line = currentLines[key] {
                line.end = touch.locationInView(self)
                finishedLines.append(line)
                currentLines.removeValueForKey(key)
            }
        }
        setNeedsDisplay()
    }
}
