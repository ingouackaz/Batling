//
//  FeedCell.swift
//  Batling
//
//  Created by Ingouackaz on 2015-05-28.
//  Copyright (c) 2015 Ingouackaz. All rights reserved.
//

import UIKit


protocol FeedImageCellDelegate{
    func didTapPhotoBat(joke:BatJoke,button:UIButton, cell:FeedImageCell,type:PhotoType)
    func didReportBat(joke:BatJoke, cell:UITableViewCell)
}

class FeedImageCell: UITableViewCell {
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!

    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    
    
    @IBOutlet weak var unlikeButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    
    var delegate:FeedImageCellDelegate? = nil
    var _joke :BatJoke?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    


    
    func configureCellWith(joke:BatJoke){
        _joke = joke

        self.usernameLabel.text = joke.username
        self.timeAgoLabel.text = joke.createdAt.timeAgo
        var origin = self.pictureImageView!.frame.origin
        self.likeButton.addTarget(self, action: "didLikePhotoBatTarget:", forControlEvents: UIControlEvents.TouchUpInside)
        self.unlikeButton.addTarget(self, action: "didDislikePhotoBatTarget:", forControlEvents: UIControlEvents.TouchUpInside)
        self.reportButton.addTarget(self, action: "didReportBat", forControlEvents: UIControlEvents.TouchUpInside)
        origin.x = 0
        self.pictureImageView!.frame = CGRect(origin:origin, size: CGSize(width: 400, height: 400))
        self.layoutMargins = UIEdgeInsetsZero;
        self.preservesSuperviewLayoutMargins = false;
        
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
        
        joke.imageFile.getDataInBackgroundWithBlock({
            (imageData: NSData?, error: NSError?) -> Void in
            if (error == nil) {
                println("image donwloaded")
                self.pictureImageView.image = UIImage(data:imageData!)!
            }
            
        })
        
        var attributesForPhoto = PAPCache.sharedCache().attributesForPhoto(joke.object)
        
        if((attributesForPhoto) != nil){
            self.setLikeAndDislikeStatus(PAPCache.sharedCache().isPhotoLikedByCurrentUser(joke.object),disliked: PAPCache.sharedCache().isPhotoDislikedByCurrentUser(joke.object))
            
        }
        else{
            
            var outstandingSectionHeaderQueryStatus = BatlingSingleton.sharedInstance._outstandingSectionHeaderQueries[self]
            
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
        
        println("status liked \(liked) && disliked \(disliked)")
        
        if (liked == true){
            self.likeButton.selected = true
            self.likeButton.hidden = false

            self.unlikeButton.hidden = true
            self.unlikeButton.selected = false

        }
        else if (disliked == true){
            self.unlikeButton.selected = true
            self.unlikeButton.hidden = false

            self.likeButton.hidden = true
            self.likeButton.selected = false

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
    
    func didReportBat(){
    
        if (delegate != nil){
            delegate!.didReportBat(_joke!, cell: self)
        }
    }
    
    func didLikePhotoBatTarget(button: UIButton){
        if (delegate != nil){
            self.likeButton.selected = true
            self.unlikeButton.hidden = true
            delegate!.didTapPhotoBat(_joke!,button: self.likeButton, cell: self,type:PhotoType(rawValue:0)!)
        }
    }
    
    func didDislikePhotoBatTarget(button: UIButton){
        if (delegate != nil){
            self.unlikeButton.selected = true
            self.likeButton.hidden = true
            delegate!.didTapPhotoBat(_joke!,button: self.unlikeButton, cell: self,type:PhotoType(rawValue:1)!)
        }
    }
    

    func shouldEnableLikeButton(enable:Bool){
        if(enable){
            
            self.likeButton.removeTarget(self, action:"didLikePhotoBatTarget:", forControlEvents: .TouchUpInside)
            self.unlikeButton.hidden = true
            
        }
        else{
            self.likeButton.addTarget(self, action:"didLikePhotoBatTarget:", forControlEvents: .TouchUpInside)
        }
        
    }
    
    func shouldEnableDislikeButton(enable:Bool){
        if(enable){
            self.unlikeButton.removeTarget(self, action:"didDislikePhotoBatTarget:", forControlEvents: .TouchUpInside)
            self.likeButton.hidden = true
            // self.unlikeButton.hidden = true
            
        }
        else{
            self.unlikeButton.addTarget(self, action:"didDislikePhotoBatTarget:", forControlEvents: .TouchUpInside)
        }
        
    }


}
