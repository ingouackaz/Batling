//
//  FeedTextCell.swift
//  Batling
//
//  Created by Ingouackaz on 2015-05-30.
//  Copyright (c) 2015 Ingouackaz. All rights reserved.
//

import UIKit

protocol FeedTextCellDelegate{
    
    func didTapTextBat(joke:BatJoke,button:UIButton, cell:FeedTextCell,type:PhotoType)
    func didReportBat(joke:BatJoke, cell:UITableViewCell)
}


enum PhotoType : Int {
    case Like = 0
    case Unlike = 1
}

class FeedTextCell: UITableViewCell {

    @IBOutlet weak var batLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var unlikeButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var reportButton: UIButton!
    
    
    var delegate:FeedTextCellDelegate? = nil
    var _joke :BatJoke?
    
    @IBOutlet weak var timeAgoLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        batLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping // Label outlet
        batLabel.numberOfLines = 0
        batLabel.textAlignment = NSTextAlignment.Left
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

    func configureCellWith(joke:BatJoke){
        _joke = joke
        self.timeAgoLabel.text = joke.createdAt.timeAgo
        self.batLabel.text = joke.text
        
        if (joke.username == ""){
            if let pUser = joke.object!.objectForKey(kPBatJokeUserKey) as? PFUser {
                pUser.fetchIfNeededInBackgroundWithBlock { (object, error) -> Void in
                    // username
                    var name = pUser.objectForKey("name") as? String
                    if (name != nil) {
                        self.usernameLabel.text = name!
                        println("username \(name)")
                        
                        
                    }
                }
            }
        }
        
        
        
        self.usernameLabel.text = joke.username
        println("su \(joke.username)")
        
        self.likeButton.addTarget(self, action: "didLikeTextBatTarget:", forControlEvents: UIControlEvents.TouchUpInside)
        self.unlikeButton.addTarget(self, action: "didDislikeTextBatTarget:", forControlEvents: UIControlEvents.TouchUpInside)
        self.reportButton.addTarget(self, action: "didReportBat", forControlEvents: UIControlEvents.TouchUpInside)

        
        
        
        var attributesForPhoto = PAPCache.sharedCache().attributesForPhoto(joke.object)
        println("attr \(attributesForPhoto)")
        if((attributesForPhoto) != nil){
            self.setLikeAndDislikeStatus(PAPCache.sharedCache().isPhotoLikedByCurrentUser(joke.object),disliked: PAPCache.sharedCache().isPhotoDislikedByCurrentUser(joke.object))
            
        }
        else{
            
            var outstandingSectionHeaderQueryStatus = BatlingSingleton.sharedInstance._xoutstandingSectionHeaderQueries[self]
            
            if(outstandingSectionHeaderQueryStatus == nil){
                var query =  PAPUtility.queryForActivitiesOnPhoto(joke.object!)
                println("obj \(joke.object!)")
                
                query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                    
                    
                    if (error != nil){
                        
                    }
                    else{
                        var isLikedByCurrentUser : Bool = false
                        var isDislikedByCurrentUser : Bool = false
                        
                        for(index, activity) in enumerate(objects as! Array<PFObject>){
                            
                            // like
                            
                            if ((activity as PFObject).objectForKey(kPAPActivityFromUserKey)!.objectId == PFUser.currentUser()!.objectId){
                                
                                if((activity as PFObject).objectForKey(kPAPActivityTypeKey) as! String == kPAPActivityTypeLike){
                                    isLikedByCurrentUser = true
                                }
                            }
                            
                            if ((activity as PFObject).objectForKey(kPAPActivityFromUserKey)!.objectId == PFUser.currentUser()!.objectId){
                                
                                if((activity as PFObject).objectForKey(kPAPActivityTypeKey) as! String == kPAPActivityTypeDislike){
                                    isDislikedByCurrentUser = true

                                }
                            }
                        }
                        
                         PAPCache.sharedCache().setAttributesForPhoto(joke.object, likedByCurrentUser: isLikedByCurrentUser, dislikedByCurrentUser: isDislikedByCurrentUser)
                        
                        
                        self.setLikeAndDislikeStatus(PAPCache.sharedCache().isPhotoLikedByCurrentUser(joke.object),disliked: PAPCache.sharedCache().isPhotoDislikedByCurrentUser(joke.object))
                    }
                })
            }
        }
    }
  
    func setLikeAndDislikeStatus(liked:Bool, disliked:Bool){
        
        if(liked == true  || disliked == true){
            self.likeButton.selected = liked
            self.unlikeButton.selected = disliked

            self.likeButton.hidden = disliked
            self.unlikeButton.hidden = liked

        }
        else{
            self.likeButton.selected = false
            self.unlikeButton.selected = false
            
            self.likeButton.hidden = false
            self.unlikeButton.hidden = false
        }

    }

    func handlerErrorConnection(){
        
    }

    func didLikeTextBatTarget(button: UIButton){
        if (delegate != nil){
            self.likeButton.selected = true
            self.unlikeButton.hidden = true
            delegate!.didTapTextBat(_joke!,button: self.likeButton, cell: self,type:PhotoType(rawValue:0)!)
        }
    }
    
    func didDislikeTextBatTarget(button: UIButton){
        if (delegate != nil){
            self.likeButton.hidden = true
            self.unlikeButton.selected = true
            delegate!.didTapTextBat(_joke!,button: self.unlikeButton, cell: self,type:PhotoType(rawValue: 1)!)
        }
    }
    
    func didReportBat(){
        
        if (delegate != nil){
            delegate!.didReportBat(_joke!, cell: self)
        }
    }
    @IBAction func didTapPhotoAction(sender: UIButton) {
        
        if (delegate != nil){
            println("sender tag \( sender.tag)")
            delegate!.didTapTextBat(_joke!,button: sender, cell: self,type:PhotoType(rawValue: sender.tag)!)
        }
    }
    
    func shouldEnableLikeButton(enable:Bool){
        if(enable){
            
            self.likeButton.removeTarget(self, action:"didTapPhotoAction:", forControlEvents: .TouchUpInside)
           // self.likeButton.hidden = true
            self.unlikeButton.hidden = true
            
        }
        else{
            self.likeButton.addTarget(self, action:"didTapPhotoAction:", forControlEvents: .TouchUpInside)
        }
        
    }
    
    func shouldEnableDislikeButton(enable:Bool){
        if(enable){
            self.unlikeButton.removeTarget(self, action:"didTapPhotoAction:", forControlEvents: .TouchUpInside)
            self.likeButton.hidden = true
           // self.unlikeButton.hidden = true
            
        }
        else{
            self.unlikeButton.addTarget(self, action:"didTapPhotoAction:", forControlEvents: .TouchUpInside)
        }
        
    }
    

}
