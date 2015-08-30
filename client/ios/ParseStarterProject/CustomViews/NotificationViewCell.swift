//
//  NotificationViewCell.swift
//  Think
//
//  Created by denis zaytcev on 8/9/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import ParseUI
import UIKit

class NotificationViewCell: PFTableViewCell {
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userPicture: PFImageView!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var dateView: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var iconView: UIButton!
    
    override var imageView: PFImageView? {
        return self.userPicture
    }
    
    func prepareView(object: PFObject) {
        self.userName.text = Notify.ownerUsername(object)
        self.userPicture.image = kUserPlaceholder
        self.userPicture.file = Notify.ownerPicture(object)
        
        self.iconView.setImage(Notify.icon(object), forState: UIControlState.Normal)
        self.userPicture.cornerEdge()
        
        self.dateView.text  = Notify.createdAtDate(object)
        self.desc.text      = Notify.description(object)
    }
    
    override func clearView() {
        super.clearView()
    }
}
