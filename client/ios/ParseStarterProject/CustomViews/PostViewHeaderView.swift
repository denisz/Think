//
//  PostViewHeaderView.swift
//  Think
//
//  Created by denis zaytcev on 8/13/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import ParseUI


class PostViewHeaderView: BaseUIView {
    var parentController: UIViewController?
    var object: PFObject?
    
    override var nibName: String? {
        return "PostViewHeaderView"
    }

    override func viewDidLoad() {
        
    }
}