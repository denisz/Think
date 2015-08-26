//
//  ProfileEditHeaderView.swift
//  Think
//
//  Created by denis zaytcev on 8/10/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit
import Parse
import ParseUI

protocol ProfileEditHeaderViewDelegate {
    func profileView(view: ProfileEditHeaderView, didTapChangePicture button: UIButton)
    func profileView(view: ProfileEditHeaderView, didTapChangeCover button: UIButton)
}

class ProfileEditHeaderView: BaseProfileHeaderView {
    @IBOutlet weak var buttonAvatar: UIButton!
    @IBOutlet weak var buttonCover: UIButton!
    @IBOutlet weak var profilePicture: PFImageView!
    @IBOutlet weak var profileCover: PFImageView!

    var delegate: ProfileEditHeaderViewDelegate?
    
    override var nibName: String? {
        return "ProfileEditHeaderView"
    }
    
    func didTapChangePicture(sender: UITapGestureRecognizer) {
        self.delegate?.profileView(self, didTapChangePicture: self.buttonAvatar)
    }
    
    func didTapChangeCover(sender: UITapGestureRecognizer) {
        self.delegate?.profileView(self, didTapChangeCover: self.buttonCover)
    }
    
    func setupButtons() {
        let gestureAvatar = UITapGestureRecognizer(target: self, action: "didTapChangePicture:")
        buttonAvatar.addGestureRecognizer(gestureAvatar)

        let gestureCover = UITapGestureRecognizer(target: self, action: "didTapChangeCover:")
        buttonCover.addGestureRecognizer(gestureCover)
    }
    
    func updateCover(file: PFFile?) {
        self.profileCover.image = kUserCoverPlaceholder
        self.profileCover.file = file
        self.profileCover.loadInBackground()
    }
    
    func updatePicture(file: PFFile?) {
        self.profilePicture.image = kUserPlaceholder
        self.profilePicture.file = file
        self.profilePicture.loadInBackground()
    }
    
    override func objectDidLoad(object: PFObject) {
        super.objectDidLoad(object)
        
        self.profilePicture.image = kUserPlaceholder
        self.profilePicture.file = UserModel.pictureImage(object)
        
        self.profileCover.image = kUserCoverPlaceholder
        self.profileCover.file = UserModel.coverImage(object)
        
        self.profileCover.loadInBackground()
        self.profilePicture.loadInBackground()
        
        self.profilePicture.cornerEdge()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
    }
}