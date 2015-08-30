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
    
    class func country(user: PFObject) -> String {
        if let country = user[kUserCountryKey] as? String {
            return country
        }
        
        return ""
    }
    
    class func city(user: PFObject) -> String {
        if let city = user[kUserCityKey] as? String {
            return city
        }
        
        return ""
    }
    
    class func age(user: PFObject) -> Int {
        if let birthday = user[kUserDateOfBirthKey] as? NSDate {
            let now = NSDate()
            var calendar : NSCalendar = NSCalendar.currentCalendar()
            let ageComponents = calendar.components(.CalendarUnitYear,
                fromDate: birthday,
                toDate: now,
                options: nil)
            
            return ageComponents.year
        }
        
        return 0
    }
    
    class func displayname(user: PFObject) -> String {
        if let name = user[kUserDisplayNameKey] as? String {
            return name.uppercaseString
        }
        
        return kUserHiddenName
    }
    
    class func username(user: PFObject) -> String {
        if let name = user[kUserUsernameKey] as? String {
            return name.uppercaseString
        }
        
        return kUserHiddenName
    }
    
    class func createdAtDate(post: PFObject) -> String {
        return TransformDate.timeString(post.createdAt!)
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