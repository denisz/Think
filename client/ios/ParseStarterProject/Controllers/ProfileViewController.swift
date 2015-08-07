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
import VGParallaxHeader

@objc(ProfileViewController) class ProfileViewController: StatefulViewController, StatefulViewControllerDelegate {
    var model: PFUser?
    @IBOutlet weak var label: UILabel!
    
    func hasContent() -> Bool {
        return true
    }
    
    func loadModel(model: PFUser) {
        self.model = model
        self.model?.fetchInBackgroundWithBlock{ (user: PFObject?, error: NSError?) -> Void in
            if error == nil && user != nil {
                self.model = user as? PFUser
                self.endLoading(animated: true, error: nil)
                self.setupView()
            } else {
                self.endLoading(animated: true, error: error)
            }
        }
    }
    
    func loadUser(id: String) {
        var query = PFQuery(className:"User")
        query.getObjectInBackgroundWithId(id){ (object: PFObject?, error: NSError?) -> Void in
            if error == nil && object != nil {
                self.model = object as? PFUser
                self.endLoading(animated: true, error: nil)
                self.setupView()
            } else {
                self.endLoading(animated: true, error: error)
            }
        }
        
        self.startLoading(animated: true)
    }
    
    func setupView() {
        println(model)
//        label.text = model!["username"] as? String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    class func CreateWithModel(model: PFUser) -> ProfileViewController{
        var profile = ProfileViewController()
        profile.loadModel(model)
        return profile
    }
    
    class func CreateWithId(id: String) -> ProfileViewController{
        var profile = ProfileViewController()
        profile.loadUser(id)
        return profile
    }
}

