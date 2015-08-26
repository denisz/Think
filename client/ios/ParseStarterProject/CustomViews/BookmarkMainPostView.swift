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
import ParseUI

class BookmarkMainPostView: BaseUIView {
    @IBOutlet weak var likesCounter: LabelViewWithIcon!
    @IBOutlet weak var commentsCounter: LabelViewWithIcon!
    @IBOutlet weak var coverImage: PFImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    
    var parentController: UIViewController?
    var object: PFObject?
    
    override var nibName: String? {
        return "BookmarkMainPostView"
    }
    
    func objectDidLoad(object: PFObject) {
        self.object = object
        
        self.likesCounter.text      = Post.likesCounter(object)
        self.commentsCounter.text   = Post.commentsCounter(object)

        self.title.text         = Post.title(object)
        self.date.text          = Post.createdAtDate(object)
        
        self.coverImage.image   = kPostPlaceholder
        self.coverImage.file    = Post.coverImage(object)
        
        self.coverImage.loadInBackground()
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
        super.viewDidLoad()
    }
}
