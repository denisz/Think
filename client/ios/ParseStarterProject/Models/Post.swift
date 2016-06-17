//
//  Post.swift
//  Think
//
//  Created by denis zaytcev on 8/15/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import Bolts

class Post: PFObject, PFSubclassing {
    @NSManaged var content  : String
    @NSManaged var title    : String
    @NSManaged var owner    : PFUser
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return kPostClassKey
    }
    
    class func title(post: PFObject) -> String {
        if let title = post[kPostTitleKey] as? String {
            return title
        }
        
        return kPostTitlePlaceholder
    }
    
    class func allowContent(post: PFObject) -> Bool {
        if let settings = Post.settings(post) {
            let user = PFUser.currentUser()

            if let contentAdult = settings[kPostOptAdultContent] as? Bool {
                if contentAdult == true  && UserModel.age(user!) < 18 {
                    return false
                }
            }
        }
        
        return true
    }
    
    class func status(post: PFObject) -> String {
        if let status = post[kPostStatusKey] as? String {
            return status
        }
        
        return kPostStatusDraft
    }
    
    class func coverImage(post: PFObject) -> PFFile? {
        return post[kPostCoverKey] as? PFFile
    }
    
    class func tintColor(post: PFObject) -> UIImage {
        if let hexTintColor = post[kPostTintColor] as? String {
            return UIImage(fromColor: UIColor(hexString: hexTintColor), size: CGSize(width: 320, height: 180))
        }
        
        return kPostPlaceholder!
    }
    
    class func settings(post: PFObject) -> [String: AnyObject]? {
        return post[kPostSettingsKey] as? [String: AnyObject]
    }
    
    class func owner(post: PFObject) -> PFObject? {
        return post[kPostOwnerKey] as? PFObject
    }
    
    class func pictureOwner(post: PFObject) -> PFFile? {
        if let user = post[kPostOwnerKey] as? PFObject {
            return UserModel.pictureImage(user)
        }
        
        return nil
    }
    
    class func shortContent(post: PFObject) -> String {
        if let content = post[kPostContentShortKey] as? String {
            return content
        }
        
        return ""
    }
    
    class func createdAtDate(post: PFObject) -> String {
        return TransformDate.timeString(post.createdAt!)
    }
    
    class func likesCounter(object: PFObject) -> String {
        var count = max(object[kPostCounterLikesKey] as! Int, 0)
        if MyCache.sharedCache.isPostLikedByCurrentUser(object) {
            count++
        }
        
        return "+\(count)"
    }
    
    class func tagsString(object: PFObject) -> String {
        if let tags = object[kPostTagsKey] as? [String] {
            let joiner = " #"
            return "#\(tags.joinWithSeparator(joiner))"
        }
        return ""
    }
    
    class func commentsCounter(object: PFObject, var suffix: String = "") -> String {
        let count = max(object[kPostCounterCommentsKey] as! Int, 0)
        
        if !suffix.isEmpty {
            suffix = " \(suffix)"
        }
        
        return "\(count)\(suffix)"
    }
    
    class func usernameOwner(post: PFObject) -> String {
        if let user = post[kPostOwnerKey] as? PFObject {
            return UserModel.displayname(user)
        }
        
        return kUserHiddenName
    }
    
    class func stringForShare(post: PFObject) -> String {
        if let contentShort = post[kPostContentShortKey] as? String {
            return contentShort
        }
        
        if let contentObj = post[kPostContentShortKey] as? NSArray {
            if let firstBlock = contentObj.firstObject as? [String: String] {
                return firstBlock[kPostBlockTextKey]!.truncate(180, trailing: "...")
            }
        }
        
        return kSharePlaceholder
    }
    
    class func determineCurrentUserAuthor(post: PFObject) -> Bool {
        if let owner = Post.owner(post) {
            return UserModel.isEqualCurrentUser(owner)
        }
        
        return false
    }
    
    class func wasPublishedPost(post: PFObject) -> Bool {
        return Post.status(post) == kPostStatusPublic
    }
    
    class func deletePost(post: PFObject) -> BFTask {
        let user = PFUser.currentUser()
        return post.deleteInBackground().continueWithBlock { (task: BFTask!) -> AnyObject! in
            if task.error == nil {
                MyCache.sharedCache.decrementPostCountForUser(user!)
                NSNotificationCenter.defaultCenter().postNotificationName(kUserDeletePost, object: post)
            }
            
            return task
        }
    }
    
    class func raisePost(post: PFObject) {
        let user = PFUser.currentUser()
        let postACL = PFACL(user: user!)
        postACL.publicReadAccess = false
        post.ACL = postACL
        post.setObject(kPostStatusDraft, forKey: kPostStatusKey)
        post.saveInBackground().continueWithBlock { (task: BFTask!) -> AnyObject! in
            if task.error == nil {
                NSNotificationCenter.defaultCenter().postNotificationName(kUserRaisePost, object: post)
            }
            
            return task
        }
    }
    
    class func publicPost(post: PFObject, var withSettings: [String: AnyObject]) -> BFTask {
        let user = PFUser.currentUser()
        let postACL = PFACL(user: user!)
        postACL.publicReadAccess = true
        post.ACL = postACL
        
        if let tags = withSettings[kPostTagsKey] as? [String] {
            post.setObject(tags, forKey: kPostTagsKey)
            withSettings.removeValueForKey(kPostTagsKey)
        }
        
        post.setObject(withSettings, forKey: kPostSettingsKey)
        post.setObject(kPostStatusPublic, forKey: kPostStatusKey)
        
        return post.saveInBackground().continueWithBlock({ (task: BFTask!) -> AnyObject! in
            MyCache.sharedCache.incrementPostCountForUser(user!)
            NSNotificationCenter.defaultCenter().postNotificationName(kUserPublicPost, object: post)
            return task
        })
    }
    
    class func createWith() -> PFObject {
        let post = PFObject(className: kPostClassKey)
        let user = PFUser.currentUser()
        post.ACL = PFACL(user: user!)
        post.setObject(user!,               forKey: kPostOwnerKey)
        post.setObject(0,                   forKey: kPostCounterCommentsKey)
        post.setObject(0,                   forKey: kPostCounterLikesKey)
        post.setObject(kPostStatusDraft,    forKey: kPostStatusKey)
        
        return post
    }
}
