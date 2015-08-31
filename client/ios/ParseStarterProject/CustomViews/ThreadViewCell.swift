//
//  ChannelViewCell.swift
//  Think
//
//  Created by denis zaytcev on 8/28/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import ParseUI

class ThreadViewCell: PFTableViewCell {
    @IBOutlet weak var authorPicture: PFImageView!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var body: UILabel!
    @IBOutlet weak var dateView: UILabel!
    
    override var imageView: PFImageView? {
        return self.authorPicture
    }
    
    func prepareView(object: PFObject) {
        let body = MessageModel.content(object)
        self.body.text  = body

        if MessageModel.determineCurrentUserAuthor(object) {
            if body.length > 36 {
                self.body.textAlignment = NSTextAlignment.Left
            } else {
                self.body.textAlignment = NSTextAlignment.Right
            }
        } else {
            self.body.textAlignment = NSTextAlignment.Left
        }
        
        self.authorName.text = MessageModel.ownerUsername(object)
        self.authorPicture.image    = kUserPlaceholder
        self.authorPicture.file     = MessageModel.ownerPicture(object)
        
        self.dateView.text = MessageModel.createdAtDate(object)
        
        self.authorPicture.cornerEdge()
    }
}
