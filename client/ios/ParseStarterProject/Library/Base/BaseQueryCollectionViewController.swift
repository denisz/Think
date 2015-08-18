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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.dataSource = self
        self.collectionView!.delegate = self
    }
}

extension BaseQueryCollectionViewContoller: BaseQueryCollectionViewContollerProtocol {
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let count = self.objects.count
        
        if count > indexPath.row {
            self.collectionView(collectionView, didSelectItemAtIndexPath: indexPath, object: self.objectAtIndexPath(indexPath))
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath, object: PFObject?) {
    }
}