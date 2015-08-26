//
//  User.swift
//  Think
//
//  Created by denis zaytcev on 8/20/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import ParseUI


class UserModel: PFUser {

    class func isEqualCurrentUser(object: PFObject) -> Bool {
        var currentUser = PFUser.currentUser()
        return currentUser!.objectId!.hash == object.objectId!.hash
    }
    
    class func Anonymous() -> Bool {
        return PFAnonymousUtils.isLinkedWithUser(PFUser.currentUser())
    }
    
    class func username(user: PFObject) -> String {
        if let name = user[kUserUsernameKey] as? String {
            return name.uppercaseString
        }
        
        return kUserHiddenName
    }

    class func pictureImage(user: PFObject) -> PFFile? {
        if let picture = user[kUserProfilePictureKey] as? PFFile {
            return picture
        }
        
        return  nil
    }
    
    class func coverImage(user: PFObject) -> PFFile? {
        if let picture = user[kUserProfileCoverKey] as? PFFile {
            return picture
        }
        
        return  nil
    }

}