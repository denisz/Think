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

class BookmarkMainPostView: UIView {
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
        let nib = UINib(nibName: "BookmarkMainPostView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    func setColors() {
//        let image = UIImage(named: "hello.png")
//        let colors = image.getColors()
//        
//        backgroundView.backgroundColor = colors.backgroundColor
//        mainLabel.textColor = colors.primaryColor
//        secondaryLabel.textColor = colors.secondaryColor
//        detailLabel.textColor = colors.detailColor
    }
    
    func setupView() {
    }
}
