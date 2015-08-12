//
//  ProfileEditViewController.swift
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
import VGParallaxHeader

@objc(ProfileEditViewController) class ProfileEditViewController: BaseFormViewController {
    var owner: PFObject?
    
    struct tag {
        static let firstName        = "firstName"
        static let lastName         = "lastName"
        static let country          = "country"
        static let city             = "city"
        static let dateOfBirth      = "dateOfBirth"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var header = ProfileEditHeaderView()
        header.object = self.owner
        self.tableView.setParallaxHeaderView(header, mode: VGParallaxHeaderMode.Fill, height: 240)
        self.view.backgroundColor = kColorBackgroundViewController
        self.tableView.backgroundColor = kColorBackgroundViewController
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None

        self.form = XLFormDescriptor()
        
        self.setupSections()
        self.customizeNavigationBar()
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        self.tableView.shouldPositionParallaxHeader();
    }
    
    override func customizeNavigationBar() {
        self.automaticallyAdjustsScrollViewInsets = false
        var navigationBar = self.navigationController?.navigationBar
        
        // Sets background to a blank/empty image
        navigationBar?.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        // Sets shadow (line below the bar) to a blank image
        navigationBar?.shadowImage = UIImage()
        // Sets the translucent background color
        navigationBar?.backgroundColor = UIColor.clearColor()
        //UIColor(red:0, green:0, blue:0, alpha:0.5)
        //
        // Set translucent. (Default value is already true, so this can be removed if desired.)
        navigationBar?.translucent = true
        
        let attributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "OpenSans-Light", size: 18)!
        ]
        
        let cancelBarButtonItem = UIBarButtonItem(title: "Cancel".uppercaseString, style: UIBarButtonItemStyle.Plain, target: self, action: "didTapCancel:")
        cancelBarButtonItem.setTitleTextAttributes(attributes, forState: UIControlState.Normal)
        self.navigationItem.leftBarButtonItem = cancelBarButtonItem
        
        let editBarButtonItem = UIBarButtonItem(title: "Done".uppercaseString, style: UIBarButtonItemStyle.Plain, target: self, action: "didTapDone:")
        editBarButtonItem.setTitleTextAttributes(attributes, forState: UIControlState.Normal)
        self.navigationItem.rightBarButtonItem = editBarButtonItem
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent;
    }
    
    func setupSections() {
        var row: XLFormRowDescriptor
        var section: XLFormSectionDescriptor
        
        section = XLFormSectionDescriptor()
        self.form.addFormSection(section)
        
        row = XLFormRowDescriptor(tag: tag.firstName, rowType: XLFormRowDescriptorTypeText, title: "First Name".uppercaseString)
        self.stylesRow(row)
        section.addFormRow(row)

        row = XLFormRowDescriptor(tag: tag.lastName, rowType: XLFormRowDescriptorTypeText, title: "Last Name".uppercaseString)
        self.stylesRow(row)
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor()
        self.form.addFormSection(section)

        row = XLFormRowDescriptor(tag: tag.country, rowType: XLFormRowDescriptorTypeText, title: "Country".uppercaseString)
        self.stylesRow(row)
        section.addFormRow(row)

        row = XLFormRowDescriptor(tag: tag.country, rowType: XLFormRowDescriptorTypeText, title: "City".uppercaseString)
        self.stylesRow(row)
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: tag.dateOfBirth, rowType: XLFormRowDescriptorTypeDate, title: "Date of birth".uppercaseString)
        self.stylesRow(row)
        section.addFormRow(row)
    
    }
    
    func didTapDone(sender: AnyObject?) {
        popViewController()
    }

    func didTapCancel(sender: AnyObject?) {
       popViewController()
    }
    
    func popViewController() {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
        UIView.setAnimationDuration(0.75)
        UIView.setAnimationTransition(UIViewAnimationTransition.CurlDown, forView: self.navigationController!.view , cache: false)
        UIView.commitAnimations()
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDelay(0.375)
        self.navigationController?.popViewControllerAnimated(false)
        UIView.commitAnimations()
    }
    
    class func CreateWithModel(model: PFObject) -> ProfileEditViewController{
        var profile = ProfileEditViewController()
        profile.owner = model
        
        return profile
    }
    
    class func CreateWithId(objectId: String) -> ProfileEditViewController {
        return CreateWithModel(PFObject(withoutDataWithClassName: "_User", objectId: objectId))
    }
}