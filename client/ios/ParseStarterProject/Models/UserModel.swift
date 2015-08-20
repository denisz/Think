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
}