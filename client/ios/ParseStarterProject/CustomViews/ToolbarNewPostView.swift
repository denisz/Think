//
//  ToolbarNewPostView.swift
//  Think
//
//  Created by denis zaytcev on 8/18/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit


let kReusableToolbarNewPost = "ToolbarNewPostViewCell"

@objc protocol ToolbarNewPostViewDelegate {
    func toolbar(view: ToolbarNewPostView, didTapNewBlock sender: UIButton)
}

class ToolbarNewPostView: BaseUIView {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate: ToolbarNewPostViewDelegate?
    var commands = ["newBlock", "changeBackgroundColor", "changeTextColor", "newBlock", "changeBackgroundColor", "changeTextColor", "newBlock", "changeBackgroundColor", "changeTextColor"]
    
    override var nibName: String? {
        return "ToolbarNewPostView"
    }
    
    override func viewDidLoad() {
        self.collectionView.registerNib(UINib(nibName: kReusableToolbarNewPost, bundle: nil), forCellWithReuseIdentifier: kReusableToolbarNewPost)
        self.collectionView.reloadData()
    }
    
    func handlerCommand(command: String, sender: UIView) {
        println(command)
    }
}

extension ToolbarNewPostView: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let command = commandByIndexPath(indexPath)
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        self.handlerCommand(command, sender: cell!)
    }
}

extension ToolbarNewPostView: UICollectionViewDataSource {
    func commandByIndexPath(indexPath: NSIndexPath) -> String {
        return self.commands[indexPath.row]
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.commands.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let command = commandByIndexPath(indexPath)
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(kReusableToolbarNewPost, forIndexPath: indexPath) as? ToolbarNewPostViewCell
        
        if cell == nil {
            cell = ToolbarNewPostViewCell()
        }
        
        cell!.prepareView(command)
        
        return cell!
    }
}


class ToolbarNewPostViewCell: UICollectionViewCell {
    var command: String?
    
    func prepareView(command: String) {
        
    }
    
}