//
//  MyQueryCollectionVireController.swift
//  Think
//
//  Created by denis zaytcev on 8/30/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import ParseUI
import Bolts
import UIKit

let PFQueryCollectionViewNextPageReusableViewIdentifier: String = "nextPageView"

class MyQueryCollectionViewController: UIViewController{
    @IBOutlet weak var collectionView: UICollectionView!
    
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
    var currentNextPageView: MyActivityIndicatorCollectionReusableView?
    
    @IBOutlet weak var collectionViewTopConstraint       : NSLayoutConstraint!
    @IBOutlet weak var collectionViewLeadingConstraint   : NSLayoutConstraint!
    @IBOutlet weak var collectionViewWidthConstraint     : NSLayoutConstraint!
    @IBOutlet weak var collectionViewHeightConstraint    : NSLayoutConstraint!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: NSStringFromClass(self.dynamicType), bundle: nibBundleOrNil)
        self.setupWithClassName(nil)
    }
    
    var shouldShowPaginationCell: Bool {
        return self.paginationEnabled
            && self.objects!.count != 0
            && (   lastLoadCount == -1
                || lastLoadCount >= self.objectsPerPage)
    }
    
    var indexPathForPaginationReusableView: NSIndexPath {
        return NSIndexPath(forItem: 0, inSection: self.numberOfSectionsInCollectionView(self.collectionView) - 1)
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
        
        if self.collectionView == nil {
            return
        }
        
        self.setupCollectionView()
        self.initializeRefreshControl()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.loadObjects()
    }
    
    func setupCollectionView() {
        self.collectionView.registerNib(UINib(nibName: "MyActivityIndicatorCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: PFQueryCollectionViewNextPageReusableViewIdentifier)
        
        self.collectionView.alwaysBounceVertical = true
    }
    
    func initializeRefreshControl() {
        if self.pullToRefreshEnabled {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: Selector("refreshControlValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
            
            self.collectionView.addSubview(refreshControl)
            self.collectionView.sendSubviewToBack(refreshControl)
            self.refreshControl = refreshControl
        }
    }
    
    func refreshControlValueChanged(sender: UIRefreshControl) {
        if !self.loading {
            self.loadObjects()
        }
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
    
    func loadObjects() -> BFTask {
        return self.loadObjects(0, clear: true)
    }
    
    func loadNextPage() {
        if !self.loading {
            self.loadObjects(self.currentPage + 1, clear: false)
            currentNextPageView?.setAnimating(true)
        }
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
        
        let query = self.queryForCollection()
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
                self.currentNextPageView?.setAnimating(false)
                source.setError(error!)
            } else {
                self.currentPage = page
                self.lastLoadCount = foundObjects!.count
                
                if clear {
                    self.objects?.removeAllObjects()
                }
                
                self.objectsWillAppend(foundObjects!)
                
                source.trySetResult(foundObjects!)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.collectionView.reloadData()
                })
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.objectsDidLoad(error)
                self.refreshControl?.endRefreshing()
            })
            
            
        }
        
        return source.task
    }
    
    func queryForCollection() -> PFQuery {
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
        self.collectionView.reloadData()
        currentPage = 0
    }
    
    func handleDeletionError(error: NSError) {
        self.loadObjects()
    }
}

extension MyQueryCollectionViewController: UICollectionViewDelegate {
    
}

extension MyQueryCollectionViewController: UICollectionViewDataSource {

    func objectAtIndexPath(indexPath: NSIndexPath) -> PFObject? {
        return self.objects![indexPath.row] as? PFObject
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.objects!.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return self.collectionView(collectionView, cellForItemAtIndexPath:indexPath, object: self.objectAtIndexPath(indexPath))
    }
    
    func collectionViewReusableViewForNextPageAction(collectionView: UICollectionView) -> UICollectionReusableView {
        currentNextPageView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: PFQueryCollectionViewNextPageReusableViewIdentifier, forIndexPath: self.indexPathForPaginationReusableView) as? MyActivityIndicatorCollectionReusableView
        
        currentNextPageView?.button.addTarget(self, action: "loadNextPage", forControlEvents: UIControlEvents.TouchUpInside)
        currentNextPageView?.setAnimating(self.loading)
        
        return currentNextPageView!
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFCollectionViewCell {
        
        return PFCollectionViewCell()
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        return self.collectionViewReusableViewForNextPageAction(collectionView)
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
        
        self.objects!.removeObjectsInArray(objectsToRemove)
        self.collectionView.deleteItemsAtIndexPaths(indexPaths)
        
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
}

extension MyQueryCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.shouldShowPaginationCell {
            return CGSizeMake(CGRectGetWidth(collectionView.bounds), 50)
        }
        
        return CGSizeZero
    }
}


