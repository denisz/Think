//
//  BaseQueryCollectionViewController.swift
//  Think
//
//  Created by denis zaytcev on 8/9/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import ParseUI
import UIKit


protocol BaseQueryCollectionViewContollerProtocol {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath, object: PFObject?)
}

class BaseQueryCollectionViewContoller: PFQueryCollectionViewController {
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
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

extension BaseQueryCollectionViewContoller: BaseQueryCollectionViewContollerProtocol {
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if let object = self.objectAtIndexPath(indexPath) {
            self.collectionView(self.collectionView!, didSelectItemAtIndexPath: indexPath, object: object)
        }
        
        super.collectionView(collectionView, didSelectItemAtIndexPath: indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath, object: PFObject?) {
    }
}