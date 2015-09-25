//
//  BaseUIView.swift
//  Think
//
//  Created by denis zaytcev on 8/13/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit

class BaseUIView: UIView {
    var view: UIView!
    
    var nibName: String? {
        return nil
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        if let view = loadViewFromNib() {
            view.frame = bounds
            view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
            addSubview(view)
            
            self.view = view
            self.userInteractionEnabled = true
            viewDidLoad()
        }
    }
    
    func loadViewFromNib() -> UIView? {
        if let nibName = self.nibName {
            let bundle = NSBundle(forClass: self.dynamicType)
            let nib = UINib(nibName: nibName, bundle: bundle)
            let view = nib.instantiateWithOwner(self, options: nil).first as! UIView
            return view
        }
        
        return nil
    }
    
    func viewDidLoad() {}
    
    
    class func constraintToFit(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let views = ["view": view]
        let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: .AlignAllCenterY, metrics: nil, views: views)
        let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: .AlignAllCenterX, metrics: nil, views: views)
        
        view.superview?.addConstraints(hConstraints)
        view.superview?.addConstraints(vConstraints)
    }
    
    class func constraintToTop(view: UIView, size: CGSize, offset: CGFloat) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let views   = ["view": view]
        let metrics = ["height": size.height, "top": offset ]
        
        let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: .AlignAllCenterY, metrics: nil, views: views)
        let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-(top)-[view(height)]", options: .AlignAllCenterX, metrics: metrics, views: views)
        
        view.superview?.addConstraints(hConstraints)
        view.superview?.addConstraints(vConstraints)
    }
    
    class func constraintToBottom(view: UIView, size: CGSize, offset: CGFloat) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let views = ["view": view]
        let metrics = ["height": size.height, "bottom": offset]
        
        let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: .AlignAllCenterY, metrics: nil, views: views)
        let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[view(height)]-(bottom)-|", options: .AlignAllCenterX, metrics: metrics, views: views)
        
        view.superview?.addConstraints(hConstraints)
        view.superview?.addConstraints(vConstraints)
    }
    
    class func constraintToCenter(view: UIView, size: CGSize) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let superview = view.superview!
        let metrics = ["width": size.width, "height": size.height]
        
        // Center horizontally
        var constraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:[superview]-(<=1)-[view(width)]",
            options: NSLayoutFormatOptions.AlignAllCenterX,
            metrics: metrics,
            views: ["superview": superview, "view": view])
        
        superview.addConstraints(constraints)
        
        // Center vertically
        constraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:[superview]-(<=1)-[view(height)]",
            options: NSLayoutFormatOptions.AlignAllCenterY,
            metrics: metrics,
            views: ["superview":superview, "view":view])
        
        superview.addConstraints(constraints)
    }
}