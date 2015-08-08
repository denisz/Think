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
        self.tableView.registerNib(UINib(nibName: kReusableFeedPostViewCell, bundle: nil), forCellReuseIdentifier: kReusableFeedPostViewCell)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.setTranslatesAutoresizingMaskIntoConstraints(false);
        self.tableView.estimatedRowHeight = 44.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.tableFooterView = UIView()
    }
    
    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: self.parseClassName!)
        query.whereKey("owner", equalTo: owner!)
        query.orderByDescending("createdAt")
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        let cell = tableView.dequeueReusableCellWithIdentifier(kReusableFeedPostViewCell) as! FeedPostViewCell
        cell.prepareView(object!)
        return cell
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default;
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle  {
        return UIStatusBarStyle.LightContent
    }
    
    class func CreateWithModel(model: PFObject) -> FeedViewController {
        var feed = FeedViewController()
        
        feed.parseClassName = "Post"
        feed.paginationEnabled = true
        feed.pullToRefreshEnabled = true
        feed.objectsPerPage = 25
        feed.owner = model
        return feed
    }
    
    class func CreateWithId(objectId: String) -> FeedViewController {
        return CreateWithModel(PFObject(withoutDataWithClassName: "_User", objectId: objectId))
    }
}