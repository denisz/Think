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

protocol ProfileHeaderViewDelegate {
    func profileView(view: ProfileHeaderView, didTapFollowers button: UIButton)
    func profileView(view: ProfileHeaderView, didTapDrafts button: UIButton)
    func profileView(view: ProfileHeaderView, didTapNewPost button: UIButton)
}

class ProfileHeaderView: UIView {
    @IBOutlet weak var newPostButton: UIButton!
    @IBOutlet weak var draftsButton: UIButton!
    @IBOutlet weak var followersButton: UIButton!
    
    var delegate: ProfileHeaderViewDelegate?
    
    var object: PFObject?    
    var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        addSubview(view)
        
        setupView()
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "ProfileHeaderView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
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
    
    func setupView() {
        let color = UIColor.lightGrayColor()
        
        self.newPostButton.borderLeft(color)
        self.draftsButton.borderLeft(color)
    }
}