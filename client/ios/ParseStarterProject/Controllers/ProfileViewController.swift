//
//  ProfileViewController.swift
//  Think
//
//  Created by denis zaytcev on 8/7/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import ParseUI
import UIKit
import Bolts
import VGParallaxHeader

let kReusableProfilePostViewCell = "ProfilePostViewCell"

@objc(ProfileViewController) class ProfileViewController: BaseQueryTableViewContoller {
    var owner: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var header = ProfileHeaderView()
        header.object = self.owner
        header.delegate = self
        self.tableView.setParallaxHeaderView(header, mode: VGParallaxHeaderMode.Fill, height: 240)
        self.tableView.registerNib(UINib(nibName: kReusableProfilePostViewCell, bundle: nil), forCellReuseIdentifier: kReusableProfilePostViewCell)

        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 44.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.tableFooterView = UIView()
        
        self.customizeNavigationBar()
        self.configureNavigationBarBackBtn(UIColor.whiteColor())
    }
    
    override func customizeNavigationBar() {
        self.automaticallyAdjustsScrollViewInsets = false
        var navigationBar = self.navigationController?.navigationBar
        
        // Sets background to a blank/empty image
        navigationBar?.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        // Sets shadow (line below the bar) to a blank image
        navigationBar?.shadowImage = UIImage()
        // Sets the translucent background color
        navigationBar?.backgroundColor = UIColor.clearColor()
        //UIColor(red:0, green:0, blue:0, alpha:0.5)
            //
        // Set translucent. (Default value is already true, so this can be removed if desired.)
        navigationBar?.translucent = true
        
        let editBarButtonItem = UIBarButtonItem(title: "Edit".uppercaseString, style: UIBarButtonItemStyle.Plain, target: self, action: "didTapEdit:")
        let attributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "OpenSans-Light", size: 18)!
        ]
        editBarButtonItem.setTitleTextAttributes(attributes, forState: UIControlState.Normal)
        self.navigationItem.rightBarButtonItem = editBarButtonItem
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent;
    }
    
    func didTapEdit(sender: AnyObject?) {
        let controller = ProfileEditViewController.CreateWithModel(owner!)
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
        UIView.setAnimationDuration(0.75)
        self.navigationController?.pushViewController(controller, animated: false)
        UIView.setAnimationTransition(UIViewAnimationTransition.CurlUp , forView: self.navigationController!.view , cache: false)
        UIView.commitAnimations()
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        self.tableView.shouldPositionParallaxHeader();
    }
    
    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: self.parseClassName!)
        query.whereKey("owner", equalTo: owner!)
        query.orderByDescending("createdAt")
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        let cell = tableView.dequeueReusableCellWithIdentifier(kReusableProfilePostViewCell) as! ProfilePostViewCell
        cell.prepareView(object!)
        return cell
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle  {
        return UIStatusBarStyle.LightContent
    }
    
    
    class func CreateWithModel(model: PFObject) -> ProfileViewController{
        var profile = ProfileViewController()
        profile.owner = model
        profile.parseClassName = "Post"
        profile.paginationEnabled = true
        profile.pullToRefreshEnabled = false

        
        return profile
    }
    
    class func CreateWithId(objectId: String) -> ProfileViewController {
        return CreateWithModel(PFObject(withoutDataWithClassName: "_User", objectId: objectId))
    }
}


extension ProfileViewController: ProfileHeaderViewDelegate {
    func profileView(view: ProfileHeaderView, didTapDrafts button: UIButton) {
        let controller = DraftsViewController.CreateWithModel(owner!)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func profileView(view: ProfileHeaderView, didTapNewPost button: UIButton) {
        let controller = NewPostViewController()
        controller.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        controller.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen

        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func profileView(view: ProfileHeaderView, didTapFollowers button: UIButton) {
        
    }
}

