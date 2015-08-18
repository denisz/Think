//
//  UIViewController+FilterView.swift
//  Think
//
//  Created by denis zaytcev on 8/15/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit
import LGFilterView

var _filterView: LGFilterView?
var _filterViewWrapper: UIView?


func createViewWrapperInView(view: UIView) -> UIView {
    let wrapper = UIView()
    wrapper.setTranslatesAutoresizingMaskIntoConstraints(false)
    wrapper.clipsToBounds = true
    view.addSubview(wrapper)
    
    let views = ["view": wrapper]
    let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: nil, metrics: nil, views: views)
    let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-64-[view]|", options: nil, metrics: nil, views: views)
    
    view.addConstraints(hConstraints)
    view.addConstraints(vConstraints)
    view.layoutIfNeeded()
    
    _filterViewWrapper = wrapper
    return wrapper
}

extension UIViewController {
    func showFilterUnderTitle(innerView: UIView) {
        if let filterView = _filterView {
            filterView.dismissAnimated(true, completionHandler: nil)
        } else {
            let filterView = LGFilterView(view: innerView)
            filterView.delegate = self
            filterView.transitionStyle = LGFilterViewTransitionStyleTop
            filterView.heightMax = innerView.frame.height
            filterView.borderWidth = 0
            filterView.backgroundColor = UIColor.whiteColor()
            
            let wrapper = createViewWrapperInView(self.view)
            filterView.showInView(wrapper, animated: true, completionHandler: nil)
        }
    
    }
}

extension UIViewController: LGFilterViewDelegate {
    
    public func filterViewDidDismiss(filterView: LGFilterView!) {
        if let wrapper = _filterViewWrapper {
            wrapper.removeFromSuperview()
            _filterViewWrapper = nil
        }
    }
    public func filterViewWillDismiss(filterView: LGFilterView!) {
        _filterView = nil
    }
    
    public func filterViewWillShow(filterView: LGFilterView!) {
        _filterView = filterView
    }
}
