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

@objc(NotificationsViewController) class NotificationsViewController: BaseQueryTableViewController {
    var owner: PFObject?
    var filterTypeNotifications: [AnyObject] = [kActivityTypeFollow, kActivityTypeComment, kActivityTypeLike]
    var notificationFilterView: NotificationFilterView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Notifications"
        self.view.backgroundColor = kColorBackgroundViewController
        self.tableView.backgroundColor = kColorBackgroundViewController
        self.tableView.registerNib(UINib(nibName: kReusableNotificationsViewCell, bundle: nil), forCellReuseIdentifier: kReusableNotificationsViewCell)
        
        self.tableView.estimatedRowHeight = 44.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.tableFooterView = UIView()
        
        self.setupNavigationBar()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.configureTitleView()
        self.customizeNavigationBar()
        self.configureNavigationBarRightBtn(kColorNavigationBar)
        self.configureNavigationBarBackBtn(kColorNavigationBar)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)
    }
    
    func configureNavigationBarRightBtn(color: UIColor) {
        let navigationItem = self.defineNavigationItem()
        
        var image = UIImage(named: "ic_settings_notify") as UIImage!
        image = image.imageWithColor(color)
        
        var btnBack:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        btnBack.addTarget(self, action: "didTapSettingsBtn:", forControlEvents: UIControlEvents.TouchUpInside)
        btnBack.setImage(image, forState: UIControlState.Normal)
        btnBack.contentEdgeInsets = UIEdgeInsets(top: -5, left: 0, bottom: 0, right: 0)
        btnBack.imageEdgeInsets = UIEdgeInsets(top: 14, left: 28, bottom: 14, right: 0)
        btnBack.setTitleColor(kColorNavigationBar, forState: UIControlState.Normal)
        btnBack.sizeToFit()
        
        let myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: btnBack)
        navigationItem.rightBarButtonItem  = myCustomBackButtonItem
    }
    
    func didTapSettingsBtn(sender: AnyObject?) {
        self.didTapTitle()
    }
    
    override func didTapTitle() {
        let innerView = NotificationFilterView()
        innerView.selectedItems = self.filterTypeNotifications as? [String]
        innerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 3 * 64)
        self.showFilterUnderTitle(innerView)
        self.notificationFilterView = innerView
    }
    
    //todo: добавить список типов активности
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: kActivityClassKey)
        //чекаем кто меняет лайкает следит комментирует мои посты
        query.whereKey(kActivityTypeKey, containedIn: self.filterTypeNotifications)
        query.whereKey(kActivityToUserKey, equalTo: self.owner!)
        query.whereKey(kActivityFromUserKey, notEqualTo: self.owner!)
        query.includeKey(kActivityFromUserKey)
        query.orderByDescending(kClassCreatedAt)
        
        return query
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) {
        let controller = ProfileViewController.CreateWithModel(object!)
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle  {
        return UIStatusBarStyle.Default
    }
    
    override func filterViewWillDismiss() {
        let newFilters = self.notificationFilterView?.selectedItems
        let oldFilters = self.filterTypeNotifications as? [String]
        
        
        if newFilters?.count != oldFilters?.count {
            self.filterTypeNotifications = newFilters!
            self.loadObjects()
        }
        
        self.notificationFilterView = nil
    }
    
    class func CreateWithModel(model: PFObject) -> NotificationsViewController {
        var notifications = NotificationsViewController()
        notifications.owner = model
        notifications.parseClassName = kActivityClassKey
        notifications.paginationEnabled = true
        notifications.pullToRefreshEnabled = true
        
        return notifications
    }
    
    class func CreateWithId(objectId: String) -> NotificationsViewController {
        return CreateWithModel(PFObject(withoutDataWithClassName: kUserClassKey, objectId: objectId))
    }
}