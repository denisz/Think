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
        
        self.view.backgroundColor = kColorBackgroundViewController
        self.tableView.backgroundColor = kColorBackgroundViewController
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None

        self.form = XLFormDescriptor()
        
        self.setupSections()
        
        self.configureNavigationBarSendBtn(kColorNavigationBar)
        self.configureNavigationBarBackBtn(kColorNavigationBar)
    }
    
    func configureNavigationBarSendBtn(color: UIColor) {
        var image = UIImage(named: "ic_send") as UIImage!
        image = image.imageWithColor(color)
        
        var btnBack:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        btnBack.addTarget(self, action: "didTapSendBtn:", forControlEvents: UIControlEvents.TouchUpInside)
        btnBack.setImage(image, forState: UIControlState.Normal)
        btnBack.contentEdgeInsets = UIEdgeInsets(top: -5, left: 0, bottom: 0, right: 0)
        btnBack.imageEdgeInsets = UIEdgeInsets(top: 14, left: 28, bottom: 14, right: 0)
        btnBack.setTitleColor(kColorNavigationBar, forState: UIControlState.Normal)
        btnBack.sizeToFit()
        var myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: btnBack)
        self.navigationItem.rightBarButtonItem  = myCustomBackButtonItem
    }
    
    func didTapSendBtn(sender: AnyObject?) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func setupSections() {
        var row: XLFormRowDescriptor
        var section: XLFormSectionDescriptor
        
        section = XLFormSectionDescriptor()
        self.form.addFormSection(section)
        
        row = XLFormRowDescriptor(tag: tag.adultContent, rowType: XLFormRowDescriptorTypeBooleanSwitch, title: "Adult content".uppercaseString)
        self.stylesRow(row)
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor()
        self.form.addFormSection(section)
        
        //tags
        row = XLFormRowDescriptor(tag: tag.tags, rowType: XLFormRowDescriptorTypeMultipleSelector, title: "Tags".uppercaseString)
        row.selectorOptions = self.selectorsTags()
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
    
    func selectorsTags() -> [XLFormOptionsObject] {
        var tags: [String] = ["tag1", "tag2"]
        var options = [XLFormOptionsObject]()
        
        for tag in tags {
            options.append(XLFormOptionsObject(value: tag, displayText: tag.uppercaseString))
        }
        
        return options
    }
}
