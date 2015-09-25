//
//  MyQueryTableView.swift
//  Think
//
//  Created by denis zaytcev on 8/24/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import ParseUI
import Bolts


class MyQueryTableView: UITableView {
    var objects:NSMutableArray?
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupWithClassName(nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupWithClassName(nil)
    }
    
    init(frame: CGRect) {
        super.init(frame: frame, style: UITableViewStyle.Plain)
        self.setupWithClassName(nil)
    }
    
    func setupWithClassName(otherClassName: String?) {
        self.objects = NSMutableArray()
        
        self.firstLoad = true
        self.objectsPerPage = 16
        self.loadingViewEnabled = true
        self.paginationEnabled = true
        self.pullToRefreshEnabled = true
        self.lastLoadCount = -1
        self.reverseViewCell = false
        self.parseClassName = otherClassName
        
        self.delegate = self
        self.dataSource = self
        self.viewDidLoad()
    }
    
    func viewDidLoad() {
        if self.pullToRefreshEnabled {
            self.setupRefreshControl()
        }
    }
    
    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("refreshControlValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        
        self.refreshControl = refreshControl
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
            self.addSubview(newView)
            
            let views = ["view": newView]
            let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("|[view]|", options: [], metrics: nil, views: views)
            let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: [], metrics: nil, views: views)
            self.addConstraints(hConstraints)
            self.addConstraints(vConstraints)
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
        self.beginUpdates()
        
        if (self.paginationEnabled && self.shouldShowPaginationCell) {
            self.deleteRowsAtIndexPaths([self.indexPathForPaginationCell], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        
        super.setEditing(editing, animated: animated)
        
        if (self.paginationEnabled && self.shouldShowPaginationCell) {
            self.insertRowsAtIndexPaths([self.indexPathForPaginationCell], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        
        self.endUpdates()
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
    
    func loadObjects(page: Int, clear: Bool) -> BFTask {
        self.loading = true
        self.objectsWillLoad()
        
        let source = BFTaskCompletionSource()
        
        let query = self.queryForTable()
        self._alterQuery(query, forLoadingPage: page)
        
        PFErrorCode.ErrorCacheMiss
        
        query.findObjectsInBackgroundWithBlock { (foundObjects:[AnyObject]?, error: NSError?) in
            
            if (!Parse.isLocalDatastoreEnabled()
                && query.cachePolicy != PFCachePolicy.CacheOnly
                //              && error!.code == PFErrorCode.ErrorCacheMiss
                ) {
                    return
            }
            
            self.loading = false
            
            if (error != nil) {
                self.lastLoadCount = -1
                self.refreshPaginationCell()
            } else {
                self.currentPage = page
                self.lastLoadCount = foundObjects!.count
                
                if clear {
                    self.objects?.removeAllObjects()
                }
                
                self.objects?.addObjectsFromArray(foundObjects!)
                self.reloadData()
            }
            
            self.objectsDidLoad(error)
            self.refreshControl?.endRefreshing()
            
            source.setError(error)
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
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func _alterQuery(query: PFQuery, forLoadingPage page: Int) {
        if self.paginationEnabled && self.objectsPerPage > 0 {
            query.limit = self.objectsPerPage
            query.skip = page * self.objectsPerPage
        }
    }
    
    func clear() {
        objects?.removeAllObjects()
        self.reloadData()
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
            self.reloadRowsAtIndexPaths(
                [self.indexPathForPaginationCell],
                withRowAnimation: UITableViewRowAnimation.None)
        }
    }
    
    func loadImagesForOnscreenRows () {
        if self.objects!.count > 0 {
            let visiblePaths = self.indexPathsForVisibleRows
            
            for indexPath in visiblePaths! {
                self.loadImageForCellAtIndexPath(indexPath )
            }
        }
    }
    
    func loadImageForCellAtIndexPath(indexPath: NSIndexPath) {
        let cell = self.cellForRowAtIndexPath(indexPath) as! PFTableViewCell
        
        if cell.isKindOfClass(PFTableViewCell) {
            cell.imageView?.loadInBackground()
        }
    }
    
    func handleDeletionError(error: NSError) {
        self.loadObjects()
    }
}

extension MyQueryTableView: UITableViewDataSource {
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
        self.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: animation)
        
        for obj in objectsToRemove {
            allDeletionTasks.addObject(obj.deleteInBackground())
        }
        
        BFTask(forCompletionOfAllTasks: allDeletionTasks as [AnyObject]).continueWithBlock { (task:BFTask!) -> AnyObject! in
            self.refreshControl?.enabled = true
            if (task.error != nil) {
                self.handleDeletionError(task.error)
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if iOS8 {
            return UITableViewAutomaticDimension
        } else {
            return 44
        }
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
            && tableView.dragging
            && tableView.decelerating) {
                dispatch_async(dispatch_get_main_queue(), {
                    cell!.imageView?.loadInBackground()
                })
        }
        
        return cell!
    }
}

extension MyQueryTableView: UITableViewDelegate {
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
        }
        
    }
    
    func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.isEqual(self.indexPathForPaginationCell) {
            return false
        }
        
        return true
    }
}

extension MyQueryTableView: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
    }
}
