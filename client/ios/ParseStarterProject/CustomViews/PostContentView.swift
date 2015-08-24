//
//  PostViewContent.swift
//  Think
//
//  Created by denis zaytcev on 8/19/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import ParseUI
import UIKit

class PostContentView: UITableView  {
    @IBOutlet weak var heightLayoutConstraint: NSLayoutConstraint!
    
    var object: PFObject?
    var blocks: [PostBlock]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func updateObject(object: PFObject) {
        self.object = object
        self.prepareBlocks()
        self.reloadData()

        self.layoutIfNeeded()
        self.heightLayoutConstraint.constant = self.contentSize.height
    }
    
    func setupView() {
        self.blocks = [PostBlock]()
        self.delegate = self
        self.dataSource = self
        self.scrollEnabled = false
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.estimatedRowHeight = 100
        self.rowHeight = UITableViewAutomaticDimension
        self.tableFooterView = UIView()

        self.registerNib(UINib(nibName: "PostBlockViewCell", bundle: nil), forCellReuseIdentifier: kReusablePostBlockViewCell)
        
        self.prepareBlocks()
    }
    
    func prepareBlocks() {
        if let object = self.object {
            let blocks = object[kPostContentObjKey] as! NSArray //проверить что тут именно массив иначе упадет
            for obj in blocks {
                let postBlock = PostBlock(type: PostBlockType.Text)
                postBlock.fromObject(obj as! [String : String])
                self.blocks?.append(postBlock)
            }
        }
    }
}


extension PostContentView: UITableViewDelegate {
}

extension PostContentView: UITableViewDataSource {
    func blockByIndexPath(indexPath: NSIndexPath) -> PostBlock {
        return self.blocks![indexPath.row]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.blocks!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let block = self.blockByIndexPath(indexPath)
        var cell = tableView.dequeueReusableCellWithIdentifier(kReusablePostBlockViewCell) as? PostBlockViewCell
        
        cell!.prepareView(block)
        
        return cell!
    }
}


class PostBlockViewCell: UITableViewCell {
    @IBOutlet weak var textView: UITextView!
    
    func prepareView(block: PostBlock) {
        self.backgroundColor     = block.backgroundColor
        self.textView.textColor  = block.textColor
        self.textView.text       = block.content
    }
}