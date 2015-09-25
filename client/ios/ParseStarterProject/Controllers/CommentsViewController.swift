//
//  CommentsViewController.swift
//  Think
//
//  Created by denis zaytcev on 8/24/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import Bolts
import ParseUI

@objc(CommentsViewController) class CommentsViewController: BaseQueryTableViewController {
    @IBOutlet weak var inputBar       : InputBarView!
    @IBOutlet weak var inputBarHC     : NSLayoutConstraint!
    @IBOutlet weak var tableViewHC    : NSLayoutConstraint!
    
    var owner: PFObject? //post
    var scrollDirection = ScrollDirection()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Comments"
        self.tableView.registerNib(UINib(nibName: kReusableCommentViewCell, bundle: nil), forCellReuseIdentifier: kReusableCommentViewCell)
        
//        self.view.backgroundColor           = kColorBackgroundViewController
//        self.tableView.backgroundColor      = kColorBackgroundViewController
        self.tableView.estimatedRowHeight   = 44.0;
        self.tableView.rowHeight            = UITableViewAutomaticDimension;
        self.tableView.tableFooterView      = UIView()
        
        self.setupNavigationBar()
        self.setupInputBar()
        self.setupKeyboard(false)
    }
    
    override func updateConstraintKeyboard(hide: Bool, minY: CGFloat, maxY: CGFloat) {
        self.inputBarHC.constant  =  maxY - minY
        self.tableViewHC.constant =  maxY - minY + 60
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.customizeNavigationBar()
        self.configureNavigationBarBackBtn(kColorNavigationBar)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userSendComment:", name: kUserSendComment, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kUserSendComment, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)
    }
    
    func setupInputBar() {
        self.inputBar.delegate = self
    }
    
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: self.parseClassName!)
        query.whereKey(kActivityTypeKey, equalTo: kActivityTypeComment)
        query.whereKey(kActivityPostKey, equalTo: owner!)
        query.orderByDescending(kClassCreatedAt)
        query.includeKey(kActivityPostKey)
        query.includeKey(kActivityFromUserKey)
        
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(kReusableCommentViewCell) as! CommentViewCell
        cell.prepareView(object!)
        
        return cell
    }
    
   @available(iOS 8.0, *)
   override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> [UITableViewRowAction]?  {
        
        let reportAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Report" , handler: { (action:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
        })
        
        reportAction.backgroundColor = UIColor(red:0.91, green:0.3, blue:0.24, alpha:1)
        
        let replyAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Reply" , handler: { (action:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
        })
        
        replyAction.backgroundColor = UIColor.lightGrayColor()
        
        return [reportAction, replyAction]
    }
    
    func userSendComment(notification: NSNotification) {
        if let object = notification.object as? PFObject {
            self.objects?.insertObject(object, atIndex: 0)

            self.tableView.beginUpdates()

            var indexPath: NSIndexPath? = nil
            
            if (self.paginationEnabled && self.shouldShowPaginationCell) {
                indexPath = NSIndexPath(forRow: self.objects!.count, inSection: 0)
            } else {
                indexPath = NSIndexPath(forRow: self.objects!.count - 1, inSection: 0)
            }
            
            self.tableView.insertRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
            
            self.tableView.endUpdates()
            self.tableView.scrollToRowAtIndexPath(indexPath!, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) {
        if let user = Comment.owner(object!){
            let controller = ProfileViewController.CreateWithModel(user)
            self.navigationController!.pushViewController(controller, animated: true)
        }
        
        tableView.editing = false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle  {
        return UIStatusBarStyle.LightContent
    }
    
    class func CreateWithModel(model: PFObject) -> CommentsViewController {
        let comments = CommentsViewController()
        comments.owner = model
        comments.parseClassName = "Activity"
        comments.paginationEnabled = true
        comments.objectsPerPage = 25
        comments.pullToRefreshEnabled = false
        comments.reverseViewCell = true
        
        return comments
    }
    
    class func CreateWithId(objectId: String) -> CommentsViewController {
        return CreateWithModel(PFObject(withoutDataWithClassName: kPostClassKey, objectId: objectId))
    }
}


extension CommentsViewController: InputBarViewDelegate {
    func handlerSendComment(message: String) {
        let readyMessage = message.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        if readyMessage.isEmpty {
            return
        }
        
        Activity.commentPost(self.owner!, message: readyMessage)
    }
    
    func inputBar(view: InputBarView, didTapLeftButton button: UIButton) {
        self.hideKeyboard()
    }
    
    func inputBar(view: InputBarView, didTapRightButton button: UIButton) {
        self.handlerSendComment(view.text)
        view.text = ""
        self.hideKeyboard()
    }
    
    func inputBar(view: InputBarView, shouldReturn textField: UITextField) {
        self.handlerSendComment(view.text)
        view.text = ""
        self.hideKeyboard()
    }
}