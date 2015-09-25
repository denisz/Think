//
//  UITextField+borderBottom.swift
//  Think
//
//  Created by denis zaytcev on 8/6/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {

    func borderBottom(color: UIColor) {
        
        if iOS7 {
            let bottomBorder = CALayer()
            bottomBorder.frame = CGRectMake(0.0, self.frame.size.height - 1, self.frame.size.width, 1.0);
            bottomBorder.backgroundColor = color.CGColor
            self.layer.addSublayer(bottomBorder)
        } else {
            self.backgroundColor = UIColor.clearColor()
            
            let menuBottomHairline: UIView = UIView()
            
            menuBottomHairline.translatesAutoresizingMaskIntoConstraints = false
            
            self.addSubview(menuBottomHairline)
            
            let menuBottomHairline_constraint_H:Array = NSLayoutConstraint.constraintsWithVisualFormat("H:|[menuBottomHairline]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["menuBottomHairline":menuBottomHairline])
            let menuBottomHairline_constraint_V:Array = NSLayoutConstraint.constraintsWithVisualFormat("V:[menuBottomHairline(0.5)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["menuBottomHairline":menuBottomHairline])
            
            self.addConstraints(menuBottomHairline_constraint_H)
            self.addConstraints(menuBottomHairline_constraint_V)
            
            menuBottomHairline.backgroundColor = color
        }        
    }
}