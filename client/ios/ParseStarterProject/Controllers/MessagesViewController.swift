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

let kReusableMessageViewCell = "MessageViewCell"

@objc(MessagesViewController) class MessagesViewController: BaseGestureQueryTableViewController {
    var owner: PFObject?
    var filteredTableData = [AnyObject]()
    var searchController: UISearchController?
    
    let trashIcon = FAKIonIcons.ios7TrashIconWithSize(30)
    let sizeIcon = CGSizeMake(30, 30)
    let redColor = UIColor(red: 213.0/255, green: 70.0/255, blue: 70.0/255, alpha: 1)
    let greenColor = UIColor(red: 85.0/255, green: 213.0/255, blue: 80.0/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Messages"
        self.tableView.registerNib(UINib(nibName: kReusableMessageViewCell, bundle: nil), forCellReuseIdentifier: kReusableMessageViewCell)
        
        self.view.backgroundColor = kColorBackgroundViewController
        self.tableView.backgroundColor = kColorBackgroundViewController
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 44.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.tableFooterView = UIView()
        
        self.customizeNavigationBar()
        self.configureNavigationBarBackBtn(kColorNavigationBar)
        self.configureNavigationBarNewMessageBtn(kColorNavigationBar)
        
        self.configureSearchBar()
        
        trashIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
    }
    
    override func customizeNavigationBar() {
        self.automaticallyAdjustsScrollViewInsets = false
        var navigationBar = self.navigationController?.navigationBar
        
        navigationBar?.titleTextAttributes = [
            NSForegroundColorAttributeName: kColorNavigationBar,
            NSFontAttributeName: UIFont(name: "OpenSans-Light", size: 19)!
        ]
        
        // Sets background to a blank/empty image
        navigationBar?.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Compact)
        // Sets shadow (line below the bar) to a blank image
        navigationBar?.shadowImage = UIImage()
        // Sets the translucent background color
        navigationBar?.backgroundColor = UIColor.whiteColor()
        // Set translucent. (Default value is already true, so this can be removed if desired.)
        navigationBar?.translucent = false
    }
    
    func configureSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        self.definesPresentationContext = true
        searchController?.searchResultsUpdater = self
        searchController?.hidesNavigationBarDuringPresentation = true
        searchController?.dimsBackgroundDuringPresentation = false
        searchController?.searchBar.sizeToFit()
        searchController?.searchBar.showsCancelButton = false
        searchController?.searchBar.tintColor = kColorNavigationBar
        searchController?.searchBar.translucent = false
        searchController?.searchBar.barTintColor = UIColor.whiteColor()
        searchController?.searchBar.searchBarStyle = UISearchBarStyle.Default
        searchController?.searchBar.setBackgroundImage(UIImage(), forBarPosition: UIBarPosition.Top, barMetrics: UIBarMetrics.Compact)
//        searchController?.searchBar.layer.borderWidth = 0
        
//        searchController!.searchBar.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.tableView.tableHeaderView = searchController!.searchBar
//        self.view.addSubview(searchController!.searchBar)
//        
//        let constraint_H:Array = NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["view":searchController!.searchBar])
//        let constraint_V:Array = NSLayoutConstraint.constraintsWithVisualFormat("V:|[view(44)]|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["view":searchController!.searchBar])
//        
//        self.view.addConstraints(constraint_H)
//        self.view.addConstraints(constraint_V)
    }
    
    func configureNavigationBarNewMessageBtn(color: UIColor) {
        var image = UIImage(named: "ic_new_post") as UIImage!
        image = image.imageWithColor(color)
        
        let btnBack = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        btnBack.addTarget(self, action: "didTapNewMessageBtn:", forControlEvents: UIControlEvents.TouchUpInside)
        btnBack.setImage(image, forState: UIControlState.Normal)
        btnBack.imageEdgeInsets = UIEdgeInsets(top: 1, left: 0, bottom: 2, right: 0)
        btnBack.setTitleColor(kColorNavigationBar, forState: UIControlState.Normal)
        btnBack.frame = CGRectMake(0, 0, 30, 32)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btnBack)
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
        var query = PFQuery(className: self.parseClassName!)
        query.whereKey("owner", equalTo: owner!)
        query.orderByDescending("createdAt")
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        let cell = tableView.dequeueReusableCellWithIdentifier(kReusableMessageViewCell) as! MessageViewCell
        cell.prepareView(object!)
        
        let icon = trashIcon.imageWithSize(sizeIcon)
        cell.firstRightAction = SBGestureTableViewCellAction(icon: icon, color: UIColor.clearColor(), fraction: 0.3, didTriggerBlock: { (tableView, cell) -> () in
            
        })
        cell.firstLeftAction = SBGestureTableViewCellAction(icon: icon, color: UIColor.clearColor(), fraction: 0.3, didTriggerBlock: { (tableView, cell) -> () in
            
        })
        cell.secondRightAction = SBGestureTableViewCellAction(icon: icon, color: redColor, fraction: 0.6, didTriggerBlock: { (tableView, cell) -> () in
            
        })
        
        cell.secondLeftAction = SBGestureTableViewCellAction(icon: icon, color: greenColor, fraction: 0.6, didTriggerBlock: { (tableView, cell) -> () in
            
        })
        
        return cell
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle  {
        return UIStatusBarStyle.Default
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
         let object = self.objects![indexPath.row] as! PFObject
        
         let controller = CommentsViewController()
         self.navigationController?.pushViewController(controller, animated: true)
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

extension MessagesViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filteredTableData.removeAll(keepCapacity: false)
        
//        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text)
//        
//        let array = (self.objects as NSArray).filteredArrayUsingPredicate(searchPredicate)
//        filteredTableData = array as! [AnyObject]
        
        self.tableView.reloadData()
    }
}