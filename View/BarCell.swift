//
//  BarCell.swift
//  Batling
//
//  Created by Ingouackaz on 2015-05-29.
//  Copyright (c) 2015 Ingouackaz. All rights reserved.
//

import UIKit

class BarCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var batsButton: UIButton!
    @IBOutlet weak var activityButton: UIButton!
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        activityButton.selected = true
        batsButton.selected = false
        // Configure the view for the selected state
    }

}
