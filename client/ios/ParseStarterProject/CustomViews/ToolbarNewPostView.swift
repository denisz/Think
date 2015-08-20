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
    func toolbar(view: ToolbarNewPostView, didTapNewBlock sender: UIView)
    func toolbar(view: ToolbarNewPostView, didTapChangeStyle sender: UIView)
    func toolbar(view: ToolbarNewPostView, didTapHideKeyboard sender: UIView)
}

enum kCommandToolbarNewPost: Int {
    case newBlock
    case changeStyle
    case hideKeyboard
}

class ToolbarNewPostView: BaseUIView {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var parentController: UIViewController?
    var delegate: ToolbarNewPostViewDelegate?
    var commands:[kCommandToolbarNewPost] = [.hideKeyboard, .newBlock, .changeStyle]
    
    override var nibName: String? {
        return "ToolbarNewPostView"
    }
    
    override func viewDidLoad() {
        self.collectionView.registerNib(UINib(nibName: kReusableToolbarNewPost, bundle: nil), forCellWithReuseIdentifier: kReusableToolbarNewPost)

        self.collectionView.reloadData()
    }
    
    func handlerCommand(command: kCommandToolbarNewPost, sender: UIView) {
        switch(command) {
        case .newBlock:
            self.delegate?.toolbar(self, didTapNewBlock: sender)
            break
        case .changeStyle:
            self.delegate?.toolbar(self,  didTapChangeStyle: sender)
            break
        case .hideKeyboard:
            self.delegate?.toolbar(self,  didTapHideKeyboard: sender)
            break
        default:
            println("")
        }
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
    func commandByIndexPath(indexPath: NSIndexPath) -> kCommandToolbarNewPost {
        return self.commands[indexPath.row]
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
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
    @IBOutlet weak var icon: UIButton!
    var command: kCommandToolbarNewPost?
    
    func prepareView(command: kCommandToolbarNewPost) {
        icon.titleLabel?.font = UIFont.ioniconOfSize(30)
        
        switch(command) {
        case .newBlock:
            icon.setTitle(String.ioniconWithName(.Document), forState: .Normal)
            break;
        case .changeStyle:
            icon.setTitle(String.ioniconWithName(.Paintbrush), forState: .Normal)
        break;
        case .hideKeyboard:
            icon.setTitle(String.ioniconWithName(.IosArrowDown), forState: .Normal)
        break;
        }

        self.command = command
    }
}