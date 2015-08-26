//
//  FollowViewController.swift
//  Think
//
//  Created by denis zaytcev on 8/13/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import ParseUI

@objc(YouFollowViewController) class YouFollowViewController: BaseQueryTableViewController {
    var owner: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "You follow"
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
    }
    
    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: self.parseClassName!)
        query.whereKey(kActivityFromUserKey, equalTo: owner!)
        query.whereKey(kActivityTypeKey, equalTo: kActivityTypeFollow)
        query.orderByDescending(kClassCreatedAt)
        query.includeKey(kActivityToUserKey)
        
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(kReusableFollowUserViewCell) as?FollowUserViewCell
        
        if let cell = cell {
            cell.prepareView(object!)
        }
        
        return cell
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle  {
        return UIStatusBarStyle.LightContent
    }
    
    class func CreateWithModel(model: PFObject) -> YouFollowViewController{
        var follow = YouFollowViewController()
        follow.owner = model
        follow.parseClassName = kActivityClassKey
        follow.paginationEnabled = true
        follow.pullToRefreshEnabled = false
        
        return follow
    }
    
    class func CreateWithId(objectId: String) -> YouFollowViewController {
        return CreateWithModel(PFObject(withoutDataWithClassName: kUserClassKey, objectId: objectId))
    }

}