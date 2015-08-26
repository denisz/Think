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
        
        return ""
    }
    
    class func coverImage(post: PFObject) -> PFFile? {
        if let cover = post[kPostCoverKey] as? PFFile {
            return cover
        }
        
        return nil
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
        return "+\(count)"
    }
    
    class func tagsString(object: PFObject) -> String {
        if let tags = object[kPostTagsKey] as? [String] {
            let joiner = " #"
            return "#\(joiner.join(tags))"
        }
        return ""
    }
    
    class func commentsCounter(object: PFObject, var suffix: String = "") -> String {
        var count = max(object[kPostCounterCommentsKey] as! Int, 0)
        
        if !suffix.isEmpty {
            suffix = " \(suffix)"
        }
        
        return "\(count)\(suffix)"
    }
    
    class func usernameOwner(post: PFObject) -> String {
        if let user = post[kPostOwnerKey] as? PFObject {
            return UserModel.username(user)
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
        
        return "Post in \(kAppName)"
    }
    
    
    class func determineCurrentUserAuthor(post: PFObject) -> Bool {
        let user = PFUser.currentUser()!
        if let owner = post[kPostOwnerKey] as? PFObject {
            return owner.objectId!.hash == user.objectId!.hash
        }
        
        return false
    }
    
    class func raisePost(post: PFObject) {
        let user = PFUser.currentUser()
        let postACL = PFACL(user: user!)
        postACL.setPublicReadAccess(false)
        post.ACL = postACL
        post.setObject(kPostStatusDraft, forKey: kPostStatusKey)
        
        NSNotificationCenter.defaultCenter().postNotificationName(kUserRaisePost, object: post)
    }
    
    class func publicPost(post: PFObject, var withSettings: [String: AnyObject]) -> BFTask {
        let user = PFUser.currentUser()
        let postACL = PFACL(user: user!)
        postACL.setPublicReadAccess(true)
        post.ACL = postACL
        
        if let tags = withSettings[kPostTagsKey] as? [String] {
            post.setObject(tags, forKey: kPostTagsKey)
            withSettings.removeValueForKey(kPostTagsKey)
        }
        
        post.setObject(withSettings, forKey: kPostSettingsKey)
        post.setObject(kPostStatusPublic, forKey: kPostStatusKey)
        
        return post.saveInBackground()
    }
    
    class func createWith() -> PFObject {
        let post = PFObject(className: kPostClassKey)
        let user = PFUser.currentUser()
        post.ACL = PFACL(user: user!)
        post.setObject(user!,   forKey: kPostOwnerKey)
        post.setObject(0, forKey: kPostCounterCommentsKey)
        post.setObject(0, forKey: kPostCounterLikesKey)
        post.setObject(kPostStatusDraft, forKey: kPostStatusKey)
        
        return post
    }
}
