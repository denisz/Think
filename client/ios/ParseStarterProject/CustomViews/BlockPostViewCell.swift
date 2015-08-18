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
    //добавить после этого блока еще один
    func block(cell: UITableViewCell, didTapNextBlock block: PostBlock);
}

class BlockPostViewCell: UITableViewCell {
    var delegate: BlockPostViewCellDelegate?
    var block: PostBlock?
    var parentViewController: UIViewController?
    
    func prepareView(block: PostBlock) {
        self.block = block
    }
}