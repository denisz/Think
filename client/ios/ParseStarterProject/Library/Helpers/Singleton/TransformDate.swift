//
//  ParseDate.swift
//  Think
//
//  Created by denis zaytcev on 8/20/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation


class TransformDate {
    class func dateFromString(stringDate: String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC");
        return  dateFormatter.dateFromString(stringDate)!
    }
    
    class func timeString(stringDate: String) -> String {
        return timeString(dateFromString(stringDate))
    }
    
    class func timeString(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.doesRelativeDateFormatting = true

        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .NoStyle
        return dateFormatter.stringFromDate(date)
    }
    
    class func relativeDateString(stringDate: String) -> String {
       return relativeDateString(dateFromString(stringDate))
    }
    
    class func relativeDateString(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.doesRelativeDateFormatting = true

        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .NoStyle
        return dateFormatter.stringFromDate(date)
    }
}