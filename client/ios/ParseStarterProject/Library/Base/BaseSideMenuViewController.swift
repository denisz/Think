//
//  BaseSideMenuViewController.swift
//  Think
//
//  Created by denis zaytcev on 8/9/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import LGSideMenuController


func sideMenuController() -> BaseSideMenuViewController? {
    return (UIApplication.sharedApplication().delegate as! AppDelegate).sideMenuController
}

func setSideMenuController(controller: BaseSideMenuViewController) {
    (UIApplication.sharedApplication().delegate as! AppDelegate).sideMenuController = controller
}

@objc(BaseSideMenuViewController) class BaseSideMenuViewController: LGSideMenuController {
    var _leftViewController: UITableViewController?
    
    //Code to be removed from your destinationViewController
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Here you can init your properties
    }
    
    override init(rootViewController: UIViewController!) {
        super.init(rootViewController: rootViewController)
        _leftViewController = SideMenuViewConroller()

        self.setLeftViewEnabledWithWidth(CGFloat(250), presentationStyle: LGSideMenuPresentationStyleSlideBelow, alwaysVisibleOptions: LGSideMenuAlwaysVisibleOptions(0))

        self.leftView().addSubview(_leftViewController!.tableView)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func leftViewWillLayoutSubviewsWithSize(size: CGSize) {
        super.leftViewWillLayoutSubviewsWithSize(size)
        _leftViewController!.tableView.frame = CGRectMake(0 , 0, size.width, size.height);
    }
}