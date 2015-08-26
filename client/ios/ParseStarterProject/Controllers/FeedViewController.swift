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

@objc(FeedViewController) class FeedViewController: BaseQueryTableViewController {
    var owner: PFObject?
    var scrollDirection = ScrollDirection()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Feed"
        self.tableView.registerNib(UINib(nibName: kReusableProfilePostViewCell, bundle: nil), forCellReuseIdentifier: kReusableProfilePostViewCell)
        
        self.tableView.estimatedRowHeight = 44.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.tableFooterView = UIView()
        
        self.setupNavigationBar()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.configureTitleView()
        self.customizeNavigationBar()
        self.configureNavigationRightBtns()
        self.configureNavigationBarBackBtn(kColorNavigationBar)
    }
    
    func configureNavigationRightBtns() {
        let navigationItem  = self.defineNavigationItem()
        let newPost         = self.configureNavigationBarRightBtn(kColorNavigationBar)
        let counterPost     = self.configureCounterView()
        navigationItem.setRightBarButtonItems([newPost, counterPost], animated: true)
    }
    
    func configureCounterView() -> UIBarButtonItem {
        let counterButton  = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        counterButton.backgroundColor = UIColor(red:0, green:0.64, blue:0.85, alpha:1)
        counterButton.frame = CGRectMake(0, 0, 40, 24)  // Size
        counterButton.setTitle("2", forState: UIControlState.Normal)
        counterButton.titleLabel!.font = UIFont(name: "OpenSans-Bold", size: 14)
        counterButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        counterButton.cornerEdge()
        counterButton.addTarget(self, action: "didTapCounterBtn:", forControlEvents: UIControlEvents.TouchUpInside)

        return UIBarButtonItem(customView: counterButton)
    }
    
    func configureNavigationBarRightBtn(color: UIColor) -> UIBarButtonItem {
        var image = UIImage(named: "ic_new_post") as UIImage!
        image = image.imageWithColor(color)
        
        let btnBack = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        btnBack.addTarget(self, action: "didTapNewPostBtn:", forControlEvents: UIControlEvents.TouchUpInside)
        btnBack.setImage(image, forState: UIControlState.Normal)
        btnBack.imageEdgeInsets = UIEdgeInsets(top: 1, left: 0, bottom: 2, right: 0)
        btnBack.setTitleColor(kColorNavigationBar, forState: UIControlState.Normal)
        btnBack.frame = CGRectMake(0, 0, 30, 32)
        
        return UIBarButtonItem(customView: btnBack)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)
    }
    
    func didTapCounterBtn(sender: AnyObject?) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func didTapNewPostBtn(sender: AnyObject?) {
        let controller = NewPostViewController()
        controller.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        controller.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
        
        let navigation = BaseNavigationController(rootViewController: controller)
        
        self.presentViewController(navigation, animated: true, completion: nil)
    }
    
    override func queryForTable() -> PFQuery {

        let followingActivitiesQuery = PFQuery(className: kActivityClassKey)
        followingActivitiesQuery.whereKey(kActivityTypeKey, equalTo: kActivityTypeFollow)
        followingActivitiesQuery.whereKey(kActivityFromUserKey, equalTo: self.owner!)
        
        let postsFromFollowedUsersQuery = PFQuery(className: kPostClassKey)
        postsFromFollowedUsersQuery.whereKey(kPostOwnerKey, matchesKey: kActivityToUserKey, inQuery: followingActivitiesQuery)
        
        let postsFromCurrentUserQuery = PFQuery(className: kPostClassKey)
        postsFromCurrentUserQuery.whereKey(kPostOwnerKey, equalTo: self.owner!)
        postsFromCurrentUserQuery.whereKey(kPostStatusKey, equalTo: kPostStatusPublic)
        
        let query = PFQuery.orQueryWithSubqueries([postsFromFollowedUsersQuery, postsFromCurrentUserQuery])
        query.includeKey(kPostOwnerKey)
        query.orderByDescending(kClassCreatedAt)
        
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
    
    class func CreateWith() -> FeedViewController {
        let user = PFUser.currentUser()!
        return CreateWithModel(user)
    }
    
    class func CreateWithModel(model: PFObject) -> FeedViewController{
        var feed = FeedViewController()
        feed.owner = model
        feed.parseClassName = kActivityClassKey
        feed.paginationEnabled = true
        feed.pullToRefreshEnabled = true
        
        
        return feed
    }
    
    class func CreateWithId(objectId: String) -> FeedViewController {
        return CreateWithModel(PFObject(withoutDataWithClassName: kUserClassKey, objectId: objectId))
    }
}