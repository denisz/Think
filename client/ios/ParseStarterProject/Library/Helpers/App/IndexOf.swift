//
//  IndexOf.swift
//  Think
//
//  Created by denis zaytcev on 8/29/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse

func IndexOf (arr: NSMutableArray, object: PFObject) -> Int {
    let len = arr.count
    let id = object.objectId!
    
    for (var idx = 0; idx < len; idx++) {
        if let item = arr[idx] as? PFObject {
            if item.objectId! == id {
                return idx
            }
        }
    }
    
    return -1
}