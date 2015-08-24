//
//  CommentViewCell.swift
//  Think
//
//  Created by denis zaytcev on 8/24/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit
import Parse
import ParseUI


class CommentViewCell: PFTableViewCell {
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var authorPicture: UIImageView!
    @IBOutlet weak var body: UILabel!
    @IBOutlet weak var dateView: UILabel!
    
    func prepareView(object: PFObject) {
        if let user = object["kActivityFromUserKey"] as? PFObject {
            self.authorName.text = user[kUserUsernameKey] as? String
        }
        
        self.dateView.text = TransformDate.timeString(object.createdAt!)
        self.body.text = object[kActivityContentKey] as? String
    }
}