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
    @IBOutlet weak var authorPicture: UIImageView!
    @IBOutlet weak var communityView: UIView!
    
    override var imageView: PFImageView? {
        return self.coverImage
    }
    
    func prepareView(object: PFObject) {
        self.object = object
        
        let countLikes = object[kPostCounterLikesKey] as! Int
        let countComments = object[kPostCounterCommentsKey] as! Int
        
        likesCounter.text = "+\(countLikes)"
        commentsCounter.text = "\(countComments)"
        
        self.setupViewCover()
    }
    
    func setupViewCover() {
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: "didTapBookmarkPost")
        doubleTapGesture.numberOfTapsRequired = 2
        self.coverImage.addGestureRecognizer(doubleTapGesture)
    }
    
    func didTapBookmarkPost() {
        Bookmark.createWith(self.object!)
    }
    
    @IBAction func didTapLikePost() {
        Activity.handlerLikePost(self.object!)
        likesCounter.setColor(UIColor(red:0, green:0.64, blue:0.85, alpha:1))
    }
    
    func didTapShare() {
        let textToShare = self.object!["content"] as! String
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