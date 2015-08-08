//
//  MessageTextBubbleNode.swift
//  AsyncMessagesViewController
//
//  Created by Huy Nguyen on 13/02/15.
//  Copyright (c) 2015 Huy Nguyen. All rights reserved.
//

import Foundation
import AsyncDisplayKit

private let kFontFormMessage = UIFont(name: "OpenSans", size: 14)!
//UIFont(name: "OpenSans Regular", size: 13.0)!
private let kAMMessageTextBubbleNodeIncomingTextAttributes = [NSForegroundColorAttributeName: UIColor(red:0.2, green:0.2, blue:0.2, alpha:1),
    NSFontAttributeName: kFontFormMessage]
private let kAMMessageTextBubbleNodeOutgoingTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(),
    NSFontAttributeName: kFontFormMessage]
private let kTextNodeXOffset: CGFloat = 15
private let kTextNodeInset: CGFloat = 15
private let kTextNodeMinWidth: CGFloat = 100

class MessageTextBubbleNodeFactory: MessageBubbleNodeFactory {
    
    func build(message: MessageData, isOutgoing: Bool, bubbleImage: UIImage) -> ASDisplayNode {
        let attributes = isOutgoing
            ? kAMMessageTextBubbleNodeOutgoingTextAttributes
            : kAMMessageTextBubbleNodeIncomingTextAttributes
        let text = NSAttributedString(string: message.content(), attributes: attributes)
        return MessageTextBubbleNode(text: text, isOutgoing: isOutgoing, bubbleImage: bubbleImage)
    }
    
}

private class MessageTextNode: ASTextNode {
    
    override init() {
        super.init()
        placeholderColor = UIColor.clearColor()
        layerBacked = true
    }
    
    override func calculateSizeThatFits(constrainedSize: CGSize) -> CGSize {
        let size = super.calculateSizeThatFits(constrainedSize)
        return CGSize(width: max(size.width, kTextNodeMinWidth), height: size.height)
    }
    
}

class MessageTextBubbleNode: ASDisplayNode {

    private let isOutgoing: Bool
    private let bubbleImageNode: ASImageNode
    private let textNode: ASTextNode
    
    init(text: NSAttributedString, isOutgoing: Bool, bubbleImage: UIImage) {
        self.isOutgoing = isOutgoing

        bubbleImageNode = ASImageNode()
        bubbleImageNode.image = bubbleImage

        textNode = MessageTextNode()
        textNode.attributedString = text
        
        super.init()
        
        addSubnode(bubbleImageNode)
        addSubnode(textNode)
    }
    
    override func calculateSizeThatFits(constrainedSize: CGSize) -> CGSize {
        let textNodeHorizontalGap = kTextNodeXOffset + 2 * kTextNodeInset
        let textNodeMeasuredSize = textNode.measure(CGSizeMake(constrainedSize.width - textNodeHorizontalGap, constrainedSize.height))
        return CGSizeMake(
            textNodeMeasuredSize.width + textNodeHorizontalGap, // Wrap textNode's width
            textNodeMeasuredSize.height + 2 * kTextNodeInset)
    }
    
    override func layout() {
        bubbleImageNode.frame = CGRectMake(0, 0, calculatedSize.width, calculatedSize.height)
        
        var textNodeX = kTextNodeXOffset + kTextNodeInset
        if isOutgoing {
            textNodeX = self.calculatedSize.width - textNode.calculatedSize.width - textNodeX //Right-aligned
        }
        textNode.frame = CGRectMake(textNodeX, kTextNodeInset, textNode.calculatedSize.width, textNode.calculatedSize.height)
    }
    
}
