//
//  TopViewController.swift
//  Think
//
//  Created by denis zaytcev on 8/21/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import ParseUI
import Bolts
import UIKit

@objc(TopViewController) class TopViewController: BaseQueryTableViewController {
    var owner: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Top"
        self.tableView.registerNib(UINib(nibName: kReusableProfilePostViewCell, bundle: nil), forCellReuseIdentifier: kReusableProfilePostViewCell)
        
        self.tableView.estimatedRowHeight = 44.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.tableFooterView = UIView()
        
        self.setupNavigationBar()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.configureTitleView()
        self.customizeNavigationBar()
        self.configureNavigationBarBackBtn(kColorNavigationBar)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)
//        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default;
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        self.tableView.shouldPositionParallaxHeader();
    }
    
    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: self.parseClassName!)
//        query.whereKey("owner", equalTo: owner!)
        query.whereKey(kPostStatusKey, equalTo: kPostStatusPublic)
        query.orderByDescending(kPostCounterLikesKey)
        query.addDescendingOrder(kClassCreatedAt)//по созданию
        query.includeKey(kPostOwnerKey)
        query.selectKeys([kPostTitleKey, kPostContentShortKey, kPostCounterCommentsKey, kPostCounterLikesKey, kPostOwnerKey, kPostCoverKey, kClassCreatedAt])

        
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        let cell = tableView.dequeueReusableCellWithIdentifier(kReusableProfilePostViewCell) as! ProfilePostViewCell
        cell.prepareView(object!)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) {
        
        let controller = PostViewController.CreateWithModel(object!)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle  {
        return UIStatusBarStyle.LightContent
    }
    
    class func CreateWith() -> TopViewController {
        let user = PFUser.currentUser()!
        return CreateWithModel(user)
    }
    
    class func CreateWithModel(model: PFObject) -> TopViewController{
        var top = TopViewController()
        top.owner = model
        top.parseClassName = "Post"
        top.paginationEnabled = true
        top.pullToRefreshEnabled = true
        
        return top
    }
    
    class func CreateWithId(objectId: String) -> TopViewController {
        return CreateWithModel(PFObject(withoutDataWithClassName: "_User", objectId: objectId))
    }
}