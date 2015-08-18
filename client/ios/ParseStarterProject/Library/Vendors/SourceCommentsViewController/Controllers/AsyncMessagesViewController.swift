//
//  AsyncMessagesViewController.swift
//  AsyncMessagesViewController
//
//  Created by Huy Nguyen on 12/02/15.
//  Copyright (c) 2015 Huy Nguyen. All rights reserved.
//

import Foundation
import SlackTextViewController
import AsyncDisplayKit

class AsyncMessagesViewController: SLKTextViewController {

    let dataSource: AsyncMessagesCollectionViewDataSource
    override var collectionView: ASCollectionView {
        return scrollView as! ASCollectionView
    }

    init(dataSource: AsyncMessagesCollectionViewDataSource) {
        self.dataSource = dataSource

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical

        let asyncCollectionView = ASCollectionView(frame: CGRectZero, collectionViewLayout: layout, asyncDataFetching: false)
        asyncCollectionView.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1)
        asyncCollectionView.scrollsToTop = true
        asyncCollectionView.asyncDataSource = dataSource
        
        super.init(scrollView: asyncCollectionView)
        
        inverted = false
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillLayoutSubviews() {
        let insets = UIEdgeInsetsMake(64, 0, 5, 0)
        collectionView.contentInset = insets
        collectionView.scrollIndicatorInsets = insets

        super.viewWillLayoutSubviews()
    }
    
    func scrollCollectionViewToBottom() {
        let lastItemIndex = dataSource.collectionView(collectionView, numberOfItemsInSection: 0) - 1
        let lastItemIndexPath = NSIndexPath(forItem: lastItemIndex, inSection: 0)
        collectionView.scrollToItemAtIndexPath(lastItemIndexPath, atScrollPosition: .Bottom, animated: true)
    }
    
}