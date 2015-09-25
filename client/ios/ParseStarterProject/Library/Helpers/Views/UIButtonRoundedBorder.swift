//
//  UIButtonRoundedBorder.swift
//  Think
//
//  Created by denis zaytcev on 8/9/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit


class UIButtonRoundedBorder: UIButton {
    @IBInspectable var borderRadius: CGFloat = 0.0
    @IBInspectable var borderWidth: CGFloat = 1.0
    @IBInspectable weak var borderColor: UIColor!
    @IBInspectable weak var imageColor: UIColor!
    @IBInspectable weak var imageColorSelected: UIColor!
    
    @IBInspectable weak var backgroundColorDefault: UIColor!
    @IBInspectable weak var backgroundColorSelected: UIColor!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let image = self.imageView?.image
        self.setImage(image?.imageWithColor(imageColor), forState: UIControlState.Normal)
        self.setImage(image?.imageWithColor(imageColorSelected), forState: UIControlState.Selected)

        drawBorderRadius(borderColor.CGColor)
    }
    
    func selectedOnSet(state: Bool) {
        if state == true {
            self.backgroundColor = backgroundColorSelected
        } else {
            self.backgroundColor = backgroundColorDefault
        }
        
        self.selected = state
    }
    
    func drawBorderRadius(color: CGColor) {
        self.backgroundColor = backgroundColorDefault
        self.layer.cornerRadius = borderRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = color
    }
}