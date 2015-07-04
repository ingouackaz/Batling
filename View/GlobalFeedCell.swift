//
//  GlobalFeedCell.swift
//  Batling
//
//  Created by Ingouackaz on 2015-07-03.
//  Copyright (c) 2015 Ingouackaz. All rights reserved.
//

import UIKit



protocol GlobalFeedCellDelegate{
    func didTapBat(joke:BatJoke,button:UIButton, cell:GlobalFeedCell,type:OpinionType)
    func didReportBat(joke:BatJoke, cell:UITableViewCell)
    func didDeleteBat(joke:BatJoke, cell:UITableViewCell)
}

class GlobalFeedCell: UITableViewCell {

    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    
    
    @IBOutlet weak var unlikeButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var batScoreLabel: UILabel!
    @IBOutlet weak var batLabel: UILabel!

    
    var delegate:GlobalFeedCellDelegate? = nil
    var _joke :BatJoke?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func configureCellForProfileWith(joke:BatJoke){
        
        _joke = joke

        self.likeButton.hidden = true
        self.unlikeButton.hidden = true
        self.usernameLabel.hidden = true
        
        //self.usernameLabel.text = joke.username
        
        
        
        self.timeAgoLabel.text = joke.createdAt.timeAgo
        self.shareButton.addTarget(self, action: "shareAction:", forControlEvents: UIControlEvents.TouchUpInside)
        self.reportButton.addTarget(self, action: "didDeletetBat", forControlEvents: UIControlEvents.TouchUpInside)

        
        
        if (joke.type == kPBatJokeTypePunchline){
            self.configureTextCell(joke)
            
        }
        else{
            self.configureImageCell(joke)
        }
        
        var attributesForPhoto = PAPCache.sharedCache().attributesForPhoto(joke.object)
        
        var c = joke.object?.objectForKey("dislikeCount")
        println(" #obj \(c) && attributesForPhoto \(attributesForPhoto) ")

        if((attributesForPhoto) != nil &&  joke.object?.objectForKey("dislikeCount") != nil){
            println("like count  obj \(joke.object)")

           
            
            var likeCount = joke.object?.objectForKey("dislikeCount") as! Int
            var dislikeCount = joke.object?.objectForKey("likeCount") as! Int

            println("like count \(likeCount) obj \(joke.object)")

            self.setBatscore(likeCount, dislikeCount: dislikeCount)

        }
        else{
            
            var outstandingSectionHeaderQueryStatus = BatlingSingleton.sharedInstance._woutstandingSectionHeaderQueries[self]
            
            if(outstandingSectionHeaderQueryStatus == nil){
                var query =  PAPUtility.queryForActivitiesOnPhoto(joke.object!)
                println("obj \(joke.object!)")
                
                query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                    if (error != nil){
                        
                    }
                    else{
                        var isLikedByCurrentUser : Bool = false
                        var isDislikedByCurrentUser : Bool = false
                        var likers : Array<PFUser>= []
                        var dislikers : Array<PFUser>= []
                        
                        
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
                            
                            
                            // dislikers
                            if((activity as PFObject).objectForKey(kPAPActivityTypeKey) as! String == kPAPActivityTypeDislike){
                                
                                dislikers.append((activity as PFObject).objectForKey(kPAPActivityFromUserKey) as! PFUser )
                            }
                            
                            // like
                            if((activity as PFObject).objectForKey(kPAPActivityTypeKey) as! String == kPAPActivityTypeLike){
                            
                                likers.append((activity as PFObject).objectForKey(kPAPActivityFromUserKey) as! PFUser )
                            }
                        }
                        
                        PAPCache.sharedCache().setAttributesForPhoto(joke.object, likers: likers, dislikers: dislikers, likedByCurrentUser: isLikedByCurrentUser, dislikedByCurrentUser: isDislikedByCurrentUser)
                        
                        self.batScoreLabel.text = String(likers.count - dislikers.count)
                        self.setBatscore(likers.count, dislikeCount: dislikers.count)
                        self.batScoreLabel.hidden = false
                    }
                })
            }
        }

    }
    
    func configureCellWith(joke:BatJoke){

        _joke = joke
        

        self.usernameLabel.text = joke.username
        self.timeAgoLabel.text = joke.createdAt.timeAgo
        self.likeButton.addTarget(self, action: "didLikePhotoBatTarget:", forControlEvents: UIControlEvents.TouchUpInside)
        self.unlikeButton.addTarget(self, action: "didDislikePhotoBatTarget:", forControlEvents: UIControlEvents.TouchUpInside)
        self.reportButton.addTarget(self, action: "didReportBat", forControlEvents: UIControlEvents.TouchUpInside)
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

        if (joke.type == kPBatJokeTypePunchline){
            self.configureTextCell(joke)

        }
        else{
            self.configureImageCell(joke)
        }
        
        var attributesForPhoto = PAPCache.sharedCache().attributesForPhoto(joke.object)
        
        if((attributesForPhoto) != nil){
            self.setLikeAndDislikeStatus(PAPCache.sharedCache().isPhotoLikedByCurrentUser(joke.object),disliked: PAPCache.sharedCache().isPhotoDislikedByCurrentUser(joke.object))
            
        }
        else{
            
            var outstandingSectionHeaderQueryStatus = BatlingSingleton.sharedInstance._woutstandingSectionHeaderQueries[self]
            
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
    
    func setBatscore(likeCount:Int, dislikeCount:Int){
        var batscore = likeCount - dislikeCount
        if (batscore > 0){
            self.batScoreLabel.text = "+" + String(batscore)
        }
        else{
            self.batScoreLabel.text = String(batscore)
        }
    }
    
    func configureImageCell(joke:BatJoke){
        var origin = self.pictureImageView!.frame.origin
        origin.x = 0
        self.pictureImageView!.frame = CGRect(origin:origin, size: CGSize(width: 400, height: 400))
        self.layoutMargins = UIEdgeInsetsZero;
        self.preservesSuperviewLayoutMargins = false;
        
        joke.imageFile.getDataInBackgroundWithBlock({
            (imageData: NSData?, error: NSError?) -> Void in
            if (error == nil) {
                println("image donwloaded")
                self.pictureImageView.image = UIImage(data:imageData!)!
            }
            
        })
    }
    
    func configureTextCell(joke:BatJoke){
        self.batLabel.text = joke.text        
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
    
    
    
    func didDeletetBat(){
        if (delegate != nil){
            delegate!.didDeleteBat(_joke!, cell: self)
        }
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
            delegate!.didTapBat(_joke!,button: self.likeButton, cell: self,type:OpinionType(rawValue:0)!)
        }
    }
    
    func didDislikePhotoBatTarget(button: UIButton){
        if (delegate != nil){
            self.unlikeButton.selected = true
            self.likeButton.hidden = true
            delegate!.didTapBat(_joke!,button: self.unlikeButton, cell: self,type:OpinionType(rawValue:1)!)
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
    

    
    func shareAction(button:UIButton){
        var joke = _joke!
        
        if (joke.type == kPBatJokeTypeMeme){
            
            var activityItems: [AnyObject]?
            
            if (self.pictureImageView?.image != nil) {
                let image = self.pictureImageView!.image
                
                activityItems = [image!]
                let activityController = UIActivityViewController(activityItems:
                    activityItems!, applicationActivities: nil)
                activityController.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
                var navigationController = UIApplication.sharedApplication().windows[0].rootViewController as! UINavigationController

                navigationController.presentViewController(activityController, animated: true, completion: nil)

                //self.presentViewController(activityController, animated: true,
                  //  completion: nil)
            }
            
        }
        else{
            var activityItems: [AnyObject]?
            
            let firstActivityItem = self.batLabel.text!
            var activityVC = UIActivityViewController(activityItems: [firstActivityItem], applicationActivities: nil)
            
            activityVC.excludedActivityTypes = [
                UIActivityTypePostToWeibo,
                UIActivityTypePrint,
                UIActivityTypeCopyToPasteboard,
                UIActivityTypeAssignToContact,
                UIActivityTypeSaveToCameraRoll,
                UIActivityTypeAddToReadingList,
                UIActivityTypePostToFlickr,
                UIActivityTypePostToVimeo,
                UIActivityTypePostToTencentWeibo,
                UIActivityTypeAirDrop
            ]
            
            activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
            
            activityVC.completionWithItemsHandler = {(activityType: String!, completed: Bool, arrayOptions: [AnyObject]!, error: NSError!) in
                println(activityType)
            }
            
            var navigationController = UIApplication.sharedApplication().windows[0].rootViewController as! UINavigationController

            navigationController.presentViewController(activityVC, animated: true, completion: nil)
           // self.presentViewController(activityVC, animated: true, completion: nil)
        }
        
        
        
    }
    
}
