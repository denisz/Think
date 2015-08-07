//
//  LineButton.swift
//  Think
//
//  Created by denis zaytcev on 8/6/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit


extension UIButton {
   func borderBottom () {
        let border = CALayer()
        let thickness = CGFloat(1.0)
        
        border.backgroundColor = self.tintColor!.CGColor
        border.frame = CGRectMake(0, CGRectGetHeight(self.frame) - thickness, CGRectGetWidth(self.frame), thickness)
        
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    func cornerEdge() {
        self.layer.cornerRadius = CGRectGetHeight(self.frame) * 0.5
        self.layer.masksToBounds = true
    }
}