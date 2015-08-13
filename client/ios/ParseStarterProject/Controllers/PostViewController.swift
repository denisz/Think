//
//  PostViewController.swift
//  Think
//
//  Created by denis zaytcev on 8/10/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import ParseUI
import UIKit
import VGParallaxHeader

@objc(PostViewController) class PostViewController: BaseQueryViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.setupScrollView()
        self.setupNavigationBar()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.customizeNavigationBar()
        self.configureNavigationBarBackBtn(UIColor.whiteColor())
        self.configureNavigationBarRightBtn(UIColor.whiteColor())
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
    }
    
    func setupScrollView() {
       let header = PostViewHeaderView()
        header.object = self.object
        header.parentController = self
        self.scrollView.delegate = self
        self.scrollView.setParallaxHeaderView(header, mode: VGParallaxHeaderMode.Fill, height: 245)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.scrollView.shouldPositionParallaxHeader()
    }
    
    override func customizeNavigationBar() {
        self.automaticallyAdjustsScrollViewInsets = false
        
        let navigationBar = self.defineNavigationBar()
        
        navigationBar?.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationBar?.shadowImage = UIImage()
        navigationBar?.backgroundColor = UIColor.clearColor()
        navigationBar?.translucent = true
    }
    
    func configureNavigationBarRightBtn(color: UIColor) {
        let navigationItem = self.defineNavigationItem()
        
        var image = UIImage(named: "ic_more2") as UIImage!
        image = image.imageWithColor(color)
        
        let btnBack:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        btnBack.addTarget(self, action: "didTapMoreBtn:", forControlEvents: UIControlEvents.TouchUpInside)
        btnBack.setImage(image, forState: UIControlState.Normal)
        btnBack.imageEdgeInsets = UIEdgeInsets(top: 13, left: 26, bottom: 13, right: 0)
        btnBack.setTitleColor(kColorNavigationBar, forState: UIControlState.Normal)
        btnBack.sizeToFit()
        
        let myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: btnBack)
        navigationItem.rightBarButtonItem = myCustomBackButtonItem
    }
    
    func didTapMoreBtn(sender: AnyObject?) {
        
    }

    class func CreateWithModel(model: PFObject) -> PostViewController {
        var post = PostViewController()
        post.object = model
        
        return post
    }
    
    class func CreateWithId(objectId: String) -> PostViewController {
        return CreateWithModel(PFObject(withoutDataWithClassName: "Post", objectId: objectId))
    }
}
