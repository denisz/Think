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
let kImageNamedForCloseBtn = "ic_close"


enum MyNavigationBar: Int {
    case Default
    case Transparent
}

//create Navigation bar
extension UIViewController {
    
    var sideMenuView: Bool {
        if let nc = self.navigationController {
            let controllers = nc.viewControllers as! [UIViewController]
            if controllers.count > 1 {
                return false
            }
        }
        return true
    }
    
    var imageLeftBtn: String {
        if self.sideMenuView {
            return kImageNamedForMenuBtn
        } else {
            return kImageNamedForBackBtn
        }
    }
    
    func configureTitleView() {
        let navigationItem = defineNavigationItem()
        
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
        _titleButton.addTarget(self, action: "didTapTitle", forControlEvents: UIControlEvents.TouchUpInside)
        _titleButton.sizeToFit()
        
        navigationItem.titleView = _titleButton;
    }
    
    func didTapTitle() {}
    
    func setupFakeStatusBar(color: UIColor) {
        let fakeView = UIView()
        fakeView.backgroundColor = color
        fakeView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.view.addSubview(fakeView)
        
        let views = ["view": fakeView]
        var hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: .AlignAllCenterY, metrics: nil, views: views)
        let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[view(20)]", options: .AlignAllCenterX, metrics: nil, views: views)
        
        self.view.addConstraints(hConstraints)
        self.view.addConstraints(vConstraints)
    }
    
    func defineNavigationBar() -> UINavigationBar? {
        return self.navigationController?.navigationBar
    }
    
    func defineNavigationItem() -> UINavigationItem {
        return self.navigationItem
    }

    func customizeNavigationBar() {
        customizeNavigationBar(MyNavigationBar.Default)
    }
    
    func customizeNavigationBar(style: MyNavigationBar ) {
        let navigationBar = self.defineNavigationBar()
        
        if style == .Transparent {
            self.automaticallyAdjustsScrollViewInsets = false
            navigationBar?.titleTextAttributes = [
                NSFontAttributeName             : kFontNavigationBarTitle,
                NSForegroundColorAttributeName  : kColorNavigationBar
            ]
            navigationBar?.setBackgroundImage(UIImage(), forBarMetrics: .Default)
            navigationBar?.shadowImage = UIImage()
            navigationBar?.backgroundColor = UIColor.clearColor()
            navigationBar?.translucent = true
        } else {
            self.automaticallyAdjustsScrollViewInsets = true
            
            navigationBar?.titleTextAttributes = [
                NSFontAttributeName             : kFontNavigationBarTitle,
                NSForegroundColorAttributeName  : kColorNavigationBar
            ]
            navigationBar?.setBackgroundImage(UIImage(), forBarMetrics: .Default)
            navigationBar?.shadowImage = UIImage()
            navigationBar?.backgroundColor = UIColor.whiteColor()
            navigationBar?.translucent = false
        }
    }
    
    func configureNavigationBarBackBtn(color: UIColor) {
        configureNavigationBarBackBtn(color, animated: false)
    }
    
    func configureNavigationBarBackBtn(color: UIColor, animated: Bool) {
        let navigationItem = defineNavigationItem()
        
        var image = UIImage(named: imageLeftBtn) as UIImage!
        image = image.imageWithColor(color)
        
        var btnBack:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        btnBack.addTarget(self, action: "didTapLeftBtn:", forControlEvents: UIControlEvents.TouchUpInside)
        btnBack.setImage(image, forState: UIControlState.Normal)
        btnBack.contentEdgeInsets = UIEdgeInsets(top: -5, left: 0, bottom: 0, right: 0)
        btnBack.imageEdgeInsets = UIEdgeInsets(top: 9, left: 0, bottom: 9, right: 18)
        btnBack.setTitleColor(kColorNavigationBar, forState: UIControlState.Normal)
        btnBack.sizeToFit()
        
        var myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: btnBack)
        navigationItem.setLeftBarButtonItem(myCustomBackButtonItem, animated: animated)
    }
    
    func didTapLeftBtn(sender: UIButton) {
        
        if self.sideMenuView {
            if let sideMenu = sideMenuController() {
                sideMenu.showLeftViewAnimated(true, completionHandler: nil)
            }
        } else {
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func superviewForFakeNavigationBar() -> UIView {
        return self.view
    }
    
    func createFakeNavigationBar() -> UINavigationBar {
        let frame = CGRectMake(0, 20, 320, 44)
        let fakeNavigationBar = UINavigationBar(frame: frame)
        let superview = self.superviewForFakeNavigationBar()
        
        fakeNavigationBar.barStyle = UIBarStyle.Default
        fakeNavigationBar.delegate = self

        let navigationItem = UINavigationItem()
        navigationItem.title = self.title
        fakeNavigationBar.items = [navigationItem]
        
        superview.addSubview(fakeNavigationBar)
        BaseUIView.constraintToTop(fakeNavigationBar, size: frame.size, offset: 20)
        
        return fakeNavigationBar
    }
}

extension UIViewController: UINavigationBarDelegate {
    public func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached
    }
}

class BaseViewController: StatefulViewController {
    var fakeNavigationBar: UINavigationBar?
    
    override func defineNavigationBar() -> UINavigationBar? {
        return self.fakeNavigationBar
    }
    
    override func defineNavigationItem() -> UINavigationItem {
        let navBar = defineNavigationBar()
        return navBar!.items[0] as! UINavigationItem
    }
    
    func setupNavigationBar() {
        self.fakeNavigationBar = createFakeNavigationBar()
        if self.automaticallyAdjustsScrollViewInsets == true {
            
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        customizeNavigationBar()
        configureNavigationBarBackBtn(UIColor(red:0.2, green:0.2, blue:0.2, alpha:1))
    }
}
