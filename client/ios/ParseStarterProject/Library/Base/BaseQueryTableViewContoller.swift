//
//  BaseQueryTableViewContoller.swift
//  Think
//
//  Created by denis zaytcev on 8/7/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import ParseUI
import UIKit


class BaseQueryTableViewController: MyQueryTableViewController {
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    var fakeNavigationBar: UINavigationBar?
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.automaticallyAdjustsScrollViewInsets = true
//    }
    
    override func defineNavigationBar() -> UINavigationBar? {
        return self.fakeNavigationBar
    }
    
    override func defineNavigationItem() -> UINavigationItem {
        let navBar = defineNavigationBar()
        return (navBar!.items?.first)!
    }
    
    func setupNavigationBar() {
        self.fakeNavigationBar = createFakeNavigationBar()
    }
    
    func topConstraintForNavigationBar() -> NSLayoutConstraint? {
        return self.tableViewTopConstraint
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.automaticallyAdjustsScrollViewInsets == true {
            if let top = self.topConstraintForNavigationBar() {
                top.constant = 44
            }
        }
    }
}