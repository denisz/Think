//
//  FeedViewController.swift
//  Think
//
//  Created by denis zaytcev on 8/7/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import ParseUI
import UIKit

let kReusableFeedPostViewCell = "FeedPostViewCell"
@objc(FeedViewController) class FeedViewController: BaseQueryTableViewContoller {
    var owner: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Feed"
        self.tableView.registerNib(UINib(nibName: kReusableProfilePostViewCell, bundle: nil), forCellReuseIdentifier: kReusableProfilePostViewCell)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 44.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.tableFooterView = UIView()
        
        self.configureTitleView()
        self.customizeNavigationBar()
        self.configureNavigationBarBackBtn(UIColor(red:0.2, green:0.2, blue:0.2, alpha:1))
        self.configureNavigationBarNewPostBtn(UIColor(red:0.2, green:0.2, blue:0.2, alpha:1))
    }
    
    func configureNavigationBarNewPostBtn(color: UIColor) {
        var image = UIImage(named: "ic_new_post") as UIImage!
        image = image.imageWithColor(color)
        
        var btnBack:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        btnBack.addTarget(self, action: "didTapNewPostBtn:", forControlEvents: UIControlEvents.TouchUpInside)
        btnBack.setImage(image, forState: UIControlState.Normal)
//        btnBack.contentEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
        btnBack.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        btnBack.setTitleColor(UIColor(red:0.2, green:0.2, blue:0.2, alpha:1), forState: UIControlState.Normal)
        btnBack.sizeToFit()
        var myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: btnBack)
        self.navigationItem.rightBarButtonItem  = myCustomBackButtonItem
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default;
    }
    
    func didTapNewPostBtn(sender: AnyObject?) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        self.tableView.shouldPositionParallaxHeader();
    }
    
    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: self.parseClassName!)
        query.whereKey("owner", equalTo: owner!)
        query.orderByDescending("createdAt")
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        let cell = tableView.dequeueReusableCellWithIdentifier(kReusableProfilePostViewCell) as! ProfilePostViewCell
        cell.prepareView(object!)
        return cell
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle  {
        return UIStatusBarStyle.LightContent
    }
    
    class func CreateWithModel(model: PFObject) -> FeedViewController{
        var feed = FeedViewController()
        feed.owner = model
        feed.parseClassName = "Post"
        feed.paginationEnabled = true
        feed.pullToRefreshEnabled = false
        
        
        return feed
    }
    
    class func CreateWithId(objectId: String) -> FeedViewController {
        return CreateWithModel(PFObject(withoutDataWithClassName: "_User", objectId: objectId))
    }
}