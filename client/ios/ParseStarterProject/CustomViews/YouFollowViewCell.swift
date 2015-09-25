//
//  YouFollowViewCell.swift
//  Think
//
//  Created by denis zaytcev on 8/20/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import ParseUI
import UIKit

class YouFollowViewCell: PFTableViewCell {
    @IBOutlet weak var userPicture  : PFImageView!
    @IBOutlet weak var userName     : UILabel!
    @IBOutlet weak var followBtn    : UIButtonRoundedBorder!
    @IBOutlet weak var dateView     : UILabel!
    
    var object: PFObject? //activity
    
    override var imageView: PFImageView? {
        return self.userPicture
    }
    
    func prepareView(object: PFObject) {
        self.object = object
        
        self.userName.text      = Follower.followingUsername(object)
        self.userPicture.image  = kUserPlaceholder
        self.userPicture.file   = Follower.followingPicture(object)
        
        self.dateView.text = Follower.createdAtDate(object)
        
        self.userPicture.cornerEdge()
        self.updateFollowButton()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userFollowOrUnFollowAuthorPost:", name: kUserFollowingUser, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userFollowOrUnFollowAuthorPost:", name: kUserUnfollowUser, object: nil)
    }
    
    override func clearView() {
        super.clearView()
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kUserFollowingUser, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kUserUnfollowUser,  object: nil)
    }
    
    dynamic func userFollowOrUnFollowAuthorPost(notification: NSNotification) {
        if let _ = notification.object as? PFObject{
            self.updateFollowButton()
        }
    }
    
    @IBAction func didTapFollow() {
        if let user = Follower.following(self.object!) {
            Activity.handlerFollowUser(user)
        }
    }
    
    func updateFollowButton() {
        if let user = Follower.following(self.object!){
            self.followBtn.hidden = UserModel.isEqualCurrentUser(user)
            self.followBtn.selectedOnSet(MyCache.sharedCache.followStatusForUser(user))
        }
    }
    
}
