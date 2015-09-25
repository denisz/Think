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
    
    @IBInspectable var iconWidth:   CGFloat = 0.0
    @IBInspectable var iconHeight:  CGFloat = 0.0
    @IBInspectable var iconTop:     CGFloat = 0.0
    @IBInspectable var iconLeft:    CGFloat = 0.0
    @IBInspectable var iconOffset:  CGFloat = 0.0
    
    var _iconLayer: CALayer?
    var _iconImage: UIImage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.definePositionX()
        
        let iconLayer = CALayer()
        iconLayer.frame = CGRectMake(iconLeft, iconTop, iconWidth, iconHeight)
        iconLayer.contents = iconImage.imageWithColor(iconColor).CGImage
        
        self.layer.addSublayer(iconLayer)
        self._iconLayer = iconLayer
        self._iconImage = iconImage
    }
    
    func setColor(color: UIColor) {
        if let iconLayer = self._iconLayer {
            if let iconImage = self._iconImage {
                iconLayer.contents = iconImage.imageWithColor(color).CGImage
            }
        }
        
        self.textColor = color
    }
    
    func definePositionX() {
        let align = self.textAlignment;
        var newIconLeft: CGFloat = 0
        
        switch(align) {
        case .Center:
            let expectedLabelSize = self.getSizeTextWithAttributes()
            newIconLeft = (CGRectGetWidth(self.frame) / 2) - (expectedLabelSize.width / 2) - iconWidth / 2
            break
        case .Right:
            let expectedLabelSize = self.getSizeTextWithAttributes()
            newIconLeft = CGRectGetWidth(self.frame) - expectedLabelSize.width - iconWidth - 5
            break
        default:
            newIconLeft = iconLeft
        }
        
        iconLeft = newIconLeft
    }
    
    func getSizeTextWithAttributes() -> CGSize {
        let attributes = [
            NSFontAttributeName: self.font
        ]
        return self.text!.sizeWithAttributes(attributes)
    }
    
    override func drawTextInRect(rect: CGRect) {
        let myLabelInsets = UIEdgeInsets(top: 0, left: iconOffset, bottom: 0, right: 0)
        let newRect = UIEdgeInsetsInsetRect(rect, myLabelInsets)
        super.drawTextInRect(newRect)
    }
}
