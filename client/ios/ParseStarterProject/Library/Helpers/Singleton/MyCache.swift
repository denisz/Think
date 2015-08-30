//
//  MyCache.swift
//  Think
//
//  Created by denis zaytcev on 8/27/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse


final class MyCache {
    private var cache: NSCache
    
    // MARK:- Initialization
    
    static let sharedCache = MyCache()
    
    private init() {
        self.cache = NSCache()
    }
    
    // MARK:- PAPCache
    
    func clear() {
        cache.removeAllObjects()
    }
    
    func setAttributesForPost(post: PFObject, likersCount: Int, commentersCount: Int, likedByCurrentUser: Bool) {
        
        let attributes = [
            kAttributesIsLikedByCurrentUserKey: likedByCurrentUser,
            kAttributesLikeCountKey: likersCount,
            kAttributesCommentCountKey: commentersCount
        ]
        
        setAttributes(attributes as! [String : AnyObject], forPost: post)
    }
    
    func attributesForPost(post: PFObject) -> [String:AnyObject]? {
        let key: String = self.keyForPost(post)
        return cache.objectForKey(key) as? [String:AnyObject]
    }
    
    func likeCountForPost(post: PFObject) -> Int {
        if var attributes = self.attributesForPost(post) {
            return attributes[kAttributesLikeCountKey] as! Int
        }
        
        return 0
    }
    
    func commentCountForPost(post: PFObject) -> Int {
        if var attributes = attributesForPost(post) {
            return attributes[kAttributesCommentCountKey] as! Int
        }
        
        return 0
    }
    
    func setPostIsLikedByCurrentUser(post: PFObject, liked: Bool) {
        
        if var attributes = attributesForPost(post) {
            attributes.updateValue(liked, forKey: kAttributesIsLikedByCurrentUserKey)
            setAttributes(attributes, forPost: post)
        } else {
            setAttributesForPost(post, likersCount: 0, commentersCount: 0, likedByCurrentUser: liked)
        }
    }
    
    func isPostLikedByCurrentUser(post: PFObject) -> Bool {
        if var attributes = attributesForPost(post) {
            return attributes[kAttributesIsLikedByCurrentUserKey] as! Bool
        }
        
        return false
    }
    
    func incrementLikerCountForPost(post: PFObject) {
        let likerCount = likeCountForPost(post) + 1
        
        if var attributes = attributesForPost(post) {
            attributes[kAttributesLikeCountKey] = likerCount
            setAttributes(attributes, forPost: post)
        }
    }
    
    func decrementLikerCountForPost(post: PFObject) {
        let likerCount = likeCountForPost(post) - 1
        if likerCount < 0 {
            return
        }
        
        if var attributes = attributesForPost(post) {
            attributes[kAttributesLikeCountKey] = likerCount
            setAttributes(attributes, forPost: post)
        }
    }
    
    func incrementCommentCountForPost(post: PFObject) {
        let commentCount = commentCountForPost(post) + 1
        
        if var attributes = attributesForPost(post) {
            attributes[kAttributesCommentCountKey] = commentCount
            setAttributes(attributes, forPost: post)
        }
    }
    
    func decrementCommentCountForPhoto(post: PFObject) {
        let commentCount = commentCountForPost(post) - 1
        if commentCount < 0 {
            return
        }
        
        if var attributes = attributesForPost(post) {
            attributes[kAttributesCommentCountKey] = commentCount
            setAttributes(attributes, forPost: post)
        }
    }
    
    func setAttributesForUser(user: PFObject, postCount count: Int, followedByCurrentUser following: Bool) {
        let attributes = [
            kAttributesPostCountKey: count,
            kAttributesIsFollowedByCurrentUserKey: following
        ]
        
        setAttributes(attributes as! [String : AnyObject], forUser: user)
    }
    
    func attributesForUser(user: PFObject) -> [String:AnyObject]? {
        let key = keyForUser(user)
        return cache.objectForKey(key) as? [String:AnyObject]
    }
    
    func postCountForUser(user: PFObject) -> Int {
        if let attributes = attributesForUser(user) {
            if let photoCount = attributes[kAttributesPostCountKey] as? Int {
                return photoCount
            }
        }
        
        return 0
    }
    
    func followStatusForUser(user: PFObject) -> Bool {
        if let attributes = attributesForUser(user) {
            if let followStatus = attributes[kAttributesIsFollowedByCurrentUserKey] as? Bool {
                return followStatus
            }
        }
        
        return false
    }
    
    func incrementPostCountForUser(user: PFObject) {
        let count = postCountForUser(user) + 1
        
        if var attributes = attributesForUser(user) {
            attributes[kAttributesPostCountKey] = count
            setAttributes(attributes, forUser: user)
        }
    }
    
    func decrementPostCountForUser(user: PFObject) {
        let count = postCountForUser(user) - 1
        
        if count < 0 {
            return
        }

        if var attributes = attributesForUser(user) {
            attributes[kAttributesPostCountKey] = count
            setAttributes(attributes, forUser: user)
        }
    }
    
    func setPostCount(count: Int,  user: PFObject) {
        if var attributes = attributesForUser(user) {
            attributes[kAttributesPostCountKey] = count
            setAttributes(attributes, forUser: user)
        } else {
            setAttributesForUser(user, postCount: count, followedByCurrentUser: false)
        }
    }
    
    func setFollowStatus(following: Bool, user: PFObject) {
        if var attributes = attributesForUser(user) {
            attributes[kAttributesIsFollowedByCurrentUserKey] = following
            setAttributes(attributes, forUser: user)
        } else {
            setAttributesForUser(user, postCount: 0, followedByCurrentUser: following)
        }
    }
    
    // MARK:- ()
    
    func setAttributes(attributes: [String:AnyObject], forPost post: PFObject) {
        let key: String = self.keyForPost(post)
        cache.setObject(attributes, forKey: key)
    }
    
    func setAttributes(attributes: [String:AnyObject], forUser user: PFObject) {
        let key: String = self.keyForUser(user)
        cache.setObject(attributes, forKey: key)
    }
    
    func keyForPost(post: PFObject) -> String {
        return "post_\(post.objectId)"
    }
    
    func keyForUser(user: PFObject) -> String {
        return "user_\(user.objectId)"
    }
}