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
    @IBOutlet weak var inAuthorName: UILabel!
    @IBOutlet weak var inAuthorPicture: PFImageView!
    
    @IBOutlet weak var outAuthorPicture: PFImageView!
    @IBOutlet weak var outBody: UILabel!
    
    @IBOutlet weak var inBody: UILabel!
    @IBOutlet weak var dateView: UILabel!
    
    override var imageView: PFImageView? {
        return self.inAuthorPicture
    }
    
    //if let message = Thread.lastMessage(object!) {
    func prepareView(object: PFObject) {
        
        if let message = Thread.lastMessage(object) {
            var body = MessageModel.content(message)
            body = body.truncate(140, trailing: "...")
            
            if MessageModel.determineCurrentUserAuthor(message) {
                self.outBody.text = body
                self.outAuthorPicture.image = kUserPlaceholder
                self.outAuthorPicture.file  = MessageModel.ownerPicture(message)
                self.outAuthorPicture.cornerEdge()
                
                self.outBody.numberOfLines = 0
                self.outBody.sizeToFit()
            } else {
                self.inBody.text = body
                self.inBody.numberOfLines = 0
                self.inBody.sizeToFit()
            }
        }
        
        if let participiant = Thread.participant(object) {
            self.inAuthorName.text      = UserModel.displayname(participiant)
            self.inAuthorPicture.image = kUserPlaceholder
            self.inAuthorPicture.file  = UserModel.pictureImage(participiant)
            self.inAuthorPicture.cornerEdge()
        }
        
        self.dateView.text = MessageModel.createdAtDate(object)
    }
}