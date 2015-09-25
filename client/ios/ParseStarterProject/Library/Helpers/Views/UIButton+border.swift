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
    func borderBottom(color: UIColor) {
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
    
    func borderLeft(color: UIColor) {
        self.backgroundColor = UIColor.clearColor()
        
        let menuBottomHairline: UIView = UIView()
        
        menuBottomHairline.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(menuBottomHairline)
        
        let menuBottomHairline_constraint_H:Array = NSLayoutConstraint.constraintsWithVisualFormat("H:[menuBottomHairline(0.5)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["menuBottomHairline":menuBottomHairline])
        let menuBottomHairline_constraint_V:Array = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[menuBottomHairline]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["menuBottomHairline":menuBottomHairline])
        
        self.addConstraints(menuBottomHairline_constraint_H)
        self.addConstraints(menuBottomHairline_constraint_V)
        
        menuBottomHairline.backgroundColor = color
    }
}