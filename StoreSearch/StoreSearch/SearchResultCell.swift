//
//  SearchResultCell.swift
//  StoreSearch
//
//  Created by Dehelean Andrei on 9/20/16.
//  Copyright © 2016 Dehelean Andrei. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var artworkImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
