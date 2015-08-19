//
//  TitlePostViewCell.swift
//  Think
//
//  Created by denis zaytcev on 8/18/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit


class TitlePostViewCell: TextBlockPostViewCell {
    override func prepareView(block: PostBlock) {
        super.prepareView(block)
        
        let attributedPlaceholder = [
            NSForegroundColorAttributeName: UIColor.lightGrayColor(),
            NSFontAttributeName: UIFont(name: "OpenSans", size: 17)!
        ]

        self.textView.attributedPlaceholder = NSAttributedString(string: self.textView.placeholder, attributes: attributedPlaceholder)
    }
}