//
//  Comment.swift
//  Think
//
//  Created by denis zaytcev on 8/25/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import ParseUI


class Comment: NSObject {
    class func owner(comment: PFObject) -> PFObject? {
        return comment[kActivityFromUserKey] as? PFObject
    }
    
    class func ownerName(comment: PFObject) -> String {
        if let user = Comment.owner(comment) {
            return UserModel.displayname(user)
        }
        
        return kUserHiddenName
    }
    
    class func createdAtDate(comment: PFObject) -> String {
        return TransformDate.timeString(comment.createdAt!)
    }

    class func content(comment: PFObject) -> String {
        if let content = comment[kActivityContentKey] as? String {
            return content
        }
        
        return ""
    }
    
    class func pictureOwner(comment: PFObject) -> PFFile? {
        if let user = Comment.owner(comment) {
            return UserModel.pictureImage(user)
        }
        
        return nil
    }

}