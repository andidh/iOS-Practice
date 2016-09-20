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
        
        let selectionView = UIView(frame: CGRect.zero)
        selectionView.backgroundColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 0.5)
        selectedBackgroundView = selectionView
    }

}
