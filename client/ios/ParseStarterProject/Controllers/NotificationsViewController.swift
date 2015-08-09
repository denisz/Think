//
//  NotificationsViewController.swift
//  Think
//
//  Created by denis zaytcev on 8/9/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import ParseUI
import UIKit
import Bolts
import LGFilterView

let kReusableNotificationsViewCell = "NotificationViewCell"

@objc(NotificationsViewController) class NotificationsViewController: BaseQueryTableViewContoller {
    var owner: PFObject?
    var filterView: LGFilterView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Notifications"
        self.view.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1)
        self.tableView.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1)
        self.tableView.registerNib(UINib(nibName: kReusableNotificationsViewCell, bundle: nil), forCellReuseIdentifier: kReusableNotificationsViewCell)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 44.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.tableFooterView = UIView()
        
        self.configureTitleView()
        self.customizeNavigationBar()
        self.configureNavigationBarSettingsBtn(UIColor(red:0.2, green:0.2, blue:0.2, alpha:1))
        self.configureNavigationBarBackBtn(UIColor(red:0.2, green:0.2, blue:0.2, alpha:1))
    }
    
    override var imageLeftBtn: String {
        return kImageNamedForMenuBtn
    }
    
    func configureNavigationBarSettingsBtn(color: UIColor) {
        var image = UIImage(named: "ic_settings_notify") as UIImage!
        image = image.imageWithColor(color)
        
        var btnBack:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        btnBack.addTarget(self, action: "didTapSettingsBtn:", forControlEvents: UIControlEvents.TouchUpInside)
        btnBack.setImage(image, forState: UIControlState.Normal)
        btnBack.contentEdgeInsets = UIEdgeInsets(top: -5, left: 0, bottom: 0, right: 0)
        btnBack.imageEdgeInsets = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        btnBack.setTitleColor(UIColor(red:0.2, green:0.2, blue:0.2, alpha:1), forState: UIControlState.Normal)
        btnBack.sizeToFit()
        var myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: btnBack)
        self.navigationItem.rightBarButtonItem  = myCustomBackButtonItem
    }
    
    func didTapSettingsBtn(sender: AnyObject?) {
        self.didTapFilter()
    }
    
    override func didTapFilter() {
        
        if let filterView = self.filterView {
            filterView.dismissAnimated(true, completionHandler: nil)
            self.filterView = nil
        } else {
            var innerView = NotificationFilterView()
            innerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 5 * 64)
            self.filterView = LGFilterView(view: innerView)
            filterView?.transitionStyle = LGFilterViewTransitionStyleTop
            filterView?.heightMax = 5 * 64
            filterView?.borderWidth = 0
            filterView?.backgroundColor = UIColor.whiteColor()
            
            filterView?.showInView(self.view, animated: true, completionHandler: nil)
        }
    }
    
    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: self.parseClassName!)
        query.whereKey("owner", equalTo: owner!)
        query.orderByDescending("createdAt")
        return query
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default;
    }
    
    override func didTapLeftBtn(sender: UIButton) {
        if let sideMenu = sideMenuController() {
            sideMenu.showLeftViewAnimated(true, completionHandler: nil)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        let cell = tableView.dequeueReusableCellWithIdentifier(kReusableNotificationsViewCell) as! NotificationViewCell
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false

        cell.prepareView(object!)
        return cell
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle  {
        return UIStatusBarStyle.Default
    }
    
    class func CreateWithModel(model: PFObject) -> NotificationsViewController {
        var notifications = NotificationsViewController()
        notifications.owner = model
        notifications.parseClassName = "Post"
        notifications.paginationEnabled = true
        notifications.pullToRefreshEnabled = false
        
        return notifications
    }
    
    class func CreateWithId(objectId: String) -> NotificationsViewController {
        return CreateWithModel(PFObject(withoutDataWithClassName: "_User", objectId: objectId))
    }
}
