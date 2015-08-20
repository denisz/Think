//
//  NewPostViewCell.swift
//  Think
//
//  Created by denis zaytcev on 8/17/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit

protocol BlockPostViewCellDelegate {
    func block(cell: UITableViewCell, didTapNextBlock block: PostBlock);
    func block(cell: UITableViewCell, shouldActiveBlock block: PostBlock);
}

class BlockPostViewCell: UITableViewCell {
    var delegate: BlockPostViewCellDelegate?
    var block: PostBlock?
    var parentViewController: UIViewController?
    
    func prepareView(block: PostBlock) {
        self.block = block
        block.addObserver(self, forKeyPath: kvoBlockPropertyStyle, options: NSKeyValueObservingOptions.New, context: nil)
        
        self.backgroundColor = block.backgroundColor
    }
    
    func clearView() {
        if let block = self.block {
            block.removeObserver(self, forKeyPath: kvoBlockPropertyStyle)
        }
        self.backgroundColor = UIColor.clearColor()
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if keyPath == kvoBlockPropertyStyle {
            self.backgroundColor = self.block?.backgroundColor
        }
    }
    
    func makeActiveBlock() {
        self.delegate?.block(self, shouldActiveBlock: self.block!)
    }
}
