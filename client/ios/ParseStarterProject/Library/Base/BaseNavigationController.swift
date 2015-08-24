//
//  BaseNavigationController.swift
//  Think
//
//  Created by denis zaytcev on 8/6/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit

//remove navigationBar
class BaseNavigationController: UINavigationController {
    var transitionDelegate = SwipeTransitionDeleagte()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = transitionDelegate
        self.interactivePopGestureRecognizer.enabled = false
        self.navigationBar.hidden = true
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle  {
        return UIStatusBarStyle.LightContent
    }
    
    func replaceViewController(viewController: UIViewController, animated: Bool) {
        var controllers = self.viewControllers as! [UIViewController]
        controllers.removeLast()
        controllers.append(viewController)
        self.setViewControllers(controllers, animated: animated)
    }
    
    func replaceAll(viewController: UIViewController, animated: Bool) {
        self.setViewControllers([viewController], animated: true)
    }
}