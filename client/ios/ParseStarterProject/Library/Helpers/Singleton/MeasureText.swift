//
//  MeasureText.swift
//  Think
//
//  Created by denis zaytcev on 9/1/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation

class MeasureText {
    class func heightForText(text:String, font:UIFont, width:CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
}
