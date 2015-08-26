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
    
    class func sendMessage(thread: PFObject, toUser: PFObject, message: String) {
        let fromUser    = PFUser.currentUser()
        let message     = PFObject(className: kMessageClassKey)
        
        message.setObject(thread,       forKey: kMessageThreadKey)
        message.setObject(toUser,       forKey: kMessageToUserKey)
        message.setObject(fromUser!,    forKey: kMessageFromUserKey)
        message.setObject(message,      forKey: kMessageContentKey)
        
        thread.setObject(message, forKey: kThreadLastMessageKey)
        
//        thread.saveInBackground()
        message.saveInBackground()
    }
    
    class func sendMessage(thread: PFObject, toUser: PFObject, picture: PFFile) {
        let fromUser    = PFUser.currentUser()
        let message     = PFObject(className: kMessageClassKey)
        
        message.setObject(thread,       forKey: kMessageThreadKey)
        message.setObject(toUser,       forKey: kMessageToUserKey)
        message.setObject(fromUser!,    forKey: kMessageFromUserKey)
        message.setObject(picture,      forKey: kMessagePictureKey)
        
        thread.setObject(message, forKey: kThreadLastMessageKey)
        
        //        thread.saveInBackground()
        message.saveInBackground()
    }

}