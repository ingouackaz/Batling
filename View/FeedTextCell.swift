//
//  FeedTextCell.swift
//  Batling
//
//  Created by Ingouackaz on 2015-05-30.
//  Copyright (c) 2015 Ingouackaz. All rights reserved.
//

import UIKit

class FeedTextCell: UITableViewCell {

    @IBOutlet weak var batLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        batLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping // Label outlet
        batLabel.numberOfLines = 0
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
