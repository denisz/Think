//
//  DraftsViewCell.swift
//  Think
//
//  Created by denis zaytcev on 8/10/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit
import Parse
import ParseUI

class DraftsViewCell: PFTableViewCell {
    @IBOutlet weak var title    : UILabel!
    @IBOutlet weak var content  : UILabel!
    @IBOutlet weak var date     : UILabel!
    
    func prepareView(object: PFObject) {
        self.title.text     = Post.title(object)
        self.content.text   = Post.shortContent(object)
        self.date.text      = Post.createdAtDate(object)
    }
}