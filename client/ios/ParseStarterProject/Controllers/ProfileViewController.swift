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

@objc(ProfileViewController) class ProfileViewController: BaseQueryTableViewController {
    var owner: PFObject?
    
    var isGuest: Bool {
        if let currentUser = PFUser.currentUser() {
            if owner?.objectId == currentUser.objectId {
                return false
            }
        }
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.setupHeaderView()
        
        self.tableView.registerNib(UINib(nibName: kReusableProfilePostViewCell, bundle: nil), forCellReuseIdentifier: kReusableProfilePostViewCell)

        self.tableView.estimatedRowHeight = 44.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.tableFooterView = UIView()
        
        self.setupNavigationBar()
    }
    
    func setupHeaderView() {
        var header: UIView?

        if !self.isGuest {
            var headerProfile = ProfileHeaderView()
            headerProfile.delegate = self
            headerProfile.object = self.owner
            header = headerProfile
        } else {
            var headerProfileGuest = ProfileGuestHeaderView()
            headerProfileGuest.delegate = self
            headerProfileGuest.object = self.owner
            header = headerProfileGuest
        }
        
        self.tableView.setParallaxHeaderView(header!, mode: VGParallaxHeaderMode.Fill, height: 240)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.customizeNavigationBar(.Transparent)
        self.configureNavigationBarBackBtn(UIColor.whiteColor())
        
        if !self.isGuest {
            self.configureNavigationBarRightBtn(UIColor.whiteColor())
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent;
    }
    
    func configureNavigationBarRightBtn(color: UIColor) {
        let navigationItem  = self.defineNavigationItem()

        let editBarButtonItem = UIBarButtonItem(title: "Edit".uppercaseString, style: UIBarButtonItemStyle.Plain, target: self, action: "didTapEdit:")
        
        let attributes = [
            NSForegroundColorAttributeName: color,
            NSFontAttributeName: kFontNavigationItem
        ]
        editBarButtonItem.setTitleTextAttributes(attributes, forState: UIControlState.Normal)
        navigationItem.rightBarButtonItem = editBarButtonItem
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
        self.tableView.shouldPositionParallaxHeader()
    }
    
    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: self.parseClassName!)
        query.whereKey(kPostOwnerKey, equalTo: owner!)
        query.whereKey(kPostStatusKey, equalTo: kPostStatusPublic)
        query.selectKeys([kPostTitleKey, kPostContentShortKey, kPostCounterCommentsKey, kPostCounterLikesKey, kPostOwnerKey, kPostCoverKey, kClassCreatedAt])
        query.orderByDescending(kClassCreatedAt)
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        let cell = tableView.dequeueReusableCellWithIdentifier(kReusableProfilePostViewCell) as! ProfilePostViewCell
        cell.prepareView(object!)
        cell.parentViewController = self
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) {

        let controller = PostViewController.CreateWithModel(object!)
        self.navigationController?.pushViewController(controller, animated: true)
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

extension ProfileViewController: ProfileGuestHeaderViewDelegate {
    func profileGuestView(view: ProfileGuestHeaderView, didTapFollow button: UIButton) {
        //зафоллофим
    }
    
    func profileGuestView(view: ProfileGuestHeaderView, didTapWhisper button: UIButton) {
        let controller = ChannelViewController.CreateWithModel(self.owner!)
        self.navigationController?.pushViewController(controller, animated: true)
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
        
        let navigation = BaseNavigationController(rootViewController: controller)
        
        self.presentViewController(navigation, animated: true, completion: nil)
    }
    
    func profileView(view: ProfileHeaderView, didTapFollowers button: UIButton) {
        var user = PFUser.currentUser()
        let controller = FollowersViewController.CreateWithModel(user!)
        self.navigationController?.pushViewController(controller, animated: true)

    }
}

