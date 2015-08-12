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
        
        //let count = self.form.formSections.objectAtIndex(indexPath.section).formRows.count
        SeperatorView.addHairline(cell)
        
        return cell
    }

}