//
//  DenyView.swift
//  Think
//
//  Created by denis zaytcev on 8/30/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit

class DenyView: BasicPlaceholderView {
    
    let label = UILabel()
    
    override func setupView() {
        super.setupView()
        
        self.userInteractionEnabled = false
        
        backgroundColor = UIColor.whiteColor()
        
        label.text = "Deny content".localized
        label.font = UIFont(name: "OpenSans", size: 13)
        label.textColor = UIColor(red:0.28, green:0.31, blue:0.32, alpha:1)
        label.translatesAutoresizingMaskIntoConstraints = false
        centerView.addSubview(label)
        
        let views = ["label": label]
        let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("|-[label]-|", options: .AlignAllCenterY, metrics: nil, views: views)
        let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[label]-|", options: .AlignAllCenterX, metrics: nil, views: views)
        
        centerView.addConstraints(hConstraints)
        centerView.addConstraints(vConstraints)
    }
    
}

