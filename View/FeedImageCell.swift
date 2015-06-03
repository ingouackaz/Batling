//
//  FeedCell.swift
//  Batling
//
//  Created by Ingouackaz on 2015-05-28.
//  Copyright (c) 2015 Ingouackaz. All rights reserved.
//

import UIKit

class FeedImageCell: UITableViewCell {
    @IBOutlet weak var pictureImageView: UIImageView!

    @IBOutlet weak var shareButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureCell(){
    
        
        var origin = self.pictureImageView!.frame.origin
        
        origin.x = 0
        self.pictureImageView!.frame = CGRect(origin:origin, size: CGSize(width: 400, height: 400))
        self.layoutMargins = UIEdgeInsetsZero;
        self.preservesSuperviewLayoutMargins = false;
        
    }

}
