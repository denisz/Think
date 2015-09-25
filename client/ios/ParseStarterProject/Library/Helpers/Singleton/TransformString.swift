//
//  TransformString.swift
//  Think
//
//  Created by denis zaytcev on 8/22/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse

class TransformString {
    
    class func likesCounter(object: PFObject) -> String {
        let count = max(object[kPostCounterLikesKey] as! Int, 0)
        return "+\(count)"
    }
    
    class func commentsCounter(object: PFObject, var suffix: String = "") -> String {
        let count = max(object[kPostCounterCommentsKey] as! Int, 0)
        
        if !suffix.isEmpty {
            suffix = " \(suffix)"
        }
        
        return "\(count)\(suffix)"
    }
    
}