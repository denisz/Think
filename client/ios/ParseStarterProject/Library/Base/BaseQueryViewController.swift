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


class BaseQueryViewController: StatefulViewController, StatefulViewControllerDelegate {
    var object: PFObject?
    var className: String? { return nil }
    var objectID: String?
    
    func hasContent() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureStateMachine()
        self.createObject()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.refresh()
    }
    
    func configureStateMachine() {
        loadingView = LoadingView(frame: view.frame)
        emptyView = EmptyView(frame: view.frame)
        let failureView = ErrorView(frame: view.frame)
        failureView.tapGestureRecognizer.addTarget(self, action: Selector("refresh"))
        errorView = failureView
    }
    
    func createObject() {
        if self.object == nil {
            self.object = PFObject(withoutDataWithClassName:self.className!, objectId:self.objectID)
        }
    }
    
    func refresh() {
        self.objectWillLoad(self.object!)
        self.object?.fetchIfNeededInBackground().continueWithBlock({
            (task: BFTask!) -> AnyObject! in
            if task.error != nil {
                // There was an error.
                dispatch_async(dispatch_get_main_queue()) {
                    self.objectErrorLoad(self.object!, error: task.error)
                }
                return task
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.objectDidLoad(task.result as! PFObject)
            }
            
            return task
        })
    }
    
    func objectWillLoad(object: PFObject) {
        self.startLoading(animated: false)
    }
    
    func objectDidLoad(object: PFObject) {
       self.endLoading(animated: true, error: nil)
    }
    
    func objectErrorLoad(object: PFObject, error: NSError?) {
       self.endLoading(animated: true, error: error)
    }
}