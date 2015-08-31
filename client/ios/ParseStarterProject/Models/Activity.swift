//
//  Activity.swift
//  Think
//
//  Created by denis zaytcev on 8/15/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import Bolts

class Activity: PFObject, PFSubclassing {
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return kActivityClassKey
    }
    
    class func isLikePost(post: PFObject)-> Bool {
        return MyCache.sharedCache.isPostLikedByCurrentUser(post)
    }
    
    class func isFollowUser(otherUser: PFObject)-> Bool {
        return MyCache.sharedCache.followStatusForUser(otherUser)
    }
    
    class func handlerLikePost(post: PFObject) {
        if isLikePost(post) {
            dislikePost(post)
        } else {
            likePost(post)
        }
    }
    
    class func dislikePost(post: PFObject) {
        let user = PFUser.currentUser()
        let query = PFQuery(className: kActivityClassKey)
        query.whereKey(kActivityFromUserKey, equalTo: user!)
        query.whereKey(kActivityTypeKey, equalTo: kActivityTypeLike)
        query.whereKey(kActivityPostKey, equalTo: post)
        
        query.getFirstObjectInBackground().continueWithBlock { (task: BFTask!) -> AnyObject! in
            if (task.error == nil) {
                if let activity = task.result as? PFObject {
                    activity.deleteEventually()
                    post.saveInBackground()
                }
            } else {
            }
            
            return task
        }
        
        post.incrementKey(kPostCounterLikesKey, byAmount: -1)
        MyCache.sharedCache.setPostIsLikedByCurrentUser(post, liked: false)
        NSNotificationCenter.defaultCenter().postNotificationName(kUserUnlikedPost, object: post)
    }
    
    class func likePost(post: PFObject) {
        let user = PFUser.currentUser()
        let activity = PFObject(className: kActivityClassKey)
        activity.setObject(user!, forKey: kActivityFromUserKey)
        activity.setObject(post["owner"]!, forKey: kActivityToUserKey)
        activity.setObject(post, forKey: kActivityPostKey)
        activity.setObject(kActivityTypeLike, forKey: kActivityTypeKey)
        
        let activityACL = PFACL(user: user!)
        activityACL.setPublicReadAccess(true)
        activity.ACL = activityACL
        
        activity.saveInBackground().continueWithBlock { (task: BFTask!) -> AnyObject! in
            if task.error == nil {
                post.saveInBackground()
            } 
            
            return task
        }
        
        post.incrementKey(kPostCounterLikesKey, byAmount: 1)
        MyCache.sharedCache.setPostIsLikedByCurrentUser(post, liked: true)
        NSNotificationCenter.defaultCenter().postNotificationName(kUserLikedPost, object: post)
    }
    
    class func handlerFollowUser(otherUser: PFObject)  {
        if isFollowUser(otherUser) {
            unFollowUser(otherUser)
        } else {
            followUser(otherUser)
        }
    }
    
    class func followUser(otherUser: PFObject) {
        let user = PFUser.currentUser()
        let activity = PFObject(className: kActivityClassKey)
        activity.setObject(user!, forKey: kActivityFromUserKey)
        activity.setObject(otherUser, forKey: kActivityToUserKey)
        activity.setObject(kActivityTypeFollow, forKey: kActivityTypeKey)
        
        let activityACL = PFACL(user: user!)
        activityACL.setPublicReadAccess(true)
        activity.ACL = activityACL
        
        activity.saveEventually()
        MyCache.sharedCache.setFollowStatus(true, user: otherUser)
        NSNotificationCenter.defaultCenter().postNotificationName(kUserFollowingUser, object: otherUser)
    }
    
    class func unFollowUser(otherUser: PFObject) {
        let user = PFUser.currentUser()
        let query = PFQuery(className: kActivityClassKey)
        query.whereKey(kActivityFromUserKey, equalTo: user!)
        query.whereKey(kActivityToUserKey, equalTo: otherUser)
        query.whereKey(kActivityTypeKey, equalTo: kActivityTypeFollow)

        query.getFirstObjectInBackground().continueWithBlock { (task: BFTask!) -> AnyObject! in
            if (task.error != nil) {
                
            } else {
                let activity = task.result as! PFObject
                activity.deleteEventually()
                
                MyCache.sharedCache.setFollowStatus(false, user: otherUser)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    NSNotificationCenter.defaultCenter().postNotificationName(kUserUnfollowUser, object: otherUser)
                })
            }
            
            return task
        }
    }
    
    class func commentPost(post: PFObject, message: String) -> BFTask {
        let user        = PFUser.currentUser()
        let activity    = PFObject(className: kActivityClassKey)
        activity.setObject(user!, forKey: kActivityFromUserKey)
        activity.setObject(post, forKey: kActivityPostKey)
        activity.setObject(message, forKey: kActivityContentKey)
        activity.setObject(post["owner"]!, forKey: kActivityToUserKey)
        activity.setObject(kActivityTypeComment, forKey: kActivityTypeKey)
        
        let activityACL = PFACL(user: user!)
        activityACL.setPublicReadAccess(true)
        activity.ACL = activityACL
        
        return activity.saveInBackground().continueWithBlock { (task: BFTask!) -> AnyObject! in
            if task.error == nil {
                post.incrementKey(kPostCounterCommentsKey, byAmount: 1)
                post.saveEventually()
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    NSNotificationCenter.defaultCenter().postNotificationName(kUserSendComment, object: activity)
                })
            }
            return task
        }
    }
    
    class func commentPost(post: PFObject, picture: PFFile) -> BFTask {
        let user = PFUser.currentUser()
        let activity = PFObject(className: kActivityClassKey)
        activity.setObject(user!,                   forKey: kActivityFromUserKey)
        activity.setObject(post,                    forKey: kActivityPostKey)
        activity.setObject(picture,                 forKey: kActivityPictureKey)
        activity.setObject(post["owner"]!,          forKey: kActivityToUserKey)
        activity.setObject(kActivityTypeComment,    forKey: kActivityTypeKey)
        
        return activity.saveInBackground().continueWithBlock { (task: BFTask!) -> AnyObject! in
            if task.error == nil {
                post.incrementKey(kPostCounterCommentsKey, byAmount: 1)
                post.saveEventually()
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    NSNotificationCenter.defaultCenter().postNotificationName(kUserSendComment, object: activity)
                })
            }
            
            return task
        }
    }
}