//
//  AppViewController.swift
//  Think
//
//  Created by denis zaytcev on 8/6/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import Bolts
import LoremIpsum
import ParseUI

@objc(AppViewController) class AppViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Lisa Carter"
        
        self.view.backgroundColor = kColorBackgroundViewController
        
        setupNavigationBar()
    }
    
    override var imageLeftBtn: String {
        return kImageNamedForMenuBtn
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Fade)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default;
    }
    
    override func didTapLeftBtn(sender: UIButton) {
        if let sideMenu = sideMenuController() {
            sideMenu.showLeftViewAnimated(true, completionHandler: nil)
        }
    }
    
    @IBAction func didTapLogout(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        PFUser.logOut()
    }
    
    @IBAction func didTapLogin(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func didTapTest(sender: AnyObject) {
        _ = PFUser.currentUser()
    }
    
    @IBAction func didTapProfile() {
        let user = PFUser.currentUser()
        let controller = ProfileViewController.CreateWithModel(user!)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func didTapNotifications() {
        let user = PFUser.currentUser()
        let controller = NotificationsViewController.CreateWithModel(user!)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func didTapComments() {
    }
    
    @IBAction func didTapFeed() {
        let user = PFUser.currentUser()
        let controller = FeedViewController.CreateWithModel(user!)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func didTapSettings() {
        let controller = SettingsViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func didTapDrafts() {
        let user = PFUser.currentUser()
        let controller = DraftsViewController.CreateWithModel(user!)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func didTapBookmarks() {
        let user = PFUser.currentUser()
        let controller = BookmarksViewController.CreateWithModel(user!)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func didTapNewPost() {
        let controller = NewPostViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func didTapTunePost() {
        let controller = SettingsPostViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func didTapPost() {
        let postID = "AjqOwAuL06"
        let controller = PostViewController.CreateWithId(postID)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func  didTapFollowers() {
        let user = PFUser.currentUser()
        let controller = FollowersViewController.CreateWithModel(user!)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func  didTapYouFollow() {
        let user = PFUser.currentUser()
        let controller = YouFollowViewController.CreateWithModel(user!)
        self.navigationController?.pushViewController(controller, animated: true)
    }


    @IBAction func didTapProfielEdit() {
        let user = PFUser.currentUser()
        let controller = ProfileEditViewController.CreateWithModel(user!)
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
        UIView.setAnimationDuration(0.75)
        self.navigationController?.pushViewController(controller, animated: false)
        UIView.setAnimationTransition(UIViewAnimationTransition.CurlUp , forView: self.navigationController!.view , cache: false)
        UIView.commitAnimations()
    }
    
    
    @IBAction func didTapMessages() {
        let user = PFUser.currentUser()
        let controller = MessagesViewController.CreateWithModel(user!)
        self.navigationController?.pushViewController(controller, animated: true)
    }

    
    @IBAction func didTapPosts() {
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle  {
        return UIStatusBarStyle.Default
    }

    
}