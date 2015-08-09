//
//  NotificationFilterView.swift
//  Think
//
//  Created by denis zaytcev on 8/9/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit

let kReusableNotificationsFilterViewCell =  "NotificationsFilterViewCell"

class NotificationFilterView: UIView {
    var items: [String] = ["adding to friends", "reposting", "sharing via socials", "commenting your", "replies"];

    @IBOutlet weak var tableView: UITableView!
    var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        addSubview(view)
        
        setupView()
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "NotificationFilterView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    func setupView() {
//        self.tableView.estimatedRowHeight = 64
        self.tableView.scrollEnabled = false;
        self.tableView.registerNib(UINib(nibName: kReusableNotificationsFilterViewCell, bundle: nil), forCellReuseIdentifier: kReusableNotificationsFilterViewCell)
    }
}

extension NotificationFilterView: UITableViewDelegate {
//    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 64
//    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? NotificationFilterViewCell {
            cell.checkbox.selected = !cell.checkbox.selected
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}

extension NotificationFilterView: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kReusableNotificationsFilterViewCell) as! NotificationFilterViewCell
        
        cell.title.text = items[indexPath.row].uppercaseString
        
        if indexPath.row == items.count - 1  {
            cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0);
        }
        
        return cell
    }
}

class NotificationFilterViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var checkbox: UIButton!
}