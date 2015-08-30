//
//  MessagesViewController.swift
//  Think
//
//  Created by denis zaytcev on 8/11/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import ParseUI
import LoremIpsum
import VGParallaxHeader

@objc(MessagesViewController) class MessagesViewController: BaseQueryTableViewController {
    var owner: PFObject?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Messages"
        self.tableView.registerNib(UINib(nibName: kReusableMessageViewCell, bundle: nil), forCellReuseIdentifier: kReusableMessageViewCell)
        
        self.view.backgroundColor = UIColor.whiteColor()//kColorBackgroundViewController
        self.tableView.backgroundColor = kColorBackgroundViewController
        self.tableView.estimatedRowHeight = 44.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.tableFooterView = UIView()

        self.setupNavigationBar()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.customizeNavigationBar()
        self.configureNavigationItem()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userCreatedThread:", name: kUserCreateThread, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userSendMessage:", name: kUserSendMessage, object: nil)
        
        //изменять lastMessage
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: kUserCreateThread, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: kUserSendMessage, object: nil)
    }
    
    func userCreatedThread(notification: NSNotification) {
        if let object = notification.object as? PFObject {
            self.objects?.insertObject(object, atIndex: 0)
            
            self.tableView.beginUpdates()
            
            var indexPath = NSIndexPath(forRow: 0, inSection: 0)
            
            self.tableView.insertRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
            
            self.tableView.endUpdates()
            self.tableView.scrollToRowAtIndexPath(indexPath!, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        }
    }
    
    func userSendMessage(notification: NSNotification) {
        if let message = notification.object as? PFObject {
            if let thread = MessageModel.thread(message) {
                let index = IndexOf(self.objects!, thread)
                if index > -1 {
                    if let item = self.objects![index] as? PFObject {
                        item.setObject(message, forKey: kThreadLastMessageKey)
                        if let indexPath = self.indexPathByObject(item) {
                            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                        }
                    }
                }
            }
        }
    }
    
    func configureNavigationItem() {
        self.configureNavigationBarBackBtn(kColorNavigationBar, animated: true)
        self.configureNavigationBarRightBtn(kColorNavigationBar)
    }
        
    func configureNavigationBarRightBtn(color: UIColor) {
        let navigationItem = defineNavigationItem()
        
        var image = UIImage(named: "ic_new_post") as UIImage!
        image = image.imageWithColor(color)
        
        let btnBack = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        btnBack.addTarget(self, action: "didTapNewMessageBtn:", forControlEvents: UIControlEvents.TouchUpInside)
        btnBack.setImage(image, forState: UIControlState.Normal)
        btnBack.imageEdgeInsets = UIEdgeInsets(top: 1, left: 0, bottom: 2, right: 0)
        btnBack.setTitleColor(kColorNavigationBar, forState: UIControlState.Normal)
        btnBack.frame = CGRectMake(0, 0, 30, 32)
        
        navigationItem.setRightBarButtonItem(UIBarButtonItem(customView: btnBack), animated: true)
    }
    
    func didTapNewMessageBtn(sender: AnyObject?) {
        let controller = FactoryControllers.peopleSearch()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func objectsDidLoad(error: NSError?) {
        for item in self.objects! {
            var parseObject = item as! PFObject
            parseObject["body"] = LoremIpsum.wordsWithNumber((random() % 10) + 1)
        }
        
        super.objectsDidLoad(error)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)
    }
    
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: self.parseClassName!)
        
//        query.whereKey(kThreadParticipantsKey, equalTo: self.owner!.objectId!)
        query.whereKeyExists(kThreadLastMessageKey)//и имеет сообщение
        query.orderByDescending(kClassCreatedAt)
        query.includeKey(kThreadLastMessageKey)
        
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        let cell = tableView.dequeueReusableCellWithIdentifier(kReusableMessageViewCell) as! MessageViewCell
        
        if let message = Thread.lastMessage(object!) {
            cell.clearView()
            cell.prepareView(message)
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) {
        let controller = ThreadViewController.CreateWithModel(object!)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle  {
        return UIStatusBarStyle.Default
    }
    
    class func CreateWithModel(model: PFObject) -> MessagesViewController{
        var messages = MessagesViewController()
        messages.owner = model
        messages.parseClassName = kThreadClassKey
        messages.paginationEnabled = true
        messages.pullToRefreshEnabled = true
        
        return messages
    }
    
    class func CreateWithId(objectId: String) -> MessagesViewController {
        return CreateWithModel(PFObject(withoutDataWithClassName: kUserClassKey, objectId: objectId))
    }
}