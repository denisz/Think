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


protocol BaseQueryTableViewControllerProtocol {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath, object: PFObject?)
}

class BaseQueryTableViewController: PFQueryTableViewController {
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
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
    }
}

extension BaseQueryTableViewController: BaseQueryTableViewControllerProtocol {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let object = self.objectAtIndexPath(indexPath) {
            self.tableView(self.tableView, didSelectRowAtIndexPath: indexPath, object: object)
        }
        
        super.tableView(tableView, didSelectRowAtIndexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) {
        
    }
}