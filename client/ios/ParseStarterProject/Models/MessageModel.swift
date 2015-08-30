//
//  Message.swift
//  Think
//
//  Created by denis zaytcev on 8/25/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import Bolts


class MessageModel: PFObject, PFSubclassing {
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return kMessageClassKey
    }
    
    class func thread(message: PFObject) -> PFObject? {
        return message[kMessageThreadKey] as? PFObject
    }
    
    class func determineCurrentUserAuthor(message: PFObject) -> Bool {
        if let owner = MessageModel.owner(message) {
            return UserModel.isEqualCurrentUser(owner)
        }
        
        return false
    }
    
    class func content(message: PFObject) -> String {
        if let content = message[kMessageContentKey] as? String {
            return content
        }
        
        return ""
    }
    
    class func owner(message: PFObject) -> PFObject? {
        return message[kMessageFromUserKey] as? PFObject
    }
    
    class func ownerPicture(message: PFObject) -> PFFile? {
        if let user = MessageModel.owner(message) {
            return UserModel.pictureImage(user)
        }
        
        return nil
    }

    class func ownerUsername(message: PFObject) -> String {
        if let user = MessageModel.owner(message) {
            return UserModel.username(user)
        }
        
        return kUserHiddenName
    }

    class func createdAtDate(message: PFObject) -> String {
        return TransformDate.timeString(message.createdAt!)
    }
    
    class func sendMessage(thread: PFObject, toUser: PFObject, content: String) {
        let fromUser    = PFUser.currentUser()
        let message     = PFObject(className: kMessageClassKey)
        
        message.setObject(thread,       forKey: kMessageThreadKey)
        message.setObject(fromUser!,    forKey: kMessageFromUserKey)
        message.setObject(content,      forKey: kMessageContentKey)
        message.setObject(toUser,       forKey: kMessageToUserKey)
        
        let messageACL = PFACL(user: fromUser!)
        messageACL.setReadAccess(true, forUserId: toUser.objectId!)
        message.ACL = messageACL
        
        message.saveInBackground().continueWithBlock { (task: BFTask!) -> AnyObject! in
            if task.error == nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    NSNotificationCenter.defaultCenter().postNotificationName(kUserSendMessage, object: message)
                })
                thread.setObject(message, forKey: kThreadLastMessageKey)
                thread.saveInBackground()
            } else {
                //ошибка
            }
            return task
        }
    }
    
    class func sendMessage(thread: PFObject, toUser: PFObject, picture: PFFile) {
        let fromUser    = PFUser.currentUser()
        let message     = PFObject(className: kMessageClassKey)
        
        message.setObject(thread,       forKey: kMessageThreadKey)
        message.setObject(fromUser!,    forKey: kMessageFromUserKey)
        message.setObject(picture,      forKey: kMessagePictureKey)
        message.setObject(toUser,       forKey: kMessageToUserKey)
        
        
        let messageACL = PFACL(user: fromUser!)
        messageACL.setWriteAccess(true, forUserId: toUser.objectId!)
        message.ACL = messageACL
        
        message.saveInBackground().continueWithBlock { (task: BFTask!) -> AnyObject! in
            println(task.error)
            if task.error == nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    NSNotificationCenter.defaultCenter().postNotificationName(kUserSendMessage, object: message)
                })
                thread.setObject(message, forKey: kThreadLastMessageKey)
                thread.saveInBackground()
            }
            
            return task
        }
    }

}