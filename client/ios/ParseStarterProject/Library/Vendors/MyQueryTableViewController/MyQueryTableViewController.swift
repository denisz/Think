//
//  MyQueryTableViewController.swift
//  Think
//
//  Created by denis zaytcev on 8/14/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import ParseUI
import UIKit
import Bolts

class MyQueryTableViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var objects: NSMutableArray?
    var currentPage: Int = 0
    var firstLoad: Bool = true
    var objectsPerPage: Int = 25
    var loadingViewEnabled: Bool = true
    var paginationEnabled: Bool = true
    var pullToRefreshEnabled: Bool = true
    var reverseViewCell: Bool = false
    var lastLoadCount: Int = -1
    var parseClassName: String?
    var _loadingView: UIView?
    var loadingView: UIView? {
        if (_loadingView == nil) {
            self._loadingView = LoadingView(frame: CGRectZero)
        }
        return self._loadingView
    }
    var loading: Bool = false
    var savedSeparatorStyle: UITableViewCellSeparatorStyle?
    var refreshControl: UIRefreshControl?
    
    @IBOutlet weak var tableViewTopConstraint       : NSLayoutConstraint!
    @IBOutlet weak var tableViewLeadingConstraint   : NSLayoutConstraint!
    @IBOutlet weak var tableViewWidthConstraint     : NSLayoutConstraint!
    @IBOutlet weak var tableViewHeightConstraint    : NSLayoutConstraint!
    
    var shouldShowPaginationCell: Bool {
        return self.paginationEnabled
                && !self.editing
                && self.objects!.count != 0
                && (   lastLoadCount == -1
                    || lastLoadCount >= self.objectsPerPage)
    }
    
    var indexPathForPaginationCell: NSIndexPath {
        if self.reverseViewCell {
            return NSIndexPath(forRow: 0, inSection: 0)
        }
        
        return NSIndexPath(forRow: self.objects!.count, inSection: 0)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: NSStringFromClass(self.dynamicType), bundle: nibBundleOrNil)
        self.setupWithClassName(nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupWithClassName(nil)
    }
    
    func setupWithClassName(otherClassName: String?) {
        self.objects = NSMutableArray()
        
        self.firstLoad = true
        self.objectsPerPage = 16
        self.loadingViewEnabled = true
        self.paginationEnabled = true
        self.pullToRefreshEnabled = true
        self.reverseViewCell = false
        self.lastLoadCount = -1
        self.parseClassName = otherClassName
    }
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.tableView == nil {
            self.createSimpleTable()
        }
        
        self.initializeRefreshControl()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.loadObjects()
    }
    
    func initializeRefreshControl() {
        if self.pullToRefreshEnabled {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: Selector("refreshControlValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
            
            self.tableView.addSubview(refreshControl)
            self.tableView.sendSubviewToBack(refreshControl)
            self.refreshControl = refreshControl
        }
    }
    
    func createSimpleTable() {
        let tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        
        tableViewTopConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)

        tableViewLeadingConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)

        tableViewWidthConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)

        tableViewHeightConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)

        self.view.addConstraint(tableViewTopConstraint)
        self.view.addConstraint(tableViewLeadingConstraint)
        self.view.addConstraint(tableViewWidthConstraint)
        self.view.addConstraint(tableViewHeightConstraint)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView = tableView
    }
    
    func refreshControlValueChanged(sender: UIRefreshControl) {
        self.loadObjects()
    }
    
    func refreshLoadingView() {
        let showLoadingView = self.loadingViewEnabled && self.loading && self.firstLoad;
     
        if (showLoadingView) {
//            self.tableView.addSubview(self.loadingView!)
            let newView = self.loadingView!
            newView.alpha = 1.0
            newView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(newView)
            
            let views = ["view": newView]
            let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("|[view]|", options: [], metrics: nil, views: views)
            let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: [], metrics: nil, views: views)
            self.view.addConstraints(hConstraints)
            self.view.addConstraints(vConstraints)
        } else {
            if let loadingView = self.loadingView {
                UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    loadingView.alpha = 0
                }, completion: { (result) -> Void in
                    loadingView.removeFromSuperview()
                })
                
                self._loadingView = nil;
            }
        }
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        self.tableView.beginUpdates()
        
        if (self.paginationEnabled && self.shouldShowPaginationCell) {
            self.tableView.deleteRowsAtIndexPaths([self.indexPathForPaginationCell], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        
        super.setEditing(editing, animated: animated)
        
        if (self.paginationEnabled && self.shouldShowPaginationCell) {
            self.tableView.insertRowsAtIndexPaths([self.indexPathForPaginationCell], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        
        self.tableView.endUpdates()
    }
    
    func objectsWillLoad() {
        self.refreshLoadingView()
    }
    
    func objectsDidLoad(error: NSError?) {
        if (self.firstLoad) {
            self.firstLoad = false
        }

        self.refreshLoadingView()
    }
    
    func loadObjects() -> BFTask {
        return self.loadObjects(0, clear: true)
    }
    
    func objectsWillAppend(objects: [AnyObject]) {
        self.objects?.addObjectsFromArray(objects)
        self.objectsDidAppend(objects)
    }
    
    func objectsDidAppend(objects: [AnyObject]) {
        
    }
    
    func loadObjects(page: Int, clear: Bool) -> BFTask {
        self.loading = true
        self.objectsWillLoad()
        
        let source = BFTaskCompletionSource()
        
        let query = self.queryForTable()
        self._alterQuery(query, forLoadingPage: page)
        
        PFErrorCode.ErrorCacheMiss
        
        query.findObjectsInBackgroundWithBlock { (foundObjects:[PFObject]?, error: NSError?) in
            
            if (!Parse.isLocalDatastoreEnabled()
                && query.cachePolicy != PFCachePolicy.CacheOnly
//              && error!.code == PFErrorCode.ErrorCacheMiss
                ) {
                return
            }
            
            self.loading = false
            
            if (error != nil) {
                self.lastLoadCount = -1
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.refreshPaginationCell()
                    self.refreshLoadingView()
                })
            } else {
                self.currentPage = page
                self.lastLoadCount = foundObjects!.count
                
                if clear {
                    self.objects!.removeAllObjects()
                }
                
                self.objectsWillAppend(foundObjects!)
                source.trySetResult(foundObjects!)
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                    self.refreshLoadingView()
                })
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.objectsDidLoad(error)
                self.refreshControl?.endRefreshing()
            })
        }
        
        return source.task
    }
    
    func queryForTable() -> PFQuery {
        let query = PFQuery(className: self.parseClassName!)
        
        if (self.objects!.count == 0 && !Parse.isLocalDatastoreEnabled()) {
            query.cachePolicy = PFCachePolicy.CacheThenNetwork
        }
        
        query.orderByDescending("createdAt")
        
        return query
    }
    
    func _alterQuery(query: PFQuery, forLoadingPage page: Int) {
        if self.paginationEnabled && self.objectsPerPage > 0 {
            query.limit = self.objectsPerPage
            query.skip = page * self.objectsPerPage
        }
    }
    
    func clear() {
        objects?.removeAllObjects()
        self.tableView.reloadData()
        currentPage = 0
    }
    
    
    func loadNextPage() {
        if !self.loading {
            self.loadObjects(self.currentPage + 1, clear: false)
            self.refreshPaginationCell()
        }
    }
    
    func refreshPaginationCell() {
        if self.shouldShowPaginationCell {
            self.tableView.reloadRowsAtIndexPaths(
                [self.indexPathForPaginationCell],
                withRowAnimation: UITableViewRowAnimation.None)
        }
    }
    
    func loadImagesForOnscreenRows () {
        if self.objects!.count > 0 {
            let visiblePaths = self.tableView.indexPathsForVisibleRows
            
            for indexPath in visiblePaths! {
                self.loadImageForCellAtIndexPath(indexPath )
            }
        }
    }
    
    func loadImageForCellAtIndexPath(indexPath: NSIndexPath) {
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! PFTableViewCell
    
        if cell.isKindOfClass(PFTableViewCell) {
            cell.imageView?.loadInBackground()
        }
    }
    
    func handleDeletionError(error: NSError) {
        self.loadObjects()
    }
}

extension MyQueryTableViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = self.objects!.count
        if self.shouldShowPaginationCell {
            count += 1;
        }
        
        return count
    }
    
    //default implementation that displays a default style cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        let cellIndentifier = "PFTableViewCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIndentifier) as? PFTableViewCell
        
        if cell == nil {
            cell = PFTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIndentifier)
        }
        
        return cell!
    }
    
    func objectAtIndexPath(indexPath: NSIndexPath) -> PFObject? {
        if self.reverseViewCell {
            var index = -1
            let count = self.objects!.count
            
            if self.shouldShowPaginationCell {
                index = count - indexPath.row
            } else {
                index = count - indexPath.row - 1
            }

            if index >= 0 && index < count {
                return self.objects![index] as? PFObject
            } else {
                return nil
            }
        }
        
        return self.objects![indexPath.row] as? PFObject
    }
    
    func indexPathByObject(object: PFObject) -> NSIndexPath? {
        var index = IndexOf(self.objects!, object: object)
        
        if self.reverseViewCell {
            let count = self.objects!.count
            
            if self.shouldShowPaginationCell {
                index = count - index
            } else {
                index = count - index + 1
            }
        }
        
        if index == -1 {
            return nil
        }
        
        return NSIndexPath(forRow: index, inSection: 0)
    }
    
    func removeObjectAtIndexPath(indexPath: NSIndexPath) {
        self.removeObjectAtIndexPath(indexPath, animated: true)
    }
    
    func removeObjectAtIndexPath(indexPath: NSIndexPath, animated: Bool) {
        self.removeObjectsAtIndexPaths([indexPath], animated: true)
    }
    
    func removeObjectsAtIndexPaths(indexPaths: [NSIndexPath], animated:Bool) {
        
        if indexPaths.count == 0 {
            return;
        }
        
        let indexes = NSMutableIndexSet()
        
        for indexPath in indexPaths {
            if indexPath.section == 0 {
                if indexPath.row < self.objects!.count {
                    indexes.addIndex(indexPath.row)
                }
            }
        }
        
        let allDeletionTasks = NSMutableArray(capacity: indexes.count)
        let objectsToRemove = self.objects!.objectsAtIndexes(indexes)
        
        let animation: UITableViewRowAnimation = (animated == true ? .Automatic : .None)
        
        self.objects!.removeObjectsInArray(objectsToRemove)
        self.tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: animation)
        
        for obj in objectsToRemove {
            allDeletionTasks.addObject(obj.deleteInBackground())
        }
        
        BFTask(forCompletionOfAllTasks: allDeletionTasks as [AnyObject]).continueWithBlock { (task:BFTask!) -> AnyObject! in
            self.refreshControl?.enabled = true
            if (task.error != nil) {
                self.handleDeletionError(task.error!)
            }
            return nil
        }
    }
    
    func tableView(tableView: UITableView, cellForNextPageAtIndexPath indexPath: NSIndexPath) -> PFTableViewCell? {
        let cellIdentifier = "PFTableViewCellNextPage"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? MyActivityTableViewCell
        
        if cell == nil {
            cell = MyActivityTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
            cell!.separatorInset = UIEdgeInsetsMake(0, cell!.bounds.size.width, 0, 0);
        }
        
        cell!.setAnimating(self.loading)
        
        return cell
    }
    
    func checkLastCell(indexPath: NSIndexPath) -> Bool {
        if (self.shouldShowPaginationCell) {
            return self.objects!.count == indexPath.row
        }
        
        return self.objects!.count == (indexPath.row + 1)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: PFTableViewCell?
        
        if self.shouldShowPaginationCell && indexPath.isEqual(self.indexPathForPaginationCell) {
            cell = self.tableView(tableView, cellForNextPageAtIndexPath: indexPath)
        } else {
            cell = self.tableView(tableView,
                cellForRowAtIndexPath: indexPath,
                object: self.objectAtIndexPath(indexPath))
        }
        
        if  (cell!.isKindOfClass(PFTableViewCell)
            && !tableView.dragging
            && !tableView.decelerating) {
                
            dispatch_async(dispatch_get_main_queue(), {
                cell!.imageView?.loadInBackground()
            })
        }
        
//        if self.reverseViewCell && self.checkLastCell(indexPath) {
//            cell!.separatorInset = UIEdgeInsetsMake(0, cell!.bounds.size.width, 0, 0);
//        }
        
        return cell!
    }
}

extension MyQueryTableViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        if  indexPath.isEqual(self.indexPathForPaginationCell) {
            return .None
        }
        
        return .Delete
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (!self.firstLoad &&
            self.paginationEnabled &&
            indexPath.isEqual(self.indexPathForPaginationCell)) {
                self.loadNextPage();
        } else {
            let count = self.objects!.count
            
            if count > indexPath.row {
                if let object = self.objectAtIndexPath(indexPath) {
                    self.tableView(self.tableView, didSelectRowAtIndexPath: indexPath, object: object)
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) {
        
    }
    
    func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.isEqual(self.indexPathForPaginationCell) {
            return false
        }
        
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    @available(iOS 8.0, *)
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?  {
        if  indexPath.isEqual(self.indexPathForPaginationCell) {
            return nil
        }
        
        let result = self.tableView(tableView,
            editActionsForRowAtIndexPath: indexPath,
            object: self.objectAtIndexPath(indexPath))
        
        return result
    }
    
    @available(iOS 8.0, *)
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> [UITableViewRowAction]? {
        return nil
    }
}

extension MyQueryTableViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
    }
}