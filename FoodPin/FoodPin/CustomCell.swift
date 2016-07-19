//
//  CustomCellTableViewCell.swift
//  FoodPin
//
//  Created by Dehelean Andrei on 7/14/16.
//  Copyright © 2016 Dehelean Andrei. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    var restaurant:Restaurant! {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var imageField: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateUI() {
        imageField.image = restaurant.image
        nameLabel.text = restaurant.name
        locationLabel.text = restaurant.location
        typeLabel.text = restaurant.type
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
