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
    var items: [(String, String)] = [
        ("adding to friends",   kActivityTypeFollow),
        ("commenting your",     kActivityTypeComment),
        ("likes your",          kActivityTypeLike)
    ];

    @IBOutlet weak var tableView: UITableView!
    var view: UIView!
    
    var selectedItems: [String]?
    
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
        self.tableView.scrollEnabled = false;
        self.tableView.registerNib(UINib(nibName: kReusableNotificationsFilterViewCell, bundle: nil), forCellReuseIdentifier: kReusableNotificationsFilterViewCell)
    }
}

extension NotificationFilterView: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let obj  = self.objByIndexPath(indexPath) {
            if let cell = tableView.cellForRowAtIndexPath(indexPath) as? NotificationFilterViewCell {
                let checked = !cell.checkbox.selected
                cell.checkbox.selected = checked
                
                if checked {
                    if !contains(self.selectedItems!, obj.1) {
                        self.selectedItems?.append(obj.1)
                    }
                } else {
                    self.selectedItems?.remove{$0 == obj.1}
                }
                
                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}

extension NotificationFilterView: UITableViewDataSource {
    func objByIndexPath(indexPath: NSIndexPath) -> (String, String)? {
        return items[indexPath.row]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kReusableNotificationsFilterViewCell) as! NotificationFilterViewCell
        
        if let obj  = self.objByIndexPath(indexPath) {
            cell.title.text = obj.0.uppercaseString
            cell.checkbox.selected = contains(self.selectedItems!, obj.1)
        }
        
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