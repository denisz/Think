//
//  NewPost.swift
//  Think
//
//  Created by denis zaytcev on 8/10/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import ParseUI
import UIKit


@objc(NewPostViewController) class NewPostViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "New post"
        
        self.view.backgroundColor = kColorBackgroundViewController
        
        self.configureNavigationBarSettingsBtn(kColorNavigationBar)
        self.configureNavigationBarBackBtn(kColorNavigationBar)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
    }
    
    override var imageLeftBtn: String {
        return kImageNamedForCloseBtn
    }

    func configureNavigationBarSettingsBtn(color: UIColor) {
        var image = UIImage(named: "ic_next") as UIImage!
        image = image.imageWithColor(color)
        
        var btnBack:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        btnBack.addTarget(self, action: "didTapNextBtn:", forControlEvents: UIControlEvents.TouchUpInside)
        btnBack.setImage(image, forState: UIControlState.Normal)
        btnBack.imageEdgeInsets = UIEdgeInsets(top: 9, left: 18, bottom: 9, right: 0)
        btnBack.setTitleColor(kColorNavigationBar, forState: UIControlState.Normal)
        btnBack.sizeToFit()
        var myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: btnBack)
        self.navigationItem.rightBarButtonItem  = myCustomBackButtonItem
    }
    
    func didTapNextBtn(sender: AnyObject?) {
        let controller = SettingsPostViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle  {
        return UIStatusBarStyle.Default
    }
}