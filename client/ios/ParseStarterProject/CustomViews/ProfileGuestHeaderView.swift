//
//  ProfileGuestHeaderView.swift
//  Think
//
//  Created by denis zaytcev on 8/13/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import ParseUI

protocol ProfileGuestHeaderViewDelegate {
    func profileGuestView(view: ProfileGuestHeaderView, didTapFollow button: UIButton)
    func profileGuestView(view: ProfileGuestHeaderView, didTapWhisper button: UIButton)
}

class ProfileGuestHeaderView: BaseProfileHeaderView {
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var whisperButton: UIButton!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profilePicture: PFImageView!
    @IBOutlet weak var profileCover: PFImageView!

    
    var delegate: ProfileGuestHeaderViewDelegate?
    
    override var nibName: String? {
        return "ProfileGuestHeaderView"
    }
    
    @IBAction func didTapFollow(sender: AnyObject?) {
        self.delegate?.profileGuestView(self, didTapFollow: self.followButton)
    }
    
    @IBAction func didTapWhisper(sender: AnyObject?) {
        self.delegate?.profileGuestView(self, didTapWhisper: self.whisperButton)
    }
    
    override func objectDidLoad(object: PFObject) {
        super.objectDidLoad(object)
        
        self.profileName.text = UserModel.displayname(object)
        
        self.profilePicture.image = kUserPlaceholder
        self.profilePicture.file = UserModel.pictureImage(object)
        
        self.profileCover.image = kUserCoverPlaceholder
        self.profileCover.file = UserModel.coverImage(object)
        
        self.profileCover.loadInBackground()
        self.profilePicture.loadInBackground()
        
        self.profilePicture.cornerEdge()
    }
    
    override func viewDidLoad() {
    }
    
}