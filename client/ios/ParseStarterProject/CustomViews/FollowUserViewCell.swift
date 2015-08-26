//
//  FollowUserViewCell.swift
//  Think
//
//  Created by denis zaytcev on 8/20/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import ParseUI
import UIKit

class FollowUserViewCell: PFTableViewCell {
    @IBOutlet weak var userPicture  : PFImageView!
    @IBOutlet weak var userName     : UILabel!
    @IBOutlet weak var followBtn    : UIButton!
    @IBOutlet weak var dateView     : UILabel!
    
    var object: PFObject? //activity
    
    override var imageView: PFImageView? {
        return self.userPicture
    }
    
    func prepareView(object: PFObject) {
        self.object = object
        
        self.userName.text      = Follower.followerUsername(object)
        self.userPicture.image  = kUserPlaceholder
        self.userPicture.file   = Follower.followerPicture(object)
        
        self.dateView.text = Follower.createdAtDate(object)
        
        self.userPicture.cornerEdge()
    }
}
