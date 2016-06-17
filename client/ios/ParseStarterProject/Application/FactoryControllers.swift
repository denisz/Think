//
//  MenuControllers.swift
//  Think
//
//  Created by denis zaytcev on 8/21/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import ParseUI

class FactoryControllers {
    class func myProfile() -> UIViewController {
        let user = PFUser.currentUser()
        let controller = ProfileViewController.CreateWithModel(user!)
        
        return controller
    }
    
    class func notifications() -> UIViewController  {
        let user = PFUser.currentUser()
        let controller = NotificationsViewController.CreateWithModel(user!)
        
        return controller
    }
    
    class func followers() -> UIViewController {
        let user = PFUser.currentUser()
        let controller = FollowersViewController.CreateWithModel(user!)
        
        return controller
    }
    
    class func youFollow() -> UIViewController {
        let user = PFUser.currentUser()
        let controller = YouFollowViewController.CreateWithModel(user!)
        
        return controller
    }
    
    class func peopleSearch() -> UIViewController {
        let controller = PeopleSearchViewController.Create()
        return controller
    }
    
    class func feed() -> UIViewController {
        let user = PFUser.currentUser()
        let controller = FeedViewController.CreateWithModel(user!)
        
        return controller
    }
    
    class func top() -> UIViewController {
        let user = PFUser.currentUser()
        let controller = TopViewController.CreateWithModel(user!)
        
        return controller
    }
    
    class func settings() -> UIViewController {
        let controller = SettingsViewController()
        
        return controller
    }
    
    class func drafts() -> UIViewController {
        let user = PFUser.currentUser()
        let controller = DraftsViewController.CreateWithModel(user!)
        
        return controller
    }
    
    class func messages() -> UIViewController {
        let user = PFUser.currentUser()
        let controller = MessagesViewController.CreateWithModel(user!)
        
        return controller
    }
    
    class func newPost() -> UIViewController {
        let controller = NewPostViewController()
        controller.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        controller.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
        return controller
    }
    
    class func bookmarks() -> UIViewController {
        let user = PFUser.currentUser()
        let controller = BookmarksViewController.CreateWithModel(user!)
        
        return controller
    }
}