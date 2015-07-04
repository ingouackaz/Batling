//
//  PAPCache.h
//  Anypic
//
//  Created by Héctor Ramos on 5/31/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface PAPCache : NSObject

+ (id)sharedCache;

- (void)clear;
- (void)setAttributesForPhoto:(PFObject *)photo   likers:(NSArray *)likers  dislikers:(NSArray *)dislikers likedByCurrentUser:(BOOL)likedByCurrentUser dislikedByCurrentUser:(BOOL)dislikedByCurrentUser;
- (void)setAttributesForPhoto:(PFObject *)photo likers:(NSArray *)likers commenters:(NSArray *)commenters likedByCurrentUser:(BOOL)likedByCurrentUser dislikers:(NSArray *)dislikers dislikedByCurrentUser:(BOOL)dislikedByCurrentUser;
- (void)setAttributesForPhoto:(PFObject *)photo  likedByCurrentUser:(BOOL)likedByCurrentUser dislikedByCurrentUser:(BOOL)dislikedByCurrentUser;

- (void)setAttributesForPhoto:(PFObject *)photo likers:(NSArray *)likers commenters:(NSArray *)commenters dislikedByCurrentUser:(BOOL)likedByCurrentUser;


- (NSDictionary *)attributesForPhoto:(PFObject *)photo;
- (NSNumber *)likeCountForPhoto:(PFObject *)photo;
- (NSNumber *)dislikeCountForPhoto:(PFObject *)photo;



- (NSNumber *)commentCountForPhoto:(PFObject *)photo;
- (NSArray *)likersForPhoto:(PFObject *)photo;
- (NSArray *)dislikersForPhoto:(PFObject *)photo;

- (NSArray *)commentersForPhoto:(PFObject *)photo;
- (void)setPhotoIsLikedByCurrentUser:(PFObject *)photo liked:(BOOL)liked;

- (void)setPhotoIsDislikedByCurrentUser:(PFObject *)photo liked:(BOOL)liked;

- (BOOL)isPhotoLikedByCurrentUser:(PFObject *)photo;

- (BOOL)isPhotoDislikedByCurrentUser:(PFObject *)photo;


- (void)incrementLikerCountForPhoto:(PFObject *)photo;
- (void)decrementLikerCountForPhoto:(PFObject *)photo;

- (void)incrementDislikerCountForPhoto:(PFObject *)photo;


- (void)incrementCommentCountForPhoto:(PFObject *)photo;
- (void)decrementCommentCountForPhoto:(PFObject *)photo;

- (NSDictionary *)attributesForUser:(PFUser *)user;
- (NSNumber *)photoCountForUser:(PFUser *)user;
- (BOOL)followStatusForUser:(PFUser *)user;
- (void)setPhotoCount:(NSNumber *)count user:(PFUser *)user;
- (void)setFollowStatus:(BOOL)following user:(PFUser *)user;

- (void)setFacebookFriends:(NSArray *)friends;
- (NSArray *)facebookFriends;
@end
