//
//  PBatConstant.swift
//  Batling
//
//  Created by Ingouackaz on 2015-06-17.
//  Copyright (c) 2015 Ingouackaz. All rights reserved.
//

import UIKit



let kPBatJokeUserKey = "user"
let kPBatJokeClassKey : String = "BatJoke"
let kPBatJokeTypeKey : String = "type"
let kPBatJokeTypeMeme : String = "meme"
let kPBatJokeTypeMemeImageKey : String = "image"
let kPBatJokeTypePunchline : String = "punchline"
let kPBatJokeTypePunchlineTextKey : String = "text"


// Field keys

let kPBatActivityClassKey = "Activity"
let kPBatActivityTypeKey = "type"
let kPBatActivityFromUserKey = "fromUser"
let kPBatActivityToUserKey = "toUser"
let kPBatActivityContentKey = "content"
let kPBatActivityBatJokeClassKey = "batJoke"

let kPBatActivityBatJokeKey = "batJoke"

let kPBatActivityTargetTypeKey = "targetType"


// Type values

let kPBatActivityTypePunchline = "punchline"
let kPBatActivityTypeMeme = "meme"
let kPBatActivityTypeReport = "report"
let kBatActivityTypeLike = "like";
let kBatActivityTypeDislike = "dislike";

// Index

enum ProfileFeedIndex : Int {
    
    case MyActivity = 0
    case MyBats = 1
    
}

enum OpinionType : Int {
    case Like = 0
    case Unlike = 1
}


// Sentence


let kBatActivityLikeSentence = "Oh yeahhh!"
let kBatActivityDislikeSentence = "Oops !!"
let kBatActivityShareSentence = "C'est bon ça"



// log event


let batEventSignUpPressed = "SignUp Pressed"
let batEventSignUpSuccessful = "SignUp Successful"

let batEventSignInPressed = "SignIn Pressed"
let batEventSignInSuccessful = "SignIn Successful"

let batEventLogoutPressed = "Logout Pressed"

let batEventRecentsCategoryPressed = "Recents Category Pressed"
let batEventPopularCategoryPressed = "Popular Category Pressed"

let batEventHelpPressed = "Help Page Selected"
let batEventAddBatPressed = "Add Bat Pressed"

let batEventBatJokeCanceled = "BatJoke Canceled"

let batEventPunchlineCategorySelected = "Punchline Category Selected"
let batEventMemeCategorySelected = "Select Category Image Selected"

let batEventPunchlineStartTyping = "Punchline Start Typing"
let batEventCameraAddImagePressed = "Camera Add Image Pressed"
let batEventGoogleAddImagePressed = "Google Add Image Pressed"
let batEventAlbumAddPhotoPressed = "Album Add Photo Pressed"
let batEventAddTextToImagePressed = "Add Text To Image Pressed"

let batEventImageAddedFromGoogle = "Image Added From Google"


let batEventImageBatJokePublished = "Image BatJoke Published"
let batEventPunchlineBatJokePublished = "Punchline BatJoke Published"

let batEventProfilePageSelected = "Profile Page Selected"
let batEventMyBatsCategoryPressed = "My Bats Category Pressed"
let batEventMyActivityCategoryPressed = "My Activity Category Pressed"

let batEventDeleteMyBatsPressed = "Delete My Bats Pressed"
let batEventBatsDeleted = "Bats Deleted"

/*
- “Inscription” tapped

- Inscription successful

- “Se connecter” tapped

- Se connecter successful

- “Se déconnecter” tapped

- “Récents” tapped

- “Populaires” tapped

- “Aide” tapped

- “Add button” tapped

- “Cancel bat” tapped

- “Punchline” tapped

- Punchline started (User starts typing text)

- “Image” tapped

- “Camera” tapped

- “Google image” tapped

- “Album” tapped

- Image added successfully

- “Add text to image” tapped

- Text added successfully

- “Publier” tapped

- “Mon profil” tapped

- “Mes bats” tapped

- “Mon activité” tapped

- “Three dots” tapped (in “mes bats”)

- “Supprimer mon bat” successful
*/
