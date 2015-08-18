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
        self.title = "Bookrmarks".localized
//        self.automaticallyAdjustsScrollViewInsets = false
        
        self.setupHeaderView()
        
        self.collectionView!.registerNib(UINib(nibName: kReusableBookmarksViewCell, bundle: nil), forCellWithReuseIdentifier: kReusableBookmarksViewCell)
        
        self.setupNavigationBar()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.customizeNavigationBar()
        self.configureNavigationBarBackBtn(kColorNavigationBar)
        self.configureNavigationBarRightBtn(kColorNavigationBar)
    }
    
    func setupHeaderView() {
        let header = BookmarkMainPostView()
        header.object = self.owner
        self.collectionView!.setParallaxHeaderView(header, mode: VGParallaxHeaderMode.Fill, height: 240)
    }
    
    func configureNavigationBarRightBtn(color: UIColor) {
        let navigationItem = defineNavigationItem()
        
        var image = UIImage(named: "ic_more2") as UIImage!
        image = image.imageWithColor(color)
        
        var btnBack:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        btnBack.addTarget(self, action: "didTapMoreBtn:", forControlEvents: UIControlEvents.TouchUpInside)
        btnBack.setImage(image, forState: UIControlState.Normal)
        btnBack.imageEdgeInsets = UIEdgeInsets(top: 13, left: 26, bottom: 13, right: 0)
        btnBack.setTitleColor(color, forState: UIControlState.Normal)
        btnBack.sizeToFit()
        
        let myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: btnBack)
        navigationItem.rightBarButtonItem  = myCustomBackButtonItem
    }
    
    func didTapMoreBtn(sender: AnyObject?) {
        
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
        query.whereKey("user", equalTo: owner!)
        query.includeKey("post")
        query.includeKey("user")
        query.orderByDescending("createdAt")
        return query
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFCollectionViewCell? {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kReusableBookmarksViewCell, forIndexPath: indexPath) as! BookmarksViewCell
        
        if let post = object!["post"] as? PFObject {
            cell.prepareView(post)
        }
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath, object: PFObject?) {
        if let post = object!["post"] as? PFObject {
            let controller = PostViewController.CreateWithModel(post)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle  {
        return UIStatusBarStyle.LightContent
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
        bookmarks.parseClassName = "Bookmark"
        bookmarks.paginationEnabled = true
        bookmarks.pullToRefreshEnabled = false
        
        return bookmarks
    }
    
    class func CreateWithId(objectId: String) -> BookmarksViewController {
        return CreateWithModel(PFObject(withoutDataWithClassName: "_User", objectId: objectId))
    }
}