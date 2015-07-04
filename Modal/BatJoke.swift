//
//  BatJoke.swift
//  Batling
//
//  Created by Ingouackaz on 2015-06-17.
//  Copyright (c) 2015 Ingouackaz. All rights reserved.
//

import UIKit

class BatJoke  {
   
    
    var type : String = ""
    var text : String = ""
    var imageFile : PFFile = PFFile()
    var username : String = ""
    var createdAt : NSDate = NSDate()
    var object : PFObject?
    init(object:PFObject){
        println("object \(object)")
        self.object = object
        createdAt  = object.createdAt!
        if let pType = object.objectForKey(kPBatJokeTypeKey) as? String {
            type = pType
            println("texte \(type)")
            
            
            // Punchline
            if (type == kPBatJokeTypePunchline){
                text = object.objectForKey(kPBatJokeTypePunchlineTextKey) as! String
            }
                
            // Meme
            else{
                imageFile = object.objectForKey(kPBatJokeTypeMemeImageKey) as! PFFile
                
            }
            
            
            if let pUser = object.objectForKey(kPBatJokeUserKey) as? PFUser {
                pUser.fetchIfNeededInBackgroundWithBlock { (object, error) -> Void in
                // username
                    var name = pUser.objectForKey("name") as? String
                    if (name != nil) {
                        self.username = name!
                        println("username \(name)")

                        
                    }
                    }
            }
        }
        
    }
    
    
}
