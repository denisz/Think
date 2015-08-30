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

class BaseQueryCollectionViewContoller: MyQueryCollectionViewController {
    @IBOutlet weak var collectionViewTopLayoutContraint: NSLayoutConstraint!
    
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
    
    func topConstraintForNavigationBar() -> NSLayoutConstraint? {
        return self.collectionViewTopLayoutContraint
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.automaticallyAdjustsScrollViewInsets == true {
            if let top = self.topConstraintForNavigationBar() {
                top.constant = 44
            }
        }
    }
}

extension BaseQueryCollectionViewContoller {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let count = self.objects!.count
        
        if count > indexPath.row {
            self.collectionView(collectionView, didSelectItemAtIndexPath: indexPath, object: self.objectAtIndexPath(indexPath))
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath, object: PFObject?) {
    }
}