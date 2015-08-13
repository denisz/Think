//
//  ProfileHeader.swift
//  Think
//
//  Created by denis zaytcev on 8/7/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit
import Parse

class BookmarkMainPostView: BaseUIView {
    var parentController: UIViewController?
    var object: PFObject?
    
    override var nibName: String? {
        return "BookmarkMainPostView"
    }
    
    func setColors() {
//        let image = UIImage(named: "hello.png")
//        let colors = image.getColors()
//        
//        backgroundView.backgroundColor = colors.backgroundColor
//        mainLabel.textColor = colors.primaryColor
//        secondaryLabel.textColor = colors.secondaryColor
//        detailLabel.textColor = colors.detailColor
    }
    
    override func viewDidLoad() {
        
    }
}
