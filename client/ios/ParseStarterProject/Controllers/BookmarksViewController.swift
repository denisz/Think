//
//  BookmarksViewController.swift
//  Think
//
//  Created by denis zaytcev on 8/9/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import ParseUI
import UIKit
import VGParallaxHeader

let kReusableBookmarksViewCell = "BookmarksViewCell"

@objc(BookmarksViewController) class BookmarksViewController: BaseQueryCollectionViewContoller {
    var owner: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Bookmarks"
        
        var header = BookmarkMainPostView()
        header.object = self.owner
        self.collectionView!.setParallaxHeaderView(header, mode: VGParallaxHeaderMode.Fill, height: 240)
        self.collectionView!.registerNib(UINib(nibName: kReusableBookmarksViewCell, bundle: nil), forCellWithReuseIdentifier: kReusableBookmarksViewCell)
        
        self.collectionView!.dataSource = self
        self.collectionView!.delegate = self
        
        self.customizeNavigationBar()
        self.configureNavigationBarBackBtn(UIColor(red:0.2, green:0.2, blue:0.2, alpha:1))
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
    }
    
    func didTapEdit(sender: AnyObject?) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        self.collectionView!.shouldPositionParallaxHeader()
    }
    
    override func queryForCollection() -> PFQuery {
        var query = PFQuery(className: self.parseClassName!)
        query.whereKey("owner", equalTo: owner!)
        query.orderByDescending("createdAt")
        return query
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFCollectionViewCell? {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kReusableBookmarksViewCell, forIndexPath: indexPath) as! BookmarksViewCell
        cell.prepareView(object!)
        
        return cell
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle  {
        return UIStatusBarStyle.Default
    }
    
    class func CreateLayout() -> UICollectionViewFlowLayout {
        var aFlowLayout = UICollectionViewFlowLayout()
        aFlowLayout.itemSize = CGSizeMake(145, 210)
        aFlowLayout.scrollDirection =  UICollectionViewScrollDirection.Vertical
        aFlowLayout.minimumLineSpacing = 10
        aFlowLayout.minimumInteritemSpacing = 5
        aFlowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        
        return aFlowLayout
    }
    
    class func CreateWithModel(model: PFObject) -> BookmarksViewController {
        var bookmarks = BookmarksViewController(collectionViewLayout: CreateLayout(), className: "Post")
        bookmarks.owner = model
        bookmarks.parseClassName = "Post"
        bookmarks.paginationEnabled = true
        bookmarks.pullToRefreshEnabled = false
        
        return bookmarks
    }
    
    class func CreateWithId(objectId: String) -> BookmarksViewController {
        return CreateWithModel(PFObject(withoutDataWithClassName: "_User", objectId: objectId))
    }
}