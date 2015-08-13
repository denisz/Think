//
//  BaseGestureQueryTableViewController.swift
//  Think
//
//  Created by denis zaytcev on 8/11/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import ParseUI
import UIKit

class BaseGestureQueryTableViewController: BaseQueryTableViewController {
    override func viewDidLoad() {
        self.tableView = SBGestureTableView(frame: self.view.frame, style: UITableViewStyle.Plain)
//        self.view = self.tableView
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
