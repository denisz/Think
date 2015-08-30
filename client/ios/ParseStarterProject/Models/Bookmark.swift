//
//  Bookmark.swift
//  Think
//
//  Created by denis zaytcev on 8/15/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import Bolts

class Bookmark: PFObject, PFSubclassing {
    @NSManaged var user  : PFUser
    @NSManaged var post  : PFObject
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    
    class func post(bookmark: PFObject) ->PFObject? {
        return bookmark[kBookmarkPostKey] as? PFObject
    }
    
    static func parseClassName() -> String {
        return kBookmarkClassKey
    }
    
    class func createWith(post: PFObject) -> BFTask {
        let bookmark = PFObject(className: kBookmarkClassKey)
        let user = PFUser.currentUser()
        
        bookmark.setObject(user!, forKey: kBookmarkUserKey)
        bookmark.setObject(post,  forKey: kBookmarkPostKey)
        
        return bookmark.saveInBackground()
    }
}
