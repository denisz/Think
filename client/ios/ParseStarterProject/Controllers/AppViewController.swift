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
import ParseUI

@objc(AppViewController) class AppViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Lisa Carter"
        
        self.view.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1)
    }
    
    override var imageLeftBtn: String {
        return kImageNamedForMenuBtn
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
    
    @IBAction func didTapLogout(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        PFUser.logOut()
    }
    
    @IBAction func didTapLogin(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func didTapTest(sender: AnyObject) {
        var user = PFUser.currentUser()
    }
    
    @IBAction func didTapProfile() {
        var user = PFUser.currentUser()
        let controller = ProfileViewController.CreateWithModel(user!)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func didTapNotifications() {
        var user = PFUser.currentUser()
        let controller = NotificationsViewController.CreateWithModel(user!)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func didTapComments() {
        let controller = CommentsViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func didTapFeed() {
        var user = PFUser.currentUser()
        let controller = FeedViewController.CreateWithModel(user!)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func didTapSettings() {
        let controller = SettingsViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func didTapDrafts() {
        var user = PFUser.currentUser()
        let controller = DraftsViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func didTapBookmarks() {
        var user = PFUser.currentUser()
        let controller = BookmarksViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }

    
    @IBAction func didTapPosts() {
        var user = PFUser.currentUser()
        
        var myPost = PFObject(className:"Post")
        myPost["title"] = "I'm Hungry"
        myPost["content"] = "Where should we go for lunch?"
        myPost["owner"] = user//PFObject(withoutDataWithClassName:"_User", objectId:user?.objectId)
//        myPost.saveInBackground()

        // Create the comment
        var myComment = PFObject(className:"Comment")
        myComment["content"] = "Let's do Sushirrito."
//
//        // Add a relation between the Post and Comment
        myComment["parent"] = myPost
        myComment["owner"] = user
        
        // This will save both myPost and myComment
        myComment.saveInBackground()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle  {
        return UIStatusBarStyle.Default
    }

    
}