//
//  BaseViewController.swift
//  Think
//
//  Created by denis zaytcev on 8/6/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit
import LGDrawer
import LGViews


let kImageNamedForBackBtn = "ic_back"
let kImageNamedForMenuBtn = "ic_menu"

extension UIViewController {
    var imageLeftBtn: String {
        return kImageNamedForBackBtn
    }
    
    func configureTitleView() {
        var color = UIColor(red:0.2, green:0.2, blue:0.2, alpha:1)
        var arrowImage = LGDrawer.drawArrowWithImageSize(CGSizeMake(11, 10),
            size: CGSizeMake(11, 6),
            offset: CGPoint(x: 0, y: 2),
            rotate: 0,
            thickness: 1,
            direction: LGDrawerDirectionBottom,
            backgroundColor: nil,
            color: color,
            dash: nil,
            shadowColor: nil,
            shadowOffset: CGPointZero,
            shadowBlur: 0)
        
        var _titleButton = LGButton()
        _titleButton.adjustsAlphaWhenHighlighted = true
        _titleButton.backgroundColor = UIColor.clearColor()
        _titleButton.tag = 0
        _titleButton.setTitle(self.title, forState: UIControlState.Normal)
        _titleButton.setTitleColor(color, forState: UIControlState.Normal)
        _titleButton.setImage(arrowImage, forState: UIControlState.Normal)
        _titleButton.imagePosition = LGButtonImagePositionRight
        _titleButton.titleLabel!.font = UIFont(name: "OpenSans-Light", size: 19)
        _titleButton.addTarget(self, action: "didTapFilter", forControlEvents: UIControlEvents.TouchUpInside)
        _titleButton.sizeToFit()
        
        self.navigationItem.titleView = _titleButton;
    }
    
    func didTapFilter() {}
    
    func customizeNavigationBar() {
        self.automaticallyAdjustsScrollViewInsets = true
        var navigationBar = self.navigationController?.navigationBar
        
        // Sets background to a blank/empty image
//        navigationBar?.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        // Sets shadow (line below the bar) to a blank image
        navigationBar?.shadowImage = UIImage()
        // Sets the translucent background color
        navigationBar?.backgroundColor = UIColor.whiteColor()
        // Set translucent. (Default value is already true, so this can be removed if desired.)
        navigationBar?.translucent = false
    }
    
    func configureNavigationBarBackBtn(color: UIColor) {
        var image = UIImage(named: imageLeftBtn) as UIImage!
        image = image.imageWithColor(color)
        
        var btnBack:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        btnBack.addTarget(self, action: "didTapLeftBtn:", forControlEvents: UIControlEvents.TouchUpInside)
        btnBack.setImage(image, forState: UIControlState.Normal)
        btnBack.contentEdgeInsets = UIEdgeInsets(top: -5, left: 0, bottom: 0, right: 0)
        btnBack.imageEdgeInsets = UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)
        btnBack.setTitleColor(UIColor(red:0.2, green:0.2, blue:0.2, alpha:1), forState: UIControlState.Normal)
        btnBack.sizeToFit()
        var myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: btnBack)
        self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
    }
    
    func didTapLeftBtn(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
}

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeNavigationBar()
        configureNavigationBarBackBtn(UIColor(red:0.2, green:0.2, blue:0.2, alpha:1))
    }
}
