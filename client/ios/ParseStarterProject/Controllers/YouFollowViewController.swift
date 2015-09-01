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
import Bolts

@objc(YouFollowViewController) class YouFollowViewController: BaseQuerySearchTableViewController {
    var owner: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "You follow".localized
        self.tableView.backgroundColor = kColorBackgroundViewController
        self.tableView.registerNib(UINib(nibName: kReusableYouFollowViewCell, bundle: nil), forCellReuseIdentifier: kReusableYouFollowViewCell)
        
        self.tableView.estimatedRowHeight = 44.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.tableFooterView = UIView()
        
        self.setupNavigationBar()
    }
    
    override func objectsDidAppend(objects: [AnyObject]) {
        super.objectsDidAppend(objects)
        
        for object in objects {
            if let item  = object as? PFObject {
                
            }
        }
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
        
        if let searchString = self.getSearchText() {
            let subquery = PFQuery(className: kUserClassKey)
            subquery.whereKey(kUserDisplayNameKey, hasPrefix: searchString)
            query.whereKey(kActivityToUserKey, matchesKey: kClassObjectId, inQuery: subquery)
        }
        
        query.orderByDescending(kClassCreatedAt)
        query.includeKey(kActivityToUserKey)
        
        return query
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) {
        
        if let user = Follower.following(object!) {
            Thread.createWithOtherUser(user).continueWithBlock({ (task: BFTask!) -> AnyObject! in
                if task.error == nil {
                    if let thread = task.result as? PFObject {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let controller = ThreadViewController.CreateWithModel(thread)
                            self.navigationController?.pushViewController(controller, animated: true)
                        })
                    }
                } else {
                    //вызвать ошибку
                }
                
                return task
            })
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(kReusableYouFollowViewCell) as? YouFollowViewCell
        
        if let cell = cell {
            cell.prepareView(object!)
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