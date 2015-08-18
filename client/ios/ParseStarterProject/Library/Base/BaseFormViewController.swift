//
//  BaseFormViewController.swift
//  Think
//
//  Created by denis zaytcev on 8/10/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit
import XLForm
import Parse
import ParseUI


class BaseFormViewController: XLFormViewController, XLFormViewControllerDelegate {
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func stylesRow(row: XLFormRowDescriptor) {
        row.cellConfig.setObject(UIColor(red:0.2, green:0.2, blue:0.2, alpha:1), forKey: "textLabel.textColor")
        row.cellConfig.setObject(UIFont(name: "OpenSans-Semibold", size: 12)!, forKey: "textLabel.font")
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        SeperatorView.addHairline(cell)
        
        return cell
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
        if self.automaticallyAdjustsScrollViewInsets == true {
            self.tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0)
        }
    }
}