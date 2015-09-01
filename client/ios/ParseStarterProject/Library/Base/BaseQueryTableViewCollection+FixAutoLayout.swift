//
//  BaseQueryTableViewCollection+FixAutoLayout.swift
//  Think
//
//  Created by denis zaytcev on 8/31/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import ParseUI

extension BaseQueryTableViewController {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if iOS8 {
            return UITableViewAutomaticDimension
        } else {
            return 44
        }
    }
}
