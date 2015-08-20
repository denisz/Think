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
    @IBOutlet weak var userPicture  : UIImageView!
    @IBOutlet weak var userName     : UILabel!
    @IBOutlet weak var followBtn    : UIButton!
    
    var object: PFObject?
    
    func prepareView(object: PFObject) {
        self.object = object
    }
}
