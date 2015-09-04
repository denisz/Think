//
//  ProfilePostViewCell.swift
//  Think
//
//  Created by denis zaytcev on 8/7/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit
import Parse
import ParseUI

class ProfilePostViewCell: PFTableViewCell {
    var object: PFObject?
    var parentViewController: UIViewController?
    
    @IBOutlet weak var likesCounter: LabelViewWithIcon!
    @IBOutlet weak var commentsCounter: LabelViewWithIcon!
    @IBOutlet weak var coverImage: PFImageView!
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var authorPicture: PFImageView!
    @IBOutlet weak var communityView: UIView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var wrapperCover: UIView!
    
    override var imageView: PFImageView? {
        return self.coverImage
    }
    
    func prepareView(object: PFObject) {
        self.object = object
        
        self.footerView.hidden = true
        
        self.title.text             = Post.title(object)
        self.authorName.text        = Post.usernameOwner(object)
        self.content.text           = Post.shortContent(object)
        self.date.text              = Post.createdAtDate(object)
        
        self.coverImage.image       = Post.tintColor(object)
        self.coverImage.file        = Post.coverImage(object)
        
        self.authorPicture.image    = kUserPlaceholder
        self.authorPicture.file     = Post.pictureOwner(object)
        
//        self.updateLikesCounter()
//        self.updateCommentCounter()
        
        self.authorPicture.loadInBackground()
        self.authorPicture.cornerEdge()
        
        self.setupViewCover()
        self.setupGesture()
    }
    
    func setupGesture() {
        let gestureName = UITapGestureRecognizer(target: self, action: "didTapAuthor")
        self.authorName.addGestureRecognizer(gestureName)
        self.authorName.userInteractionEnabled = true

        
        let gesturePicture = UITapGestureRecognizer(target: self, action: "didTapAuthor")
        self.authorPicture.addGestureRecognizer(gesturePicture)
        self.authorPicture.userInteractionEnabled = true
    }
    
    override func clearView() {
        super.clearView()
        //отписаться от событий
    }
    
    func setupViewCover() {
        
    }
    
    func updateCommentCounter() {
        self.commentsCounter.text = Post.commentsCounter(self.object!)
    }
    
    func updateLikesCounter() {
        self.likesCounter.text = Post.likesCounter(self.object!)
        
        let isLiked = MyCache.sharedCache.isPostLikedByCurrentUser(self.object!)
        if isLiked {
            likesCounter.setColor(kColorLikeActive)
        } else {
            likesCounter.setColor(kColorLikeUnactive)
        }
    }
    
    @IBAction func didTapMore() {
        if let controller = self.parentViewController {
            PostHelper.actionSheet(self.object!, controller: controller)
        }
    }
    
    func didTapAuthor() {
        if let user = Post.owner(self.object!) {
            let controller = ProfileViewController.CreateWithModel(user)
            if let parentController = self.parentViewController {
                parentController.navigationController!.pushViewController(controller, animated: true)
            }
        }
    }
}