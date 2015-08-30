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
    @IBOutlet weak var coverImage: PFImageView!
    
    override var nibName: String? {
        return "PostViewHeaderView"
    }
    
    func objectDidLoad(object: PFObject) {
        self.coverImage.image       = Post.tintColor(object)
        self.coverImage.file        = Post.coverImage(object)
        
        self.coverImage.loadInBackground()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}