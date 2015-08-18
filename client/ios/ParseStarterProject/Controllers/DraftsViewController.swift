//
//  DraftsViewController.swift
//  Think
//
//  Created by denis zaytcev on 8/9/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import ParseUI
import UIKit

let kReusableDraftsViewCell = "DraftsViewCell"

@objc(DraftsViewController) class DraftsViewController: BaseQueryTableViewController {
    var owner: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Drafts"
        self.tableView.registerNib(UINib(nibName: kReusableDraftsViewCell, bundle: nil), forCellReuseIdentifier: kReusableDraftsViewCell)
        
        self.view.backgroundColor = kColorBackgroundViewController
        
        self.tableView.backgroundColor = kColorBackgroundViewController
        self.tableView.estimatedRowHeight = 250.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.separatorColor = UIColor(red:0, green:0.64, blue:0.85, alpha:1)
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
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default;
    }
    
    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: self.parseClassName!)
        query.whereKey("owner", equalTo: owner!)
        query.orderByDescending("createdAt")
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        let cell = tableView.dequeueReusableCellWithIdentifier(kReusableDraftsViewCell) as! DraftsViewCell
        cell.prepareView(object!)
        return cell
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle  {
        return UIStatusBarStyle.Default
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]?  {
        var shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Public".localized , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            tableView.editing = false;
            
        })
        shareAction.backgroundColor = UIColor(red:0.22, green:0.79, blue:0.45, alpha:1)
        
        var rateAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete".localized , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            tableView.editing = false;
        })
        rateAction.backgroundColor = UIColor(red:0.9, green:0.3, blue:0.26, alpha:1)
        
        return [shareAction,rateAction]
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) {
        let controller = PostViewController.CreateWithModel(object!)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    class func CreateWithModel(model: PFObject) -> DraftsViewController{
        var drafts = DraftsViewController()
        drafts.owner = model
        drafts.parseClassName = "Post"
        drafts.paginationEnabled = true
        drafts.pullToRefreshEnabled = false
        
        
        return drafts
    }
    
    class func CreateWithId(objectId: String) -> DraftsViewController {
        return CreateWithModel(PFObject(withoutDataWithClassName: "_User", objectId: objectId))
    }

}