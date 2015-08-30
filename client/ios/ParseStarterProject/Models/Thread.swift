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
    
    class func lastMessage(thread: PFObject) -> PFObject? {
        return thread[kThreadLastMessageKey] as? PFObject
    }
    
    class func participants(thread: PFObject) -> [PFObject] {
        var result = [PFObject]()
        if let participants = thread[kThreadParticipantsKey] as? [String] {
            for objectId in participants {
                result.append(PFObject(withoutDataWithClassName: kUserClassKey, objectId: objectId))
            }
        }
        
        return result
    }
    
    class func participant(thread: PFObject) -> PFObject? {
        let participants = Thread.participants(thread)
        
        for user in participants {
            if !UserModel.isEqualCurrentUser(user) {
                return user
            }
        }
        
        return nil
    }
    
    class func findExistsThread(otherUser: PFObject) -> BFTask {
        let source          = BFTaskCompletionSource()
        let query = PFQuery(className: kThreadClassKey)
        query.whereKey(kThreadParticipantsKey, equalTo: otherUser.objectId!)
        
        query.getFirstObjectInBackgroundWithBlock { (thread: PFObject?, error: NSError?) -> Void in
            if error == nil {
                source.setResult(thread)
            } else {
                source.setError(error)
            }
        }
        
        return source.task
    }
    
    //возможно стоит сделать блокирующим
    class func createWithOtherUser(otherUser: PFObject) -> BFTask {
        let source          = BFTaskCompletionSource()
        
        findExistsThread(otherUser).continueWithBlock { (task: BFTask!) -> AnyObject! in
            if task.error == nil {
                source.setError(task.error)
            } else {
                if let thread = task.result as? PFObject {
                    source.setResult(thread)
                } else {
                    let currentUser     = PFUser.currentUser()
                    let participants    = [currentUser!.objectId!, otherUser.objectId!]
                    let thread          = PFObject(className: kThreadClassKey)
                    thread.setObject(participants, forKey: kThreadParticipantsKey)
                    
                    let threadACL = PFACL(user: currentUser!)
                    threadACL.setReadAccess(true, forUserId: otherUser.objectId!)
                    threadACL.setWriteAccess(true, forUserId: otherUser.objectId!)
                    thread.ACL = threadACL
                    //сделать поиск
                    
                    thread.saveInBackground().continueWithBlock { (task: BFTask!) -> AnyObject! in
                        if task.error == nil {
                            source.setResult(thread)
                            NSNotificationCenter.defaultCenter().postNotificationName(kUserCreateThread, object: thread)
                        } else {
                            source.setError(task.error)
                        }
                        
                        return task
                    }
                }
            }
            
            return task
        }
        
        return source.task
    }
}