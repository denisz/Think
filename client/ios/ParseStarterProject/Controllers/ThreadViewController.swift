//
//  ChannelTableViewController.swift
//  Think
//
//  Created by denis zaytcev on 8/28/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import Bolts
import ParseUI

@objc(ThreadViewController) class ThreadViewController: BaseQueryTableViewController {
    @IBOutlet weak var inputBar       : InputBarView!
    @IBOutlet weak var inputBarHC     : NSLayoutConstraint!
    @IBOutlet weak var tableViewHC    : NSLayoutConstraint!
    var participant: PFObject?
    var owner: PFObject? //thread
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Thread"
        
        self.tableView.registerNib(UINib(nibName: kReusableInThreadViewCell, bundle: nil), forCellReuseIdentifier: kReusableInThreadViewCell)
        
        self.tableView.registerNib(UINib(nibName: kReusableOutThreadViewCell, bundle: nil), forCellReuseIdentifier: kReusableOutThreadViewCell)
        
        self.tableView.backgroundColor      = kColorBackgroundViewController
        self.view.backgroundColor           = kColorBackgroundViewController
        self.tableView.estimatedRowHeight   = 44.0;
        self.tableView.rowHeight            = UITableViewAutomaticDimension;
        self.tableView.tableFooterView      = UIView()
        
        if self.tableView.respondsToSelector("layoutMargins") {
            self.tableView.layoutMargins        = UIEdgeInsetsZero
        }
        
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
        self.participant!.fetchIfNeededInBackground().continueWithBlock { (task: BFTask!) -> AnyObject! in
            
            dispatch_async(dispatch_get_main_queue()) {
                self.configureNavigationBarRightBtn(kColorNavigationBar)
            }
            return task
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userSendMessage:", name: kUserSendMessage, object: nil)
    }
    
    func configureNavigationBarRightBtn(color: UIColor) {
        let navigationItem = self.defineNavigationItem()
        let placeholder = kUserPlaceholder
        let image = PFImageView()
//        image.contentMode = UIViewContentMode.ScaleAspectFill
        image.image = kUserPlaceholder
        image.file = UserModel.pictureImage(self.participant!)
        
        let btnBack = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        btnBack.addTarget(self, action: "didTapAvatarBtn:", forControlEvents: UIControlEvents.TouchUpInside)
        btnBack.setImage(placeholder, forState: UIControlState.Normal)
        btnBack.imageEdgeInsets = UIEdgeInsets(top: -4, left: -4, bottom: -4, right: -4)
        btnBack.setTitleColor(kColorNavigationBar, forState: UIControlState.Normal)
        btnBack.frame = CGRectMake(0, 0, 36, 36)
        btnBack.cornerEdge()
        
        image.loadInBackground { (image, error) -> Void in
            if error == nil {
                dispatch_async(dispatch_get_main_queue()) {
                    btnBack.setImage(image, forState: UIControlState.Normal)
                }
            }
        }
        
        let bar = UIBarButtonItem(customView: btnBack)
        navigationItem.rightBarButtonItem = bar
    }
    
    func didTapAvatarBtn(sender: AnyObject) {
        if let user = self.participant {
            let controller = ProfileViewController.CreateWithModel(user)
            self.navigationController?.pushViewController(controller, animated: true)
        }

    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kUserSendMessage, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)
    }
    
    func setupInputBar() {
        self.inputBar.delegate = self
    }
    
    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: self.parseClassName!)
        query.whereKey(kMessageThreadKey, equalTo: owner!)
        query.includeKey(kMessageFromUserKey)
        query.orderByDescending(kClassCreatedAt)
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        let cell: ThreadViewCell
        
        if MessageModel.determineCurrentUserAuthor(object!) {
            cell = tableView.dequeueReusableCellWithIdentifier(kReusableOutThreadViewCell) as! ThreadViewCell
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier(kReusableInThreadViewCell) as! ThreadViewCell
        }
        
        cell.prepareView(object!)
        
        if cell.respondsToSelector("layoutMargins") {
            cell.layoutMargins  = UIEdgeInsetsZero
        }
        
        cell.separatorInset = UIEdgeInsetsZero
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if iOS8 {
            return UITableViewAutomaticDimension
        } else {
            var height: CGFloat = 0
            if let object = objectAtIndexPath(indexPath) {
                if let message = Thread.lastMessage(object) {
                    let body = MessageModel.content(message)
                    height = MeasureText.heightForText(body, font: kThreadContentFont, width: kWidthScreen)
                    height += 52
                }
            }
            
            return max(height, 100)
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> [AnyObject]?  {
        
        var deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
        })
        
        deleteAction.backgroundColor = UIColor(red:0.91, green:0.3, blue:0.24, alpha:1)
        
        return [deleteAction]
    }
    
    func userSendMessage(notification: NSNotification) {
        if let object = notification.object as? PFObject {
            self.objects?.insertObject(object, atIndex: 0)
            
            self.tableView.beginUpdates()
            
            var indexPath = NSIndexPath(forRow: 0, inSection: 0)
            
            self.tableView.insertRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
            
            self.tableView.endUpdates()
            self.tableView.scrollToRowAtIndexPath(indexPath!, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle  {
        return UIStatusBarStyle.LightContent
    }
    
    class func CreateWithModel(model: PFObject) -> ThreadViewController {
        var thread = ThreadViewController()
        thread.owner = model
        thread.parseClassName = kMessageClassKey
        thread.participant = Thread.participant(model)
        thread.paginationEnabled = true
        thread.objectsPerPage = 25
        thread.pullToRefreshEnabled = true
        thread.reverseViewCell = false
        
        return thread
    }
}


extension ThreadViewController: InputBarViewDelegate {
    func handlerSend(message: String) {
        MessageModel.sendMessage(self.owner!, toUser: self.participant!, content: message)
    }
    
    func inputBar(view: InputBarView, didTapLeftButton button: UIButton) {
        self.hideKeyboard()
    }
    
    func inputBar(view: InputBarView, didTapRightButton button: UIButton) {
        self.handlerSend(view.text)
        view.text = ""
        self.hideKeyboard()
    }
    
    func inputBar(view: InputBarView, shouldReturn textField: UITextField) {
        self.handlerSend(view.text)
        view.text = ""
        self.hideKeyboard()
    }
}