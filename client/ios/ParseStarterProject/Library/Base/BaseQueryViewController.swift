//
//  BaseQueryViewController.swift
//  Think
//
//  Created by denis zaytcev on 8/7/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import UIKit
import Bolts

class BaseQueryViewController: BaseViewController, StatefulViewControllerDelegate {
    var object: PFObject?
    var parseClassName: String?
    var objectID: String?
    
    private var isRefreshing: Bool = false
    
    func hasContent() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureStateMachine()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if isRefreshing == false {
            self.refresh()
            isRefreshing = true
        }        
    }
    
    func allowContent() -> Bool {
        return true
    }
    
    func configureStateMachine() {
        loadingView = LoadingView(frame: view.frame)
        emptyView = EmptyView(frame: view.frame)
        let failureView = ErrorView(frame: view.frame)
        failureView.tapGestureRecognizer.addTarget(self, action: Selector("refresh"))
        errorView = failureView
        denyView = DenyView(frame: view.frame)
    }
    
    func queryForView() -> PFQuery {
        let query = PFQuery(className: self.parseClassName!)
        return query;
    }
    
    func refresh() {
        self.objectWillLoad(self.object!)
        
        let query = self.queryForView()
        query.getObjectInBackgroundWithId(self.object!.objectId!) {
            (object: PFObject?, error: NSError?) -> Void in
            if error == nil && object != nil {
                self.object = object
                dispatch_async(dispatch_get_main_queue()) {
                    self.objectDidLoad(object!)
                }
            } else {
                // There was an error.
                dispatch_async(dispatch_get_main_queue()) {
                    self.objectErrorLoad(object!, error: error)
                }
            }
        }
    }
    
    func objectWillLoad(object: PFObject) {
        self.startLoading(false)
    }
    
    func objectDidLoad(object: PFObject) {
        if !allowContent() {
            self.denyContent(false)
        } else {
            self.endLoading(false, error: nil)
        }
    }
    
    func objectErrorLoad(object: PFObject, error: NSError?) {
       self.endLoading(false, error: error)
    }
}

extension BaseQueryViewController: UIScrollViewDelegate {}