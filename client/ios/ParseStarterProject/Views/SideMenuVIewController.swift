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
        ("Notifications", "ic_notification"),
        ("Feed", "ic_feed"),
        ("Bookmarks", "ic_bookrmarks"),
        ("Top", "ic_top"),
        ("Digest", "ic_digest"),
        ("Drafts", "ic_drafts"),
        ("Messages", "ic_messages"),
        ("Profile", "ic_profile_menu"),
        ("Settings", "ic_settings")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerNib(UINib(nibName: "SideMenuCellView", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: kReusableSideMenuCell)
    }
    
    func prepareIcon(named: String) -> UIImage {
        var image = UIImage(named: named)
        return image!.imageWithColor(UIColor.whiteColor())
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //вызвать клик
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(kReusableSideMenuCell) as! SideMenuCellView
        
        var obj = items[indexPath.row]
        cell.icon       = UIImageView(image: prepareIcon(obj.1))
        cell.title.text = obj.0
//        cell.counter.hidden = true
        
        return cell
    }
}


class SideMenuCellView: UITableViewCell {
    @IBOutlet weak var title:   UILabel!
    @IBOutlet weak var icon:    UIImageView!
    @IBOutlet weak var counter: UIButton!
}