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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        var image = self.imageView?.image
        self.setImage(image?.imageWithColor(imageColor), forState: UIControlState.Normal)
        
        drawBorderRadius()
    }
    
    func drawBorderRadius() {
        self.backgroundColor = UIColor.clearColor()
        self.layer.cornerRadius = borderRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.CGColor
    }
}