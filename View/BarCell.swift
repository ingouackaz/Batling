//
//  BarCell.swift
//  Batling
//
//  Created by Ingouackaz on 2015-05-29.
//  Copyright (c) 2015 Ingouackaz. All rights reserved.
//

import UIKit


protocol BarCellDelegate{
    func batsButtonPressed(cell:BarCell)
    func activityButtonPressed(ell:BarCell)
}


class BarCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var batsButton: UIButton!
    @IBOutlet weak var activityButton: UIButton!
    
    var delegate:BarCellDelegate? = nil

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       // activityButton.selected = true
       // batsButton.selected = false
        // Configure the view for the selected state
    }
    
    func configureCell(){
        
        var origin = self.activityButton!.frame.origin
        
        origin.x = 0
        self.activityButton!.frame = CGRect(origin:origin, size: CGSize(width: 400, height: 400))
        
        self.activityButton.addTarget(self, action: "activityButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.batsButton.addTarget(self, action: "batsButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.layoutMargins = UIEdgeInsetsZero;
        self.preservesSuperviewLayoutMargins = false;
    }

    
    @IBAction func batsButtonPressed(sender: AnyObject) {

        
        if (delegate != nil){
            delegate!.batsButtonPressed(self)

        }
 
    }
    
    @IBAction func activityButtonPressed(sender: AnyObject) {

        
        if (delegate != nil){
            delegate!.activityButtonPressed( self)
        }
        
    }
}
