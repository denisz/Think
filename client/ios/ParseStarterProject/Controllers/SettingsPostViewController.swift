//
//  SettingsPostViewController.swift
//  Think
//
//  Created by denis zaytcev on 8/10/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit
import XLForm
import Parse
import ParseUI
import Bolts

class SettingsPostViewController: BaseFormViewController {
    var object: PFObject?
    var data: [String: AnyObject]?
    
    struct tag {
        static let tags             = kPostTagsKey
        static let postTo           = kPostOptPostTo        //"postTo"
        static let visibleTo        = kPostOptVisibleTo     //"visibleTo"
        static let comments         = kPostOptComments      //"comments"
        static let exportTo         = kPostOptExportTo      //"exportTo"
        static let location         = kPostOptLocation      //"location"
        static let hideComments     = kPostOptHideComments  //"hideComments"
        static let socialCounter    = kPostOptSocialCounter //"socialCounter"
        static let adultContent     = kPostOptAdultContent  //"adultContent"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tune post"
        self.data = [String: AnyObject]()
        
        self.view.backgroundColor = kColorBackgroundViewController
        self.tableView.backgroundColor = kColorBackgroundViewController
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None

        self.form = XLFormDescriptor()
        
        self.setupSections()
        self.setupNavigationBar()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.customizeNavigationBar()
        self.configureNavigationBarRightBtn(kColorNavigationBar)
        self.configureNavigationBarBackBtn(kColorNavigationBar)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)
    }
    
    func configureNavigationBarRightBtn(color: UIColor) {
        let navigationItem  = self.defineNavigationItem()
        
        let editBarButtonItem = UIBarButtonItem(title: "Public".uppercaseString, style: UIBarButtonItemStyle.Plain, target: self, action: "didTapSendBtn:")
        
        let attributes = [
            NSForegroundColorAttributeName: color,
            NSFontAttributeName: kFontNavigationItem
        ]
        editBarButtonItem.setTitleTextAttributes(attributes, forState: UIControlState.Normal)
        navigationItem.rightBarButtonItem = editBarButtonItem
    }
    
    func didTapSendBtn(sender: AnyObject?) {
        let overlay = OverlayView.createInView(self.view)
        Post.publicPost(self.object!, withSettings: self.data!).continueWithBlock { (task: BFTask!) -> AnyObject! in
            
            dispatch_async(dispatch_get_main_queue()) {
                overlay.removeFromSuperview()
            }
            
            if task.error != nil {
                let alertView = UIAlertView(
                    title: "Error public your post",
                    message: "Post error public",
                    delegate: nil,
                    cancelButtonTitle: "Not Now",
                    otherButtonTitles: "OK"
                )
                dispatch_async(dispatch_get_main_queue()) {
                    alertView.show()
                }
            } else {
                //successful new post
                dispatch_async(dispatch_get_main_queue()) {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
            
            return nil
        }
    }
    
    func setupSections() {
        var row: XLFormRowDescriptor
        var section: XLFormSectionDescriptor
        
        section = XLFormSectionDescriptor()
        self.form.addFormSection(section)
        
        row = XLFormRowDescriptor(tag: tag.adultContent, rowType: XLFormRowDescriptorTypeBooleanSwitch, title: "adult content".uppercaseString)
        self.stylesRow(row)
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor()
        self.form.addFormSection(section)
        
        //tags
        row = XLFormRowDescriptor(tag: tag.tags, rowType: XLFormRowDescriptorTypeSelectorPush, title: "tags".uppercaseString)
        row.action.viewControllerClass = RRTagController.self
        self.stylesRow(row)
        section.addFormRow(row)
        
        
        row = XLFormRowDescriptor(tag: tag.postTo, rowType: XLFormRowDescriptorTypeMultipleSelector, title: "post to".uppercaseString)
        row.selectorOptions = self.selectorsPostTo()
        self.stylesRow(row)
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: tag.visibleTo, rowType: XLFormRowDescriptorTypeMultipleSelector, title: "visible to".uppercaseString)
        row.selectorOptions = self.selectorsVisibleTo()
        self.stylesRow(row)
        section.addFormRow(row)

        row = XLFormRowDescriptor(tag: tag.comments, rowType: XLFormRowDescriptorTypeMultipleSelector, title: "comments".uppercaseString)
        row.selectorOptions = self.selectorsComments()
        self.stylesRow(row)
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: tag.exportTo, rowType: XLFormRowDescriptorTypeMultipleSelector, title: "export to".uppercaseString)
        row.selectorOptions = self.selectorsExportTo()
        self.stylesRow(row)
        section.addFormRow(row)

        
        row = XLFormRowDescriptor(tag: tag.socialCounter, rowType: XLFormRowDescriptorTypeBooleanSwitch , title: "social counters".uppercaseString)
        self.stylesRow(row)
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor()
        self.form.addFormSection(section)

        row = XLFormRowDescriptor(tag: tag.location, rowType: XLFormRowDescriptorTypeBooleanSwitch , title: "location".uppercaseString)
        self.stylesRow(row)
        section.addFormRow(row)

    }
    
    func selectorsExportTo() -> [XLFormOptionsObject] {
        var options = [XLFormOptionsObject]()
        
        return options
    }
    
    func selectorsComments() -> [XLFormOptionsObject] {
        var options = [XLFormOptionsObject]()
        
        return options
    }
    
    func selectorsVisibleTo() -> [XLFormOptionsObject] {
        var options = [XLFormOptionsObject]()
        
        return options
    }
    
    func selectorsPostTo() -> [XLFormOptionsObject] {
        var options = [XLFormOptionsObject]()
        
        return options
    }
    
    override func formRowDescriptorValueHasChanged(formRow: XLFormRowDescriptor!, oldValue: AnyObject!, newValue: AnyObject!) {
        if let tag = formRow.tag {
            self.data![tag] = newValue
        }
    }
}
