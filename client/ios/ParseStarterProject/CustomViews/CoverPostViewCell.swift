//
//  CoverPostViewCell.swift
//  Think
//
//  Created by denis zaytcev on 8/18/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit


class CoverPostViewCell: BlockPostViewCell {
    @IBOutlet weak var button: UIButton!
    
    override func prepareView(block: PostBlock) {
        super.prepareView(block)
    }
    
    @IBAction func didTapButton(sender: AnyObject!) {
        var sourceView = sender as! UIView
        SelectImageHelper.selectAndUploadFile(self.parentViewController!, sourceView: sourceView, scenario: .CoverPost)
    }
}