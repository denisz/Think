//
//  MessageViewCell.swift
//  Think
//
//  Created by denis zaytcev on 8/11/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import ParseUI


class MessageViewCell: PFTableViewCell {
    @IBOutlet weak var body: UILabel!
    
    func prepareView(object: PFObject) {
        body.text = object["body"] as? String
    }
}