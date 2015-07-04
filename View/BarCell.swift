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
    func activityButtonPressed(cell:BarCell)
}


class BarCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var batsButton: UIButton!
    @IBOutlet weak var activityButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
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
        
        var user = PFUser.currentUser()! as PFUser
        self.usernameLabel.text = PFUser.currentUser()?.objectForKey("name") as? String
        
        var query : PFQuery =  PAPUtility.queryForActivitiesOnUser(PFUser.currentUser())
        
        
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if (error != nil){
                
            }
            else{
                var dislikersCount = 0
                var likersCount = 0
                
                for(index, activity) in enumerate(objects as! Array<PFObject>){
                    
                    if((activity as PFObject).objectForKey(kPAPActivityTypeKey) as! String == kPAPActivityTypeDislike){
                        dislikersCount++
                    }
                    // like
                    if((activity as PFObject).objectForKey(kPAPActivityTypeKey) as! String == kPAPActivityTypeLike){
                        
                        likersCount++
                    }
                }
                println("likers count \(likersCount) && \(dislikersCount)")
                var batscore = likersCount - dislikersCount
                self.scoreLabel.text = String(batscore)

                
            }
        }
        
        
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
