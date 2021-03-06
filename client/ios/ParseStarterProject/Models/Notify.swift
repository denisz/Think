//
//  Notify.swift
//  Think
//
//  Created by denis zaytcev on 8/26/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import ParseUI

class Notify {
    class func createdAtDate(notify: PFObject) -> String {
        return TransformDate.timeString(notify.createdAt!)
    }
    
    class func owner(notify: PFObject) -> PFObject? {
        return notify[kActivityFromUserKey] as? PFObject
    }
    
    class func ownerPicture(notify: PFObject) -> PFFile? {
        if let user = Notify.owner(notify) {
            return UserModel.pictureImage(user)
        }
    
        return nil
    }
    
    class func ownerUsername(notify: PFObject) -> String {
        if let user = Notify.owner(notify) {
            return UserModel.displayname(user)
        }
        
        return kUserHiddenName
    }
    
    class func description(notify: PFObject) -> String {
        if let type = notify[kActivityTypeKey] as? String {
        
            switch type {
            case kActivityTypeComment:
                return "commented on your post"
            case kActivityTypeFollow:
                return "is now following you"
            case kActivityTypeLike:
                return "liked your post"
            default:
                return ""
            
            }
        }
        return ""
    }
    
    class func icon(notify: PFObject) -> UIImage {
        if let type = notify[kActivityTypeKey] as? String {
            switch type {
            case kActivityTypeComment:
                return kIconNotifyCommentPlaceholder!
            case kActivityTypeFollow:
                return kIconNotifyFollowPlaceholder!
            case kActivityTypeLike:
                return kIconNotifyLikePlaceholder!
            default:
                return kIconNotifyLikePlaceholder!
            }
        }
        
        return kIconNotifyLikePlaceholder!
    }
    
    
}