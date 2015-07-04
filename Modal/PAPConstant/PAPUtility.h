//
//  PAPUtility.h
//  Anypic
//
//  Created by Mattieu Gamache-Asselin on 5/18/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//
@import UIKit;
#import <Parse/Parse.h>


@interface PAPUtility : NSObject

+ (void)likePhotoInBackground:(id)photo  type:(NSString *)jokeType block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
+ (void)dislikePhotoInBackground:(id)photo  type:(NSString *)jokeType block:(void (^)(BOOL succeeded, NSError *error))completionBlock;


+ (BOOL)userHasProfilePictures:(PFUser *)user;
+ (UIImage *)defaultProfilePicture;

+ (NSString *)firstNameForDisplayName:(NSString *)displayName;

+ (void)followUserInBackground:(PFUser *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
+ (void)followUserEventually:(PFUser *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
+ (void)followUsersEventually:(NSArray *)users block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
+ (void)unfollowUserEventually:(PFUser *)user;
+ (void)unfollowUsersEventually:(NSArray *)users;

+ (void)drawSideDropShadowForRect:(CGRect)rect inContext:(CGContextRef)context;
+ (void)drawSideAndBottomDropShadowForRect:(CGRect)rect inContext:(CGContextRef)context;
+ (void)drawSideAndTopDropShadowForRect:(CGRect)rect inContext:(CGContextRef)context;  

+ (PFQuery *)queryForActivitiesOnPhoto:(PFObject *)photo;
+ (PFQuery *)queryForActivitiesOnUser:(PFUser *)user;

@end
