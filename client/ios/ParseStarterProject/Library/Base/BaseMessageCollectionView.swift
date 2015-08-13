//
//  BaseMessageCollectionView.swift
//  Think
//
//  Created by denis zaytcev on 8/8/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class BaseMessageCollectionView: AsyncMessagesViewController, ASCollectionViewDelegate {
    var fakeNavigationBar: UINavigationBar?
    
    override func defineNavigationBar() -> UINavigationBar? {
        return self.fakeNavigationBar
    }
    
    override func defineNavigationItem() -> UINavigationItem {
        let navBar = defineNavigationBar()
        return navBar!.items[0] as! UINavigationItem
    }
    
    func setupNavigationBar() {
        self.fakeNavigationBar = createFakeNavigationBar()
    }
}