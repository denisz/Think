//
//  JSONParse.swift
//  Think
//
//  Created by denis zaytcev on 8/19/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation

extension String {
    var parseJSONString: AnyObject? {
        
        let data = self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        
        if let jsonData = data {
            // Will return an object or nil if JSON decoding fails
            return NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers, error: nil)
        } else {
            // Lossless conversion of the string was not possible
            return nil
        }
    }
}

func JSONParse(data: String) -> AnyObject? {
    return data.parseJSONString
}