//
//  LabelViewWithIcon.swift
//  Think
//
//  Created by denis zaytcev on 8/7/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit


class LabelViewWithIcon: UILabel {
    @IBInspectable weak var iconImage: UIImage!
    @IBInspectable weak var iconColor: UIColor!
    
    @IBInspectable var iconWidth: CGFloat = 0.0
    @IBInspectable var iconHeight: CGFloat = 0.0
    @IBInspectable var iconTop: CGFloat = 0.0
    @IBInspectable var iconLeft: CGFloat = 0.0
    @IBInspectable var iconOffset: CGFloat = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        var iconLayer = CALayer()
        iconLayer.frame = CGRectMake(iconLeft, iconTop, iconWidth, iconHeight)
        iconLayer.contents = iconImage.imageWithColor(iconColor).CGImage
        
        self.layer.addSublayer(iconLayer)
    }
    
    override func drawTextInRect(rect: CGRect) {
        let myLabelInsets = UIEdgeInsets(top: 0, left: iconOffset, bottom: 0, right: 0)
        let newRect = UIEdgeInsetsInsetRect(rect, myLabelInsets)
        super.drawTextInRect(newRect)
    }
}
