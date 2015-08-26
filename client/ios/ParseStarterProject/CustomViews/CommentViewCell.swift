//
//  CommentViewCell.swift
//  Think
//
//  Created by denis zaytcev on 8/24/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit
import Parse
import ParseUI


class CommentViewCell: PFTableViewCell {
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var authorPicture: PFImageView!
    @IBOutlet weak var body: UILabel!
    @IBOutlet weak var dateView: UILabel!
    
    override var imageView: PFImageView? {
        return self.authorPicture
    }
    
    func prepareView(object: PFObject) {
        self.authorPicture.image    = kUserPlaceholder
        self.authorPicture.file     = Comment.pictureOwner(object)
        
        self.authorName.text    = Comment.ownerName(object)
        self.dateView.text      = Comment.createdAtDate(object)
        self.body.text          = Comment.content(object)
        
        self.authorPicture.cornerEdge()
    }
}