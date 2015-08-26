//
//  Installation.swift
//  Think
//
//  Created by denis zaytcev on 8/21/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse


class Installation {

    //включить нотификацию или выключить
    class func unRegisterPushDevice() {
        let install = PFInstallation.currentInstallation()
        install.removeObjectForKey(kInstallationUserKey)
        install.saveInBackground()
    }
    
    class func registerPushDevice() {
        let user = PFUser.currentUser()
        let install = PFInstallation.currentInstallation()
        install.setObject(user!, forKey: kInstallationUserKey)
//        install.addUniqueObject(privateChannelName, forKey: kInstallationChannelsKey)
        install.saveEventually()
    }
    
    class func eventsPush() {
       let install = PFInstallation.currentInstallation()
        install.setObject([kActivityTypeComment, kActivityTypeFollow, kActivityTypeLike], forKey: kInstallationEventsKey)
    }

}