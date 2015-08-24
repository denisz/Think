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

class ProfileEditHeaderView: BaseUIView {
    @IBOutlet weak var buttonAvatar: UIButton!
    @IBOutlet weak var buttonCover: UIButton!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var profileCover: PFImageView!

    var parentController: UIViewController?
    var object: PFObject?
    
    override var nibName: String? {
        return "ProfileEditHeaderView"
    }
    
    func didTapChangeAvatar(sender: UITapGestureRecognizer) {
        let btn = sender.view!
        SelectImageHelper.selectAndUploadFile(self.parentController!, sourceView: btn, scenario: .AvatarProfile)
    }
    
    func didTapChangeCover(sender: UITapGestureRecognizer) {
        let btn = sender.view!
        SelectImageHelper.selectAndUploadFile(self.parentController!, sourceView: btn, scenario: .CoverProfile)
    }
    
    func setupButtons() {
        let gestureAvatar = UITapGestureRecognizer(target: self, action: "didTapChangeAvatar:")
        buttonAvatar.addGestureRecognizer(gestureAvatar)

        let gestureCover = UITapGestureRecognizer(target: self, action: "didTapChangeCover:")
        buttonCover.addGestureRecognizer(gestureCover)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profilePicture.cornerEdge()
        setupButtons()
    }
}