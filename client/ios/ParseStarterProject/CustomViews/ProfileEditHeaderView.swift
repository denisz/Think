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

class ProfileEditHeaderView: BaseUIView {
    @IBOutlet weak var buttonAvatar: UIButton!
    @IBOutlet weak var buttonCover: UIButton!

    var parentController: UIViewController?
    var object: PFObject?
    
    override var nibName: String? {
        return "ProfileEditHeaderView"
    }
    
    func didTapChangeAvatar(sender: UITapGestureRecognizer) {
        let btn = sender.view!
        UploadFileHelper.selectAndUploadFile(self.parentController!, sourceView: btn, scenario: UploadFileHelperScenario.Avatar)
    }
    
    func didTapChangeCover(sender: UITapGestureRecognizer) {
        let btn = sender.view!
        UploadFileHelper.selectAndUploadFile(self.parentController!, sourceView: btn, scenario: UploadFileHelperScenario.Cover)
    }
    
    func setupButtons() {
        let gestureAvatar = UITapGestureRecognizer(target: self, action: "didTapChangeAvatar:")
        buttonAvatar.addGestureRecognizer(gestureAvatar)

        let gestureCover = UITapGestureRecognizer(target: self, action: "didTapChangeCover:")
        buttonCover.addGestureRecognizer(gestureCover)
    }

    override func viewDidLoad() {
        setupButtons()
    }
}