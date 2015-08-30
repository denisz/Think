//
//  PrivacyViewController.swift
//  Think
//
//  Created by denis zaytcev on 8/27/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import ParseUI
import UIKit

@objc(PrivacyViewController) class PrivacyViewController: BaseViewController {
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Privacy".localized
        self.view.backgroundColor = kColorBackgroundViewController
        self.setupNavigationBar()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)
        
        
    }
}