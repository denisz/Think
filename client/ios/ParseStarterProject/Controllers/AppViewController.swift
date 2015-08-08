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

@objc(AppViewController) class AppViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTapLogout(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        PFUser.logOut()
    }
    
    @IBAction func didTapLogin(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func didTapProfile(sender: AnyObject) {
        var user = PFUser.currentUser()

//        var myPost = PFObject(className:"Post")
//        myPost["title"] = "I'm Hungry"
//        myPost["content"] = "Where should we go for lunch?"
//        myPost["owner"] = user//PFObject(withoutDataWithClassName:"_User", objectId:user?.objectId)
////        myPost.saveInBackground()
//        
//        // Create the comment
//        var myComment = PFObject(className:"Comment")
//        myComment["content"] = "Let's do Sushirrito."
////
////        // Add a relation between the Post and Comment
//        myComment["parent"] = myPost
//        myComment["owner"] = user
//        
//        // This will save both myPost and myComment
//        myComment.saveInBackground()
//
//        var query = PFQuery(className:"Post")
//        query.whereKey("owner", equalTo:user!)
//        query.findObjectsInBackgroundWithBlock {
//            (objects: [AnyObject]?, error: NSError?) -> Void in
//            
//            if error == nil {
//                // The find succeeded.
//                println("Successfully retrieved \(objects!.count) scores.")
//                // Do something with the found objects
//                if let objects = objects as? [PFObject] {
//                    for object in objects {
//                        println(object.objectId)
//                    }
//                }
//            } else {
//                // Log details of the failure
//                println("Error: \(error!) \(error!.userInfo!)")
//            }
//        }
        
        
//        let profile = ProfileViewController.CreateWithModel(PFUser.currentUser()!)
        let controller = ProfileViewController.CreateWithModel(user!)
//        self.presentViewController(profile, animated: true, completion: nil)
        
        
//        let controller = FeedViewController.CreateWithModel(user!)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}