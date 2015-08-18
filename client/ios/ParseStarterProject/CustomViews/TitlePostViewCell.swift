//
//  TitlePostViewCell.swift
//  Think
//
//  Created by denis zaytcev on 8/18/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit


class TitlePostViewCell: UITableViewCell {
    var block: PostBlock?
    @IBOutlet weak var textView: SZTextView!
    
    func prepareView(block: PostBlock) {
        self.block = block
        
        let attributedPlaceholder = [
            NSForegroundColorAttributeName: UIColor.lightGrayColor(),
            NSFontAttributeName: UIFont(name: "OpenSans", size: 17)!
        ]

        self.textView.attributedPlaceholder = NSAttributedString(string: self.textView.placeholder, attributes: attributedPlaceholder)
    }
}

extension TitlePostViewCell: UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        let size = textView.bounds.size
        let newSize = textView.sizeThatFits(CGSize(width: size.width, height: CGFloat.max))
        
        // Resize the cell only when cell's size is changed
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            tableView?.beginUpdates()
            tableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
            
            if let thisIndexPath = tableView?.indexPathForCell(self) {
                tableView?.scrollToRowAtIndexPath(thisIndexPath, atScrollPosition: .Bottom, animated: false)
            }
        }
    }
}