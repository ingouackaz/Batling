//
//  BatActivity.swift
//  Batling
//
//  Created by Ingouackaz on 2015-07-03.
//  Copyright (c) 2015 Ingouackaz. All rights reserved.
//

import UIKit

class BatActivity: NSObject {
   
    var activityType : String = ""
    var text : String = ""
    var fromUsername : String = ""
    var createdAt : NSDate = NSDate()
    var object : PFObject?
    var batJokeType : String = ""
    
    init(object:PFObject){
        println("object \(object)")
        super.init()
        self.object = object
        createdAt  = object.createdAt!
        if let pType = object.objectForKey(kPBatJokeTypeKey) as? String {
            activityType = pType
            println("texte \(activityType)")
            if let pUser = object.objectForKey(kPBatActivityFromUserKey) as? PFUser {
                pUser.fetchIfNeededInBackgroundWithBlock { (object, error) -> Void in
                    // name fromUser
                    var name = pUser.objectForKey("name") as? String
                    if (name != nil) {
                        self.fromUsername = name!
                        
                    }
                }
            }
            if let batJoke = object.objectForKey(kPBatActivityTargetTypeKey) as? String {
                self.batJokeType = batJoke
            }
        }
        
    }
}
