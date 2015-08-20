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
    
    class func raisePost(post: PFObject) -> BFTask {
        let user = PFUser.currentUser()
        let postACL = PFACL(user: user!)
        postACL.setPublicReadAccess(false)
        post.ACL = postACL
        post.setObject(kPostStatusDraft, forKey: kPostStatusKey)
        
        return post.saveInBackground()
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
    
    class func createWith(title: String, content: String) -> BFTask {
        let post = Post.createWith()
        post.setObject(title,   forKey: kPostTitleKey)
        post.setObject(content, forKey: kPostContentKey)
        
        return post.saveInBackground()
    }
}
