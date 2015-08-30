//
//  PostHelper.swift
//  Think
//
//  Created by denis zaytcev on 8/28/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import ParseUI
import UIKit

class PostHelper {
    
    class func didTapBookmarkPost(post: PFObject) {
        Bookmark.createWith(post)
    }
    
    class func didTapRaisePost(post: PFObject) {
        Post.raisePost(post)
    }
    
    class func didTapReport(post: PFObject) {}
    
    class func didTapDelete(post: PFObject) {
        Post.deletePost(post)
    }
    
    class func didTapPublic(post: PFObject, controller: UIViewController) {
        let controller = SettingsPostViewController.CreateWithModel(post)
        controller.navigationController?.pushViewController(controller, animated: true)
    }
    
    class func didTapLikePost(post: PFObject) {
        Activity.handlerLikePost(post)
    }
    
    class func didTapFollowAuthor(post: PFObject) {
        if let owner = Post.owner(post) {
            Activity.handlerFollowUser(owner)
        }
    }
    
    class func didTapComments(post: PFObject, controller: UIViewController) {
        let comments = CommentsViewController.CreateWithModel(post)
        controller.navigationController?.pushViewController(comments, animated: true)
    }
    
    class func didTapShare(post: PFObject, controller: UIViewController) {
        let textToShare = Post.stringForShare(post)
        let activityVC = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        controller.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    class func actionSheet(post: PFObject, controller: UIViewController) -> UIAlertController {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let reportAction = UIAlertAction(title: "Report".localized, style: .Default) { (action) -> Void in
            PostHelper.didTapReport(post)
        }
        
        let shareAction = UIAlertAction(title: "Share via socials".localized, style: .Default) { (action) -> Void in
            PostHelper.didTapShare(post, controller: controller)
        }
        
        let bookmarkAction = UIAlertAction(title: "Save to read later".localized, style: .Default) { (action) -> Void in
            PostHelper.didTapBookmarkPost(post)
        }
        
        let raiseAction = UIAlertAction(title: "Raise post public".localized, style: .Default) { (action) -> Void in
            PostHelper.didTapRaisePost(post)
        }
        
        let deleteAction = UIAlertAction(title: "Delete post".localized, style: .Default) { (action) -> Void in
            PostHelper.didTapDelete(post)
        }
        
        let publicAction = UIAlertAction(title: "Public post public".localized, style: .Default) { (action) -> Void in
            PostHelper.didTapPublic(post, controller: controller)
        }
        
        let followAction = UIAlertAction(title: "Follow author".localized, style: .Default) { (action) -> Void in
            PostHelper.didTapFollowAuthor(post)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .Cancel, handler: nil)
        
        actionSheet.addAction(shareAction)
        actionSheet.addAction(bookmarkAction)
        
        if Post.determineCurrentUserAuthor(post) {
            if Post.wasPublishedPost(post) {
                actionSheet.addAction(raiseAction)
            } else {
                actionSheet.addAction(publicAction)
            }
            
            actionSheet.addAction(deleteAction)
            
        } else {
            actionSheet.addAction(reportAction)
            actionSheet.addAction(followAction)
        }
        
        actionSheet.addAction(cancelAction)
        
        controller.presentViewController(actionSheet, animated: true, completion: nil)
        
        return actionSheet
    }
}