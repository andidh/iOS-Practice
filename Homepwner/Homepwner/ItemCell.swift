//
//  ItemCell.swift
//  Homepwner
//
//  Created by Dehelean Andrei on 7/15/16.
//  Copyright © 2016 Dehelean Andrei. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    var item: Item! {
        didSet {
            updateUI()
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var serialLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    private func updateUI() {
        nameLabel.text = item.name
        serialLabel.text = item.serialNumber
        valueLabel.text = "$\(item.valueInDollars)"
    }

    func updateLabels() {
        let body = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        nameLabel.font = body
        valueLabel.font = body
        
        let caption1 = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        serialLabel.font = caption1
    }
}
