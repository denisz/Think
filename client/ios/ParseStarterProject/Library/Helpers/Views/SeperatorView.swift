//
//  Seperator.swift
//  GPSTrakcing
//
//  Created by denis zaytcev on 5/9/15.
//  Copyright (c) 2015 denis zaytcev. All rights reserved.
//

import Foundation
import UIKit

class SeperatorView: UIView {
    @IBInspectable var dicrectionHorizontal: Bool = true
    @IBInspectable var dicrectionVertical: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clearColor()
        
        let menuBottomHairline: UIView = UIView()
        
        menuBottomHairline.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(menuBottomHairline)
        
        var menuBottomHairline_constraint_H: [NSLayoutConstraint]
        var menuBottomHairline_constraint_V: [NSLayoutConstraint]
        
        if dicrectionVertical == true {
            menuBottomHairline_constraint_H = NSLayoutConstraint.constraintsWithVisualFormat("H:[menuBottomHairline(0.5)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["menuBottomHairline":menuBottomHairline])
            menuBottomHairline_constraint_V = NSLayoutConstraint.constraintsWithVisualFormat(
                "V:|[menuBottomHairline]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["menuBottomHairline":menuBottomHairline])
        } else {
            menuBottomHairline_constraint_H = NSLayoutConstraint.constraintsWithVisualFormat("H:|[menuBottomHairline]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["menuBottomHairline":menuBottomHairline])
            menuBottomHairline_constraint_V = NSLayoutConstraint.constraintsWithVisualFormat("V:|[menuBottomHairline(0.5)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["menuBottomHairline":menuBottomHairline])
        }
        
        self.addConstraints(menuBottomHairline_constraint_H)
        self.addConstraints(menuBottomHairline_constraint_V)
        
        menuBottomHairline.backgroundColor = self.tintColor
    }
    
    
    class func addHairline(view: UIView) {
        if let _ = view.viewWithTag(1200) {
            return
        }
        
        let menuBottomHairline: UIView = UIView()
        menuBottomHairline.tag = 1200
        
        menuBottomHairline.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(menuBottomHairline)
        
        let menuBottomHairline_constraint_H:Array = NSLayoutConstraint.constraintsWithVisualFormat("H:|[menuBottomHairline]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["menuBottomHairline":menuBottomHairline])
        let menuBottomHairline_constraint_V:Array = NSLayoutConstraint.constraintsWithVisualFormat("V:[menuBottomHairline(0.5)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["menuBottomHairline":menuBottomHairline])
        
        view.addConstraints(menuBottomHairline_constraint_H)
        view.addConstraints(menuBottomHairline_constraint_V)
        
        menuBottomHairline.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.8)
    }
}

