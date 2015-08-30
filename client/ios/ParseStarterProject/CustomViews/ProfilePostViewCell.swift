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
    
    override var imageView: PFImageView? {
        return self.coverImage
    }
    
    func prepareView(object: PFObject) {
        self.object = object
        
        self.title.text             = Post.title(object)
        self.authorName.text        = Post.usernameOwner(object)
        self.content.text           = Post.shortContent(object)
        self.date.text              = Post.createdAtDate(object)
        
        self.coverImage.image       = kPostPlaceholder
        self.coverImage.file        = Post.coverImage(object)
        
        self.authorPicture.image    = kUserPlaceholder
        self.authorPicture.file     = Post.pictureOwner(object)
        
        self.updateLikesCounter()
        self.updateCommentCounter()
        
        self.authorPicture.loadInBackground()
        self.authorPicture.cornerEdge()
        
        self.setupViewCover()
    }
    
    override func clearView() {
        super.clearView()
        //отписаться от событий
        
    }
    
    func setupViewCover() {
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: "didTapBookmarkPost")
        doubleTapGesture.numberOfTapsRequired = 2
        self.coverImage.addGestureRecognizer(doubleTapGesture)
    }
    
    func didTapBookmarkPost() {
        Bookmark.createWith(self.object!)
    }
    
    func updateCommentCounter() {
        self.commentsCounter.text = Post.commentsCounter(self.object!)
    }
    
    func updateLikesCounter() {
        self.likesCounter.text = Post.likesCounter(self.object!)
        
        let isLiked = MyCache.sharedCache.isPostLikedByCurrentUser(self.object!)
        if isLiked {
            likesCounter.setColor(UIColor(red:0, green:0.64, blue:0.85, alpha:1))
        } else {
            likesCounter.setColor(UIColor(red:0.2, green:0.28, blue:0.37, alpha:1))
        }
    }
    
    @IBAction func didTapLikePost() {
        Activity.handlerLikePost(self.object!)
    }
    
    func didTapShare() {
        let textToShare = Post.shortContent(self.object!)
        let activityVC = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        
        if let controller = self.parentViewController {
            controller.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func didTapMoreBtn(sender: AnyObject?) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        
        let reportAction = UIAlertAction(title: "Report".localized, style: .Default) { (action) -> Void in
        }
        
        let shareAction = UIAlertAction(title: "Share via socials".localized, style: .Default) { (action) -> Void in
            self.didTapShare()
        }
        
        let bookmarkAction = UIAlertAction(title: "Save to read later".localized, style: .Default) { (action) -> Void in
            self.didTapBookmarkPost()
        }

        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .Cancel, handler: nil)
        
        actionSheet.addAction(shareAction)
        actionSheet.addAction(bookmarkAction)
        actionSheet.addAction(reportAction)
        actionSheet.addAction(cancelAction)
        
        if let controller = self.parentViewController {
            controller.presentViewController(actionSheet, animated: true, completion: nil)
        }
        
    }
    
}