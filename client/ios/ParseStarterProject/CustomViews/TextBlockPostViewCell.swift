//
//  TextBlockPostViewCell.swift
//  Think
//
//  Created by denis zaytcev on 8/19/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation

class TextBlockPostViewCell: BlockPostViewCell {
    @IBOutlet weak var textView: SZTextView!
    
    func scrollToCursorForTextView(textView: UITextView) {
        var cursorRect = textView.caretRectForPosition(textView.selectedTextRange!.end)
        cursorRect = self.tableView!.convertRect(cursorRect, fromView: textView)
        
        cursorRect.size.height += 8
        self.tableView!.scrollRectToVisible(cursorRect, animated: true)
    }
    
    func rectVisible(rect: CGRect) -> Bool {
        var visibleRect = CGRect()
        visibleRect.origin = self.tableView!.contentOffset
        visibleRect.origin.y += self.tableView!.contentInset.top
        visibleRect.size = self.tableView!.bounds.size
        visibleRect.size.height -= self.tableView!.contentInset.top + self.tableView!.contentInset.bottom
        
        return CGRectContainsRect(visibleRect, rect)
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        
        if keyPath == kvoBlockPropertyStyle {
            self.textView.textColor = self.block?.textColor
        }
    }
}

extension TextBlockPostViewCell: UITextViewDelegate {
    func textViewDidBeginEditing(textView: UITextView) {
        self.makeActiveBlock()
    }
    
    func textViewDidChange(textView: UITextView) {
        let text    = textView.text
        let size    = textView.bounds.size
        let newSize = textView.sizeThatFits(CGSize(width: size.width, height: CGFloat.max))
        
        self.block?.content = text
        
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            tableView?.beginUpdates()
            tableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
            self.scrollToCursorForTextView(self.textView)
        }
    }
}
