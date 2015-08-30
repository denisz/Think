//
//  PeopleSearchViewController.swift
//  Think
//
//  Created by denis zaytcev on 8/27/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//
import Foundation
import Parse
import ParseUI
import Bolts

@objc(PeopleSearchViewController) class PeopleSearchViewController: BaseQuerySearchTableViewController {
    var owner: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "People search"
        self.tableView.backgroundColor = kColorBackgroundViewController
        self.tableView.registerNib(UINib(nibName: kReusablePeopleViewCell, bundle: nil), forCellReuseIdentifier: kReusablePeopleViewCell)
        
        self.tableView.estimatedRowHeight = 44.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.tableFooterView = UIView()
        
        self.setupNavigationBar()
        
    }
    
    override func objectsDidLoad(error: NSError?) {
        super.objectsDidLoad(error)
        
        if error == nil {
            //обновить кеш follower
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
        let user = PFUser.currentUser()
        let query = PFQuery(className: kUserClassKey)
        
        if let searchString = self.getSearchText() {
            query.whereKey(kUserUsernameKey, hasPrefix: searchString)
        }
        
        query.whereKey(kClassObjectId, notEqualTo: user!.objectId!)//исключаем тек пользователя
        
        return query
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) {
        let overlay = OverlayView.createInView(self.view)
        Thread.createWithOtherUser(object!).continueWithBlock { (task: BFTask!) -> AnyObject! in
            dispatch_async(dispatch_get_main_queue()) {
                overlay.removeFromSuperview()
            }
            if task.error == nil{
                if let thread = task.result as? PFObject {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        println(thread)
                        let controller = ThreadViewController.CreateWithModel(thread)
                        self.navigationController?.pushViewController(controller, animated: true)
                    })
                }
            } else {
                //не смог создать thread
            }
            
            return task
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(kReusablePeopleViewCell) as? PeopleViewCell
        
        if let cell = cell {
            cell.prepareView(object!)
        }
        
        return cell
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle  {
        return UIStatusBarStyle.LightContent
    }
    
    class func Create() -> PeopleSearchViewController {
        var search = PeopleSearchViewController()
        search.parseClassName = kUserClassKey
        search.paginationEnabled = true
        search.pullToRefreshEnabled = false
        
        return search
    }
    
}