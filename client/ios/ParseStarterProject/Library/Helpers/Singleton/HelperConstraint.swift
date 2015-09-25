//
//  Helper.swift
//  Think
//
//  Created by denis zaytcev on 8/27/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit

func firstItemMatchesConstraint(view: UIView, constraint: NSLayoutConstraint, attribute: NSLayoutAttribute) -> Bool {
    return constraint.firstItem as! NSObject == view && constraint.firstAttribute == attribute
}

func secondItemMatchesConstraint(
    view        : UIView,
    constraint  : NSLayoutConstraint,
    attribute   : NSLayoutAttribute    ) -> Bool {
        return constraint.secondItem as! NSObject == view && constraint.secondAttribute == attribute
}

func isConstraintAttribute(view: UIView, constraint: NSLayoutConstraint, attribute: NSLayoutAttribute) -> Bool {
    let isFirst = firstItemMatchesConstraint(view, constraint: constraint, attribute: attribute)
    let isSecond = secondItemMatchesConstraint(view, constraint: constraint, attribute: attribute)
    
    return  isFirst || isSecond
}


class HelperConstraint: NSObject {
    
    class func findTopConstraint(view: UIView) -> NSLayoutConstraint? {
        let attribute = NSLayoutAttribute.Top
        
        if let superview = view.superview {
            let constraints = superview.constraints
            for constraint in constraints {
                if isConstraintAttribute(view, constraint: constraint, attribute: attribute) {
                    return constraint
                }
            }
        }
        
        return nil
    }
}