//
//  JSONStringify.swift
//  Think
//
//  Created by denis zaytcev on 8/19/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation

func JSONStringify(value: AnyObject, prettyPrinted:Bool = false) -> String{
    
    let options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : NSJSONWritingOptions(rawValue: 0)
    
    if NSJSONSerialization.isValidJSONObject(value) {
        var error: NSError? = nil
        let data = NSJSONSerialization.dataWithJSONObject(value, options: options, error: &error)
        if (error == nil) {
            if let string = NSString(data: data!, encoding: NSUTF8StringEncoding) {
                return string as String
            }
        }
    }
    return ""
}
