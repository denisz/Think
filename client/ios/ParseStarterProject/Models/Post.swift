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
    
    class func publicPost(post: PFObject, withSettings: [String: AnyObject]) -> BFTask {
        let user = PFUser.currentUser()
        var postACL = PFACL(user: user!)
        postACL.setPublicReadAccess(true)
        post.ACL = postACL
        post.setObject(withSettings, forKey: kPostSettingsKey)
        
        return post.saveInBackground().continueWithBlock({ (task: BFTask!) -> AnyObject! in
            
            if task.error != nil {
                
            } else {
                //сделать активность о создании поста
                
            }
            
            return nil
        })
    }
    
    class func createWith() -> PFObject {
        let post = PFObject(className: kPostClassKey)
        let user = PFUser.currentUser()
        post.ACL = PFACL(user: user!)
        post.setObject(user!,   forKey: kPostOwnerKey)
        post.setObject(0, forKey: kPostCounterCommentsKey)
        post.setObject(0, forKey: kPostCounterLikesKey)
        
        return post
    }
    
    class func createWith(title: String, content: String) -> BFTask {
        var post = Post.createWith()
        
        post.setObject(title,   forKey: kPostTitleKey)
        post.setObject(content, forKey: kPostContentKey)
        
        return post.saveInBackground()
    }
}
