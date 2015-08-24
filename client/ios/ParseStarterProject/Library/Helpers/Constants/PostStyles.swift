//
//  PostStyles.swift
//  Think
//
//  Created by denis zaytcev on 8/19/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation

//(backgroundColor, textColor)
func attributesStyles(style: PostBlockStyle) -> (UIColor, UIColor) {
    return kPostBlockStyles[style]!
}

enum PostBlockStyle: String {
    case Default    = "1"
    case Gray       = "2"
    
    static let allValues = [Default, Gray]
}

let kPostBlockStyles = [
        .Default: kStyleDefault,
        .Gray   : kStyleGray
    ] as [PostBlockStyle: (UIColor, UIColor)]

let kStyleGray = (UIColor(red:0.33, green:0.39, blue:0.42, alpha:1), UIColor.whiteColor()) as (UIColor, UIColor)
let kStyleDefault = (UIColor.whiteColor(), UIColor(red:0.2, green:0.2, blue:0.2, alpha:1)) as (UIColor, UIColor)
