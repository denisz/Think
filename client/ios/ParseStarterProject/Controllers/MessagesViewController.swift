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

let kReusableMessageViewCell = "MessageViewCell"

@objc(MessagesViewController) class MessagesViewController: BaseQuerySearchTableViewController {
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
        
        self.configureSearchBar()
        self.setupNavigationBar()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.customizeNavigationBar()
        self.configureNavigationItem()
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
        self.navigationController?.popViewControllerAnimated(true)
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
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default;
    }
    
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: self.parseClassName!)
        
        query.whereKey("owner", equalTo: owner!)
        
        if let searchText = self.getSearchText() {
            query.whereKey("content_search", hasPrefix: searchText)
        }

        query.orderByDescending("createdAt")
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        let cell = tableView.dequeueReusableCellWithIdentifier(kReusableMessageViewCell) as! MessageViewCell
        cell.prepareView(object!)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) {
        var controller = ChannelViewController.CreateWithModel(object!)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle  {
        return UIStatusBarStyle.Default
    }
    
    class func CreateWithModel(model: PFObject) -> MessagesViewController{
        var messages = MessagesViewController()
        messages.owner = model
        messages.parseClassName = "Post"
        messages.paginationEnabled = true
        messages.pullToRefreshEnabled = false
        
        return messages
    }
    
    class func CreateWithId(objectId: String) -> MessagesViewController {
        return CreateWithModel(PFObject(withoutDataWithClassName: "_User", objectId: objectId))
    }
}