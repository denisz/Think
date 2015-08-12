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
        self.configureNavigationBarBackBtn(UIColor.whiteColor())
    }
    
    override func customizeNavigationBar() {
        self.automaticallyAdjustsScrollViewInsets = false
        var navigationBar = self.navigationController?.navigationBar
        
        navigationBar?.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: kFontNavigationBarTitle
        ]

        // Sets background to a blank/empty image
        navigationBar?.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        // Sets shadow (line below the bar) to a blank image
        navigationBar?.shadowImage = UIImage()
        // Sets the translucent background color
        navigationBar?.backgroundColor = UIColor.clearColor()
        //UIColor(red:0, green:0, blue:0, alpha:0.5)
        //
        // Set translucent. (Default value is already true, so this can be removed if desired.)
        navigationBar?.translucent = true
        
        var image = UIImage(named: "ic_more2") as UIImage!
        image = image.imageWithColor(UIColor.whiteColor())
        
        var btnBack:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        btnBack.addTarget(self, action: "didTapMoreBtn:", forControlEvents: UIControlEvents.TouchUpInside)
        btnBack.setImage(image, forState: UIControlState.Normal)
        btnBack.imageEdgeInsets = UIEdgeInsets(top: 9, left: 18, bottom: 9, right: 0)
        btnBack.setTitleColor(kColorNavigationBar, forState: UIControlState.Normal)
        btnBack.sizeToFit()
        var myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: btnBack)
        self.navigationItem.rightBarButtonItem  = myCustomBackButtonItem
    }
    
    func didTapMoreBtn(sender: AnyObject?) {
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
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
        bookmarks.parseClassName = "Post"
        bookmarks.paginationEnabled = true
        bookmarks.pullToRefreshEnabled = false
        
        return bookmarks
    }
    
    class func CreateWithId(objectId: String) -> BookmarksViewController {
        return CreateWithModel(PFObject(withoutDataWithClassName: "_User", objectId: objectId))
    }
}