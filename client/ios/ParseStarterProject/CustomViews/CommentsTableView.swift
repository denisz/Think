//
//  CommentsTableView.swift
//  Think
//
//  Created by denis zaytcev on 8/24/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import ParseUI


class CommentsTableView: MyQueryTableView {
    @IBOutlet weak var heightLayoutConstraint: NSLayoutConstraint!
    
    var object: PFObject? //post
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollEnabled = false
        self.registerNib(UINib(nibName: kReusableCommentViewCell, bundle: nil), forCellReuseIdentifier: kReusableCommentViewCell)
        self.estimatedRowHeight = 44.0
        self.rowHeight = UITableViewAutomaticDimension

        self.tableFooterView = UIView()
    }
    
    override func objectsDidLoad(error: NSError?) {
        super.objectsDidLoad(error)
        
        if error == nil {
            self.layoutIfNeeded()
            self.heightLayoutConstraint.constant = self.contentSize.height
            println(self.contentSize.height)
        }
    }
    
    override func setupWithClassName(otherClassName: String?) {
        super.setupWithClassName(otherClassName)
        self.parseClassName = "Activity"
        self.objectsPerPage = 3
        self.paginationEnabled = false
    }
    
    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: self.parseClassName!)
        query.whereKey(kActivityTypeKey, equalTo: kActivityTypeComment)
        query.whereKey(kActivityPostKey, equalTo: object!)
        query.orderByDescending("createdAt")
        query.includeKey(kActivityPostKey)
        query.includeKey(kActivityFromUserKey)
        query.limit = 3
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        var cell = tableView.dequeueReusableCellWithIdentifier(kReusableCommentViewCell) as? CommentViewCell
        cell?.contentView.backgroundColor = kColorBackgroundViewController
        cell?.prepareView(object!)
        
        return cell
    }
}