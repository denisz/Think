//
//  SideMenuVIewController.swift
//  Think
//
//  Created by denis zaytcev on 8/8/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit

typealias SideMenuTuple = (String, String, kSideMenu)
class SideMenuViewConroller: UITableViewController {
    var activeItem: String = "Feed"
    
    let items: [SideMenuTuple] = [
        ("Notifications",   "ic_notifications",   .Notificaiton),
        ("Feed",            "ic_feed",                    .Feed),
        ("Bookmarks",       "ic_bookmarks",          .Bookmarks),
        ("Top",             "ic_top",                      .Top),
        ("Digest",          "ic_digest",                .Digest),
        ("Drafts",          "ic_drafts",                .Drafts),
        ("Messages",        "ic_messages",            .Messages),
        ("Profile",         "ic_profile_menu",         .Profile),
        ("Settings",        "ic_settings",            .Settings)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerNib(UINib(nibName: kReusableSideMenuViewCell, bundle: nil), forCellReuseIdentifier: kReusableSideMenuViewCell)
        
        self.tableView.reloadData()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.contentInset = UIEdgeInsetsMake(70, 0, 20, 0);
        self.tableView.showsVerticalScrollIndicator = false;
        
        self.view.backgroundColor = UIColor(red:0.23, green:0.68, blue:0.85, alpha:1) 
    }
    
    func prepareIcon(named: String) -> UIImage {
        let image = UIImage(named: named)
        return image!.imageWithColor(UIColor.whiteColor())
    }
    
    func prepareCounter(name: kSideMenu) -> Int {
        return 0
    }
    
    func propsByIndexPath(indexPath: NSIndexPath) -> SideMenuTuple? {
        return self.items[indexPath.row]
    }
    
    func makeActiveItem(item: String) {
        self.activeItem = item
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let props = self.propsByIndexPath(indexPath) {
            if let sideMenu = sideMenuController() {
                sideMenu.hideLeftViewAnimated(true, completionHandler: { () -> Void in
                    if self.activeItem != props.0 {
                        self.makeActiveItem(props.0)
                        NSNotificationCenter.defaultCenter().postNotificationName(props.2.rawValue as String, object: nil)
                    }
                })
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kReusableSideMenuViewCell) as! SideMenuViewCell
        
        if let obj = self.propsByIndexPath(indexPath) {
            let countNotify = self.prepareCounter(obj.2)
            cell.iconMenu.image = self.prepareIcon(obj.1)
            cell.titleMenu.text = obj.0
            cell.counterMenu.hidden = countNotify == 0
            cell.counterMenu.titleLabel!.text = "\(countNotify)"
        }
        
        return cell
    }
}

class SideMenuViewCell: UITableViewCell {
    @IBOutlet weak var titleMenu:   UILabel!
    @IBOutlet weak var iconMenu:    UIImageView!
    @IBOutlet weak var counterMenu: UIButton!
}