//
//  MyActivityIndicatorCollectionReusableView.swift
//  Think
//
//  Created by denis zaytcev on 8/30/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import ParseUI
import UIKit

class MyActivityIndicatorCollectionReusableView : UICollectionReusableView {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var button: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
    
    func handlerTap() {
        println("test tap")
    }
}