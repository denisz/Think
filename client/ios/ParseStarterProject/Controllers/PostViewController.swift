//
//  PostViewController.swift
//  Think
//
//  Created by denis zaytcev on 8/10/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import ParseUI
import UIKit

class PostViewController: BaseViewController {
    var owner: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
    }
    
    class func CreateWithModel(model: PFObject) -> PostViewController{
        var post = PostViewController()
        post.owner = model
        
        return post
    }
    
    class func CreateWithId(objectId: String) -> PostViewController {
        return CreateWithModel(PFObject(withoutDataWithClassName: "Post", objectId: objectId))
    }
}
