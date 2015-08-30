//
//  ContentAdultView.swift
//  Think
//
//  Created by denis zaytcev on 8/30/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit

class ContentAdultView: BasicPlaceholderView {
    let textLabel = UILabel()
    let detailTextLabel = UILabel()
    let tapGestureRecognizer = UITapGestureRecognizer()
    
    override func setupView() {
        super.setupView()
        
        backgroundColor = UIColor.whiteColor()
        
        self.addGestureRecognizer(tapGestureRecognizer)
        
        textLabel.text = "Adult content".localized
        textLabel.font = UIFont(name: "HelveticaNeue", size: 14)
        textLabel.textColor = UIColor(red:0.28, green:0.31, blue:0.32, alpha:1)
        
        textLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        centerView.addSubview(textLabel)
        
        detailTextLabel.text = "Back".localized
        detailTextLabel.font = UIFont(name: "HelveticaNeue", size: 15)
        detailTextLabel.textAlignment = .Center
        detailTextLabel.textColor = UIColor.grayColor()
        detailTextLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        centerView.addSubview(detailTextLabel)
        
        let views = ["label": textLabel, "detailLabel": detailTextLabel]
        let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("|-[label]-|", options: .AlignAllCenterY, metrics: nil, views: views)
        let hConstraintsDetail = NSLayoutConstraint.constraintsWithVisualFormat("|-[detailLabel]-|", options: .AlignAllCenterY, metrics: nil, views: views)
        let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[label]-[detailLabel]-|", options: .AlignAllCenterX, metrics: nil, views: views)
        
        centerView.addConstraints(hConstraints)
        centerView.addConstraints(hConstraintsDetail)
        centerView.addConstraints(vConstraints)
    }
}


