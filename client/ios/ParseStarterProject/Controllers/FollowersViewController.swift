//
//  FollowersViewController.swift
//  Think
//
//  Created by denis zaytcev on 8/10/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit
import Parse
import ParseUI

@objc(FollowersViewController) class FollowersViewController: BaseQueryTableViewController {
    var owner: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Followers".localized
        
        self.tableView.backgroundColor = kColorBackgroundViewController
        self.tableView.registerNib(UINib(nibName: kReusableFollowUserViewCell, bundle: nil), forCellReuseIdentifier: kReusableFollowUserViewCell)
        
        self.tableView.estimatedRowHeight = 44.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.tableFooterView = UIView()
        
        self.setupNavigationBar()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.customizeNavigationBar()
        self.configureNavigationBarBackBtn(kColorNavigationBar)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)
//        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default;
    }

    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: self.parseClassName!)
        query.whereKey(kActivityToUserKey, equalTo: self.owner!)
        query.whereKey(kActivityTypeKey, equalTo: kActivityTypeFollow)
        
        query.orderByDescending("createdAt")
        query.includeKey(kActivityFromUserKey)
        
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        let cell = tableView.dequeueReusableCellWithIdentifier(kReusableFollowUserViewCell) as! FollowUserViewCell
        
        if let user = object![kActivityFromUserKey] as? PFObject {
            cell.prepareView(user)
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if iOS8 {
            return UITableViewAutomaticDimension
        } else {
            return 78
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle  {
        return UIStatusBarStyle.LightContent
    }
    
    class func CreateWithModel(model: PFObject) -> FollowersViewController{
        let followers = FollowersViewController()
        followers.owner = model
        followers.parseClassName = kActivityClassKey
        followers.paginationEnabled = true
        followers.pullToRefreshEnabled = true
        
        return followers
    }
    
    class func CreateWithId(objectId: String) -> FollowersViewController {
        return CreateWithModel(PFObject(withoutDataWithClassName: kUserClassKey, objectId: objectId))
    }
}