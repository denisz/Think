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
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        self.tableView.shouldPositionParallaxHeader();
    }
    
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: self.parseClassName!)
//        query.whereKey("owner", equalTo: owner!)
        query.whereKey(kPostStatusKey, equalTo: kPostStatusPublic)
        query.orderByDescending(kPostCounterLikesKey)
        query.addDescendingOrder(kClassCreatedAt)//по созданию
        query.includeKey(kPostOwnerKey)
        query.selectKeys([kPostTitleKey, kPostTintColor, kPostContentShortKey, kPostCounterCommentsKey, kPostCounterLikesKey, kPostOwnerKey, kPostCoverKey, kClassCreatedAt])

        
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        let cell = tableView.dequeueReusableCellWithIdentifier(kReusableProfilePostViewCell) as! ProfilePostViewCell
        
        cell.prepareView(object!)
        cell.parentViewController = self
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if iOS8 {
            return UITableViewAutomaticDimension
        } else {
            return 420
        }
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
        let top = TopViewController()
        top.owner = model
        top.parseClassName = kPostClassKey
        top.paginationEnabled = true
        top.pullToRefreshEnabled = true
        
        return top
    }
    
    class func CreateWithId(objectId: String) -> TopViewController {
        return CreateWithModel(PFObject(withoutDataWithClassName: kUserClassKey, objectId: objectId))
    }
}