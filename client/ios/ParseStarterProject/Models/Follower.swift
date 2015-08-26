//
//  Follower.swift
//  Think
//
//  Created by denis zaytcev on 8/26/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import ParseUI


class Follower {
    //я слежу за пользователем
    class func followingUsername(activity: PFObject) -> String {
        if let user = activity[kActivityToUserKey] as? PFObject {
            return UserModel.username(user)
        }
        
        return kUserHiddenName
    }
    
    class func followingPicture(activity: PFObject) -> PFFile? {
        if let user = activity[kActivityToUserKey] as? PFObject {
            return UserModel.pictureImage(user)
        }
        
        return nil
    }
    
    //кто следит за мной
    class func followerUsername(activity: PFObject) -> String {
        if let user = activity[kActivityFromUserKey] as? PFObject {
            return UserModel.username(user)
        }
        
        return kUserHiddenName
    }
    
    class func followerPicture(activity: PFObject) -> PFFile? {
        if let user = activity[kActivityFromUserKey] as? PFObject {
            return UserModel.pictureImage(user)
        }
        
        return nil
    }
    
    class func createdAtDate(activity: PFObject) -> String {
        return TransformDate.timeString(activity.createdAt!)
    }
}