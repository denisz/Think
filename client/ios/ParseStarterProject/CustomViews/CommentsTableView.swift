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
        self.allowsSelection = false
        self.tableFooterView = UIView()
    }
    
    override func objectsDidLoad(error: NSError?) {
        super.objectsDidLoad(error)
        
        if error == nil {
            self.layoutIfNeeded()
            self.heightLayoutConstraint.constant = self.contentSize.height
        }
    }
    
    override func setupRefreshControl() {
        if iOS8 {
            super.setupRefreshControl()
        } else {
            
        }
    }
    
    override func refreshLoadingView() {
        if iOS8 {
            super.refreshLoadingView()
        } else {

        }
    }
    
    override func setupWithClassName(otherClassName: String?) {
        super.setupWithClassName(otherClassName)
        self.parseClassName = kActivityClassKey
        self.objectsPerPage = 3
        self.paginationEnabled = false
        self.pullToRefreshEnabled = false
    }
    
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: self.parseClassName!)
        query.whereKey(kActivityTypeKey, equalTo: kActivityTypeComment)
        query.whereKey(kActivityPostKey, equalTo: object!)
        query.orderByDescending("createdAt")
        query.includeKey(kActivityPostKey)
        query.includeKey(kActivityFromUserKey)
        query.limit = 3
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        let cell = tableView.dequeueReusableCellWithIdentifier(kReusableCommentViewCell) as? CommentViewCell
        cell?.contentView.backgroundColor = kColorBackgroundViewController
        cell?.prepareView(object!)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if iOS8 {
            return UITableViewAutomaticDimension
        } else {
            var height: CGFloat = 0
            if let object = objectAtIndexPath(indexPath) {
                let body = Comment.content(object)
                height = MeasureText.heightForText(body, font: kCommentContentFont, width: kWidthScreen)
                height += 52
            }
            
            return max(height, 100)
        }
    }
}