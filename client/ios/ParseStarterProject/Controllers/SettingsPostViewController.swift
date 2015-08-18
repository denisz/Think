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


class SettingsPostViewController: BaseFormViewController {
    var model: PFObject?
    var data: [String: AnyObject]?
    
    struct tag {
        static let tags             = "tags"
        static let postTo           = "postTo"
        static let visibleTo        = "visibleTo"
        static let comments         = "comments"
        static let exportTo         = "exportTo"
        static let location         = "location"
        static let hideComments     = "hideComments"
        static let socialCounter    = "socialCounter"
        static let adultContent     = "adultContent"
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
    
    func configureNavigationBarRightBtn(color: UIColor) {
        let navigationItem  = self.defineNavigationItem()
        
        let editBarButtonItem = UIBarButtonItem(title: "Send".uppercaseString, style: UIBarButtonItemStyle.Plain, target: self, action: "didTapSendBtn:")
        
        let attributes = [
            NSForegroundColorAttributeName: color,
            NSFontAttributeName: kFontNavigationItem
        ]
        editBarButtonItem.setTitleTextAttributes(attributes, forState: UIControlState.Normal)
        navigationItem.rightBarButtonItem = editBarButtonItem
    }
    
    func didTapSendBtn(sender: AnyObject?) {
        self.dismissViewControllerAnimated(true, completion: nil)
//        self.navigationController?.popToRootViewControllerAnimated(true)
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
    
    }
}
