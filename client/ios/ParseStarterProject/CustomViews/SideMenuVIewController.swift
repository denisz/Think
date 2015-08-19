//
//  SideMenuVIewController.swift
//  Think
//
//  Created by denis zaytcev on 8/8/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit

let kReusableSideMenuCell = "SideMenuCell"

class SideMenuViewConroller: UITableViewController, UITableViewDataSource {
    let items: [(String, String)] = [
        ("Notifications", "ic_notifications"),
        ("Feed", "ic_feed"),
        ("Bookmarks", "ic_bookmarks"),
        ("Top", "ic_top"),
        ("Digest", "ic_digest"),
        ("Drafts", "ic_drafts"),
        ("Messages", "ic_messages"),
        ("Profile", "ic_profile_menu"),
        ("Settings", "ic_settings")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerNib(UINib(nibName: "SideMenuCellView", bundle: nil), forCellReuseIdentifier: kReusableSideMenuCell)
        
        self.tableView.reloadData()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.contentInset = UIEdgeInsetsMake(70, 0, 20, 0);
        self.tableView.showsVerticalScrollIndicator = false;
        
        self.view.backgroundColor = UIColor(red:0.23, green:0.68, blue:0.85, alpha:1) 
    }
    
    func prepareIcon(named: String) -> UIImage {
        var image = UIImage(named: named)
        return image!.imageWithColor(UIColor.whiteColor())
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let sideMenu = sideMenuController() {
            sideMenu.hideLeftViewAnimated(true, completionHandler: { () -> Void in
                
            })
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(kReusableSideMenuCell) as! SideMenuCellView
        
        var obj = items[indexPath.row]
        cell.iconMenu.image = prepareIcon(obj.1)
        cell.titleMenu.text = obj.0
        cell.counterMenu.hidden = true
        return cell
    }
}


class SideMenuCellView: UITableViewCell {
    @IBOutlet weak var titleMenu:   UILabel!
    @IBOutlet weak var iconMenu:    UIImageView!
    @IBOutlet weak var counterMenu: UIButton!
}