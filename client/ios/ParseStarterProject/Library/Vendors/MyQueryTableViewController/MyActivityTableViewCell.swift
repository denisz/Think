//
//  MyActivityTableViewCell.swift
//  Think
//
//  Created by denis zaytcev on 8/14/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import ParseUI
import UIKit

class MyActivityTableViewCell: PFTableViewCell {
    var activityIndicator: UIActivityIndicatorView?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        
        activityIndicator.hidesWhenStopped = true
        self.backgroundColor = UIColor.clearColor()
        self.contentView.backgroundColor = UIColor.clearColor()
        self.textLabel?.hidden = true
        self.activityIndicator = activityIndicator
        self.accessoryView = activityIndicator
        self.setupLabel()
    }
    
    func setupLabel() {
        var contentView = self.contentView
        var label = UILabel()
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.backgroundColor = UIColor.clearColor()
        label.text = "Load more...".localized
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont(name: "OpenSans-Semibold", size: 14)
        label.textColor = kColorNavigationBar
        contentView.addSubview(label)

        let views = ["view": label]
        let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]-(-44)-|", options: nil, metrics: nil, views: views)
        let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[view(44)]|", options: nil, metrics: nil, views: views)
        contentView.addConstraints(hConstraints)
        contentView.addConstraints(vConstraints)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setAnimating(animating: Bool) {
        if let activity = self.activityIndicator {
            if animating {
                activity.startAnimating()
            } else {
                activity.stopAnimating()
            }
        }
    }
    
    var isAnimating: Bool {
        if let activity = self.activityIndicator {
            return activity.isAnimating()
        }
        
        return false
    }
}