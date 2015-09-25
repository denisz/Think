//
//  CoverPostViewCell.swift
//  Think
//
//  Created by denis zaytcev on 8/18/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit
import Parse
import ParseUI

class CoverPostViewCell: BlockPostViewCell {
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var pictureView: PFImageView!
    
    override func prepareView(block: PostBlock) {
        super.prepareView(block)
        
        if let _ = block.picture {
            self.pictureView.file = block.picture
            self.pictureView.loadInBackground()
            self.pictureView.hidden = false
        } else {
            self.pictureView.hidden = true
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
    
        super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        
        if keyPath == kvoBlockPropertyPicture {
            self.pictureView.file = self.block!.picture
            self.pictureView.loadInBackground()
            self.pictureView.hidden = false
        }
    }
    
    @IBAction func didTapButton(sender: AnyObject!) {
        let sourceView = sender as! UIView
        SelectImageHelper.selectAndUploadFile(self.parentViewController!, sourceView: sourceView, scenario: .CoverPost)
    }
}