//
//  ActivityCell.swift
//  Batling
//
//  Created by Ingouackaz on 2015-05-30.
//  Copyright (c) 2015 Ingouackaz. All rights reserved.
//

import UIKit
import Parse

class ActivityCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var punchlineLabel: UILabel!
    @IBOutlet weak var voteImageView: UIImageView!
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var testLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func configureWithActivity(activity:BatActivity){
    
        
        self.punchlineLabel.layer.borderColor = UIColor.blackColor().CGColor;
        self.punchlineLabel.layer.borderWidth = 1.0;
        self.punchlineLabel.layer.masksToBounds = true
        
        self.usernameLabel.text = activity.fromUsername
        self.timeAgoLabel.text = activity.createdAt.timeAgo
        if (activity.activityType == kBatActivityTypeLike){
        
            self.voteLabel.text = kBatActivityLikeSentence
            self.voteImageView.image = UIImage(named: "upvote")
            
            if let pBatjoke = activity.object!.objectForKey(kPBatActivityBatJokeClassKey) as? PFObject {
                pBatjoke.fetchIfNeededInBackgroundWithBlock { (object, error) -> Void in
                    // name fromUser
                    println("obj \(object)")
                    if (object != nil && object!.objectForKey(kPBatJokeTypeKey)as! String == kPBatJokeTypePunchline){
                        //self.punchlineLabel//.text = "toto"

                        self.configureTextBat(object!)
                    }
                    else if (object != nil && object!.objectForKey(kPBatJokeTypeKey)as! String == kPBatJokeTypeMeme){
                        self.configureImageBat(object!)
                    }
                    // si image
                }
            }
        }
        else{
            self.voteLabel.text = kBatActivityDislikeSentence
            self.voteImageView.image = UIImage(named: "downvote")
            
            if let pBatjoke = activity.object!.objectForKey(kPBatActivityBatJokeClassKey) as? PFObject {
                pBatjoke.fetchIfNeededInBackgroundWithBlock { (object, error) -> Void in
                    // name fromUser
                    println("obj \(object)")
                    if ( object!.objectForKey(kPBatJokeTypeKey)as! String == kPBatJokeTypePunchline){
                        self.configureTextBat(object!)
                    }
                    else{
                        self.configureImageBat(object!)
                    }
                    // si image
                }
            }
        }
    }
    
    
    
    func configureImageBat(object:PFObject){
        
        var imgFile = object.objectForKey(kPBatJokeTypeMemeImageKey) as! PFFile
        imgFile.getDataInBackgroundWithBlock({
            (imageData: NSData?, error: NSError?) -> Void in
            if (error == nil) {
                println("image donwloaded")
                self.memeImageView.image = UIImage(data:imageData!)!
            }
        })
    }
    
    func configureTextBat(object:PFObject){
        
        var text = object.objectForKey(kPBatJokeTypePunchlineTextKey) as! String
        println("text \(text)")
        self.punchlineLabel.text = text
    }
}


