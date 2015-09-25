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
import LGActionSheet

enum ButtonsActionSheet: String {
    case Report     = "Report"
    case Share      = "Share via socials"
    case Bookmark   = "Save to read later"
    case Raise      = "Raise post public"
    case Public     = "Public post public"
    case Delete     = "Delete post"
    case Follow     = "Follow author"
    case Cancel     = "Cancel"
}

class PostHelper: NSObject {
    
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
    
    class func actionSheet(post: PFObject, controller: UIViewController) {
        if #available(iOS 8.0, *) {
            self.actionSheetIOS8(post, controller: controller)
        } else {
            self.actionSheetIOS7(post, controller: controller)
        }
    }
    
    class func actionSheetIOS7(post: PFObject, controller: UIViewController) {
        var buttons = [String]()
        buttons.append(ButtonsActionSheet.Share.rawValue)
        buttons.append(ButtonsActionSheet.Bookmark.rawValue)
        
        if Post.determineCurrentUserAuthor(post) {
            if Post.wasPublishedPost(post) {
                buttons.append(ButtonsActionSheet.Raise.rawValue)
            } else {
                buttons.append(ButtonsActionSheet.Public.rawValue)
            }
            
            buttons.append(ButtonsActionSheet.Delete.rawValue)
        } else {
            buttons.append(ButtonsActionSheet.Report.rawValue)
            buttons.append(ButtonsActionSheet.Follow.rawValue)
        }
        
        let actionSheet = LGActionSheet(title: nil, buttonTitles:
            buttons.map{$0.localized}, cancelButtonTitle: nil, destructiveButtonTitle: ButtonsActionSheet.Cancel.rawValue.localized)
        actionSheet.showAnimated(true, completionHandler: nil)
    }
    
    @available(iOS 8.0, *)
    class func actionSheetIOS8(post: PFObject, controller: UIViewController)  {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let reportAction = UIAlertAction(title: ButtonsActionSheet.Report.rawValue.localized, style: .Default) { (action) -> Void in
            PostHelper.didTapReport(post)
        }
        
        let shareAction = UIAlertAction(title: ButtonsActionSheet.Share.rawValue.localized, style: .Default) { (action) -> Void in
            PostHelper.didTapShare(post, controller: controller)
        }
        
        let bookmarkAction = UIAlertAction(title: ButtonsActionSheet.Bookmark.rawValue.localized, style: .Default) { (action) -> Void in
            PostHelper.didTapBookmarkPost(post)
        }
        
        let raiseAction = UIAlertAction(title: ButtonsActionSheet.Raise.rawValue.localized, style: .Default) { (action) -> Void in
            PostHelper.didTapRaisePost(post)
        }
        
        let deleteAction = UIAlertAction(title: ButtonsActionSheet.Delete.rawValue.localized, style: .Default) { (action) -> Void in
            PostHelper.didTapDelete(post)
        }
        
        let publicAction = UIAlertAction(title: ButtonsActionSheet.Public.rawValue.localized, style: .Default) { (action) -> Void in
            PostHelper.didTapPublic(post, controller: controller)
        }
        
        let followAction = UIAlertAction(title: ButtonsActionSheet.Follow.rawValue.localized, style: .Default) { (action) -> Void in
            PostHelper.didTapFollowAuthor(post)
        }
        
        let cancelAction = UIAlertAction(title: ButtonsActionSheet.Cancel.rawValue.localized, style: .Cancel, handler: nil)
        
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
    }
}

extension PostHelper: LGActionSheetDelegate {
    func actionSheet(actionSheet: LGActionSheet!, buttonPressedWithTitle title: String!, index: UInt) {
        
    }
}