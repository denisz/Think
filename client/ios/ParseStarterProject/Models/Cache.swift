//
//  Cache.swift
//  Think
//
//  Created by denis zaytcev on 8/16/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation


class Cache {
    class var sharedInstance: Cache {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: Cache? = nil
        }
        
        dispatch_once(&Static.onceToken) {
            Static.instance = Cache()
        }
        
        return Static.instance!
    }
    
    init() {
        
    }
    
    func setFollowingUsers(users: [String]) {
        
    }
}