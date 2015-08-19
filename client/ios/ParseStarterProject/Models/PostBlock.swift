//
//  PostBlock.swift
//  Think
//
//  Created by denis zaytcev on 8/19/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse

let kvoBlockPropertyStyle = "styleRaw"

enum PostBlockType: Int {
    case Text
    case Title
    case Picture
    case Cover
    case Unknown
}

class PostBlock: NSObject {
    var type: PostBlockType
    dynamic var content: String = ""
    dynamic var picture: PFFile?
    dynamic var styleRaw : String?
    var style : PostBlockStyle? {
        didSet {
            styleRaw = style?.rawValue
        }
    }
    
    init(type: PostBlockType) {
        self.type  = type
        self.style = .Default
    }
    
    func fromObject(dict: [String: String]) {
        self.content  = dict[kPostBlockTextKey]!
        //подумать по picture
        self.style    = PostBlockStyle(rawValue: dict[kPostBlockStyleKey]!)!
    }
    
    var textColor: UIColor {
        let style = attributesStyles(self.style!)
        return style.1
    }
    
    var backgroundColor: UIColor {
        let style = attributesStyles(self.style!)
        return style.0
    }
    
    func toObject() -> [String: String] {
        let dict = [
            kPostBlockTextKey: self.content,
            kPostBlockStyleKey: self.style!.rawValue as String
            
        ] as [String: String]
        
        return dict
    }
}