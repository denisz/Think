//
//  MessageViewCell.swift
//  Think
//
//  Created by denis zaytcev on 8/11/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import ParseUI


class MessageViewCell: PFTableViewCell {
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var authorPicture: PFImageView!
    @IBOutlet weak var body: UILabel!
    @IBOutlet weak var dateView: UILabel!
    
    override var imageView: PFImageView? {
        return self.authorPicture
    }
    
    func prepareView(object: PFObject) {
        self.body.text = object["body"] as? String
        
        
    }
}