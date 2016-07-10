//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by Dehelean Andrei on 7/10/16.
//  Copyright © 2016 Dehelean Andrei. All rights reserved.
//

import UIKit

class ConversionViewController : UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var celsiusLabel: UILabel!
    
    var fahrenheitValue : Double? {
        didSet{
            self.updateCelsiusLabel()
        }
    }
    var celsiusValue: Double? {
        if let value = fahrenheitValue {
            return (value - 32) * 5/9
        } else {
            return nil
        }
        
    }
    
    let numberFormatter : NSNumberFormatter = {
        let nf = NSNumberFormatter()
        nf.numberStyle = .DecimalStyle
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()
    
    func updateCelsiusLabel() {
        if let value = celsiusValue {
            celsiusLabel.text = numberFormatter.stringFromNumber(value)
        } else {
            celsiusLabel.text = "???"
        }
    }
    
    @IBAction func fahrenheitEditingChanged(sender: UITextField) {
        if let text = textField.text, value = Double(text) {
            fahrenheitValue = value
        } else {
            fahrenheitValue = nil
        }
    }
    @IBAction func dismissKeyboard(sender: AnyObject) {
        textField.resignFirstResponder()
    }
}
