//
//  SettingsViewController.swift
//  Think
//
//  Created by denis zaytcev on 8/9/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import UIKit
import XLForm
import Parse
import ParseUI


class SettingsViewController: BaseFormViewController {
    struct tag {
        static let facebook = "facebook"
        static let twitter = "twitter"
        static let apn = "apn"
        static let events = "events"
        static let sound = "sound"
        static let vibration = "vibration"
        static let alert = "alert"
        static let logout = "logout"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        self.form = XLFormDescriptor()
        
        
        self.view.backgroundColor = kColorBackgroundViewController
        
        self.tableView.backgroundColor = kColorBackgroundViewController
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        self.setupSectionSocial()
        self.setupNotify()
        self.setupNewMessage()
        self.logoutBtn()
        
        self.setupNavigationBar()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.customizeNavigationBar()
        self.configureNavigationBarBackBtn(kColorNavigationBar)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
    }
    
    func setupSectionSocial() {
        var section = XLFormSectionDescriptor()
        var row: XLFormRowDescriptor
        self.form.addFormSection(section)
        
        row = XLFormRowDescriptor(tag: tag.facebook, rowType: XLFormRowDescriptorTypeBooleanSwitch, title: "Facebook".uppercaseString)
        self.stylesRow(row)
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: tag.twitter, rowType: XLFormRowDescriptorTypeBooleanSwitch, title: "Twitter".uppercaseString)
        self.stylesRow(row)
        section.addFormRow(row)
    }
    
    func setupNotify() {
        var section = XLFormSectionDescriptor()
        var row: XLFormRowDescriptor
        self.form.addFormSection(section)
        
        row = XLFormRowDescriptor(tag: tag.apn, rowType: XLFormRowDescriptorTypeBooleanSwitch, title: "Push notifications".uppercaseString)
        self.stylesRow(row)
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: tag.events, rowType: XLFormRowDescriptorTypeSelectorActionSheet, title: "events".uppercaseString)
        row.selectorOptions = ["Followers", "Messages"]
        self.stylesRow(row)
        section.addFormRow(row)
    }
    
    func setupNewMessage() {
        var section = XLFormSectionDescriptor()
        section.title = "New messages".uppercaseString
        var row: XLFormRowDescriptor
        
        self.form.addFormSection(section)

        row = XLFormRowDescriptor(tag: tag.sound, rowType: XLFormRowDescriptorTypeBooleanSwitch, title: "sound".uppercaseString)
        self.stylesRow(row)
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: tag.vibration, rowType: XLFormRowDescriptorTypeBooleanSwitch, title: "Vibration".uppercaseString)
        self.stylesRow(row)
        section.addFormRow(row)
    }
    
    func logoutBtn() {
        var section = XLFormSectionDescriptor()
        var row = XLFormRowDescriptor(tag: tag.logout, rowType: XLFormRowDescriptorTypeButton, title: "logout".uppercaseString)
        
        self.form.addFormSection(section)
        
        row.cellConfig.setObject(UIColor(red:0.07, green:0.62, blue:0.84, alpha:1), forKey: "textLabel.textColor")
        row.cellConfig.setObject(NSTextAlignment.Left.rawValue, forKey: "textLabel.textAlignment")
        row.cellConfig.setObject(UIFont(name: "OpenSans-Semibold", size: 14)!, forKey: "textLabel.font")
        row.action.formSelector = Selector("didTapLogout:")
        section.addFormRow(row)
    }
    
    func didTapLogout(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            let install = PFInstallation.currentInstallation()
            install.removeObjectForKey(kInstallationUserKey)
            install.saveInBackground()
        });
        PFUser.logOut()
    }
}