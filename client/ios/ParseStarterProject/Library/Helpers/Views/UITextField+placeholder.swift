//
//  UITextField+placeholder.swift
//  Think
//
//  Created by denis zaytcev on 8/6/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit


extension UITextField {
    func changeColorPlaceholder(placeholderColor: UIColor?) {
        var color  = UIColor.whiteColor()
        if let userColor = placeholderColor {
            color = userColor
        }
        
        if let textPlaceholder = self.placeholder {
            self.attributedPlaceholder = NSAttributedString(string:textPlaceholder,
                attributes:[NSForegroundColorAttributeName: color])
        }
    }
}

