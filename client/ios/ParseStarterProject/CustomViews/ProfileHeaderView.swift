//
//  ProfileHeader.swift
//  Think
//
//  Created by denis zaytcev on 8/7/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit
import Parse
import ParseUI


protocol ProfileHeaderViewDelegate {
    func profileView(view: ProfileHeaderView, didTapFollowers button: UIButton)
    func profileView(view: ProfileHeaderView, didTapDrafts button: UIButton)
    func profileView(view: ProfileHeaderView, didTapNewPost button: UIButton)
}

class ProfileHeaderView: BaseProfileHeaderView {
    @IBOutlet weak var newPostButton: UIButton!
    @IBOutlet weak var draftsButton: UIButton!
    @IBOutlet weak var followersButton: UIButton!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profilePicture: PFImageView!
    @IBOutlet weak var profileCover: PFImageView!
    
    var delegate: ProfileHeaderViewDelegate?
    
    override var nibName: String? {
        return "ProfileHeaderView"
    }
    
    @IBAction func didTapFollowers(sender: AnyObject?) {
        self.delegate?.profileView(self, didTapFollowers: self.followersButton)
    }
    
    @IBAction func didTapNewPost(sender: AnyObject?) {
        self.delegate?.profileView(self, didTapNewPost: self.newPostButton)
    }
    
    @IBAction func didTapDrafts(sender: AnyObject?) {
        self.delegate?.profileView(self, didTapDrafts: self.draftsButton)
    }
    
    override func viewDidLoadObject(object: PFObject) {
        super.viewDidLoadObject(object)
        self.profileName.text = object[kUserUsernameKey] as? String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.newPostButton.borderLeft(UIColor.lightGrayColor())
        self.draftsButton.borderLeft(UIColor.lightGrayColor())
        
        self.profilePicture.cornerEdge()
    }
}