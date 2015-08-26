//
//  Thread.swift
//  Think
//
//  Created by denis zaytcev on 8/25/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import Bolts

class Thread:  PFObject, PFSubclassing {
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return kThreadClassKey
    }
    
    
    class func createWithOtherUser(otherUser: PFObject) -> PFObject {
        let currentUser = PFUser.currentUser()
        let participants = [currentUser!, otherUser]
        let thread = PFObject(className: kThreadClassKey)
        thread.setObject(participants, forKey: kThreadParticipantsKey)
        
        thread.saveInBackground().continueWithBlock { (task: BFTask!) -> AnyObject! in
            if task.error == nil {
                NSNotificationCenter.defaultCenter().postNotificationName(kUserCreateThread, object: thread)
            }
            
            return task
        }
    
        return thread
    }
}