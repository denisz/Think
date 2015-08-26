//
//  BookmarksViewCell.swift
//  Think
//
//  Created by denis zaytcev on 8/9/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import ParseUI

class BookmarksViewCell: PFCollectionViewCell {
    @IBOutlet weak var coverImage: PFImageView!
    @IBOutlet weak var shortContent: UILabel!
    @IBOutlet weak var date: UILabel!
    
    func prepareView(object: PFObject) {
        self.coverImage.image   = kPostPlaceholder
        self.coverImage.file    = Post.coverImage(object)
        
        self.shortContent.text  = Post.shortContent(object)
        self.date.text          = Post.createdAtDate(object)
    }
}