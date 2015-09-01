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
    var stickyView: UIView?
    var headerProfile: BaseProfileHeaderView?
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
        self.setupStickyView()
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        self.tableView.shouldPositionParallaxHeader()
        self.fakeNavigationBar?.alpha   = self.tableView.parallaxHeader.progress
        self.stickyView?.alpha          = 1 - self.tableView.parallaxHeader.progress
    }
    
    func setupStickyView() {
        let frame = CGRectMake(0, 0, 320, 20)
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor(red:0.33, green:0.39, blue:0.42, alpha:1)
        view.alpha = 0
        
        self.view.addSubview(view)
        self.stickyView = view
        
        BaseUIView.constraintToTop(view, size: frame.size, offset: 0)
    }
    
    func setupHeaderView() {
        if !self.isGuest {
            var headerProfile = ProfileHeaderView()
            self.headerProfile = headerProfile
            headerProfile.delegate = self
        } else {
            var headerProfileGuest = ProfileGuestHeaderView()
            self.headerProfile = headerProfileGuest
            headerProfileGuest.delegate = self
        }
        
        self.tableView.setParallaxHeaderView( self.headerProfile!, mode: VGParallaxHeaderMode.Fill, height: 240)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.customizeNavigationBar(.Transparent)
        self.configureNavigationBarBackBtn(UIColor.whiteColor())
        
        self.headerProfile?.objectDidLoad(self.owner!)
        
        if !self.isGuest {
            self.configureNavigationBarRightBtn(UIColor.whiteColor())
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
    }
    
    func configureNavigationBarRightBtn(color: UIColor) {
        let navigationItem  = self.defineNavigationItem()

        let editBarButtonItem = UIBarButtonItem(title: "Edit".uppercaseString.localized, style: UIBarButtonItemStyle.Plain, target: self, action: "didTapEdit:")
        
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
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if iOS8 {
            return UITableViewAutomaticDimension
        } else {
            return 420
        }
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
        profile.parseClassName = kPostClassKey
        profile.paginationEnabled = true
        profile.pullToRefreshEnabled = false

        return profile
    }
    
    class func CreateWithId(objectId: String) -> ProfileViewController {
        return CreateWithModel(PFObject(withoutDataWithClassName: kUserClassKey, objectId: objectId))
    }
}

extension ProfileViewController: ProfileGuestHeaderViewDelegate {
    func profileGuestView(view: ProfileGuestHeaderView, didTapFollow button: UIButton) {
        Activity.handlerFollowUser(self.owner!)
    }
    
    func profileGuestView(view: ProfileGuestHeaderView, didTapWhisper button: UIButton) {
        let overlay = OverlayView.createInView(self.view)
        Thread.createWithOtherUser(self.owner!).continueWithBlock { (task: BFTask!) -> AnyObject! in
            dispatch_async(dispatch_get_main_queue()) {
                overlay.removeFromSuperview()
            }
            if task.error == nil{
                if let thread = task.result as? PFObject {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
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
}

extension ProfileViewController: ProfileHeaderViewDelegate {
    func profileView(view: ProfileHeaderView, didTapDrafts button: UIButton) {
        let controller = FactoryControllers.drafts()
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
        let controller = FactoryControllers.youFollow()
        self.navigationController?.pushViewController(controller, animated: true)

    }
}

