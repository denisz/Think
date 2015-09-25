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
        static let facebook     = "facebook"
        static let twitter      = "twitter"
        static let apn          = "apn"
        static let events       = "events"
        static let sound        = "sound"
        static let vibration    = "vibration"
        static let alert        = "alert"
        static let logout       = "logout"
        static let privacy      = "privacy"
        static let clearCache   = "clearCache"
        static let feedback     = "feedback"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        self.form = XLFormDescriptor()
        
        self.view.backgroundColor       = kColorBackgroundViewController
        self.tableView.backgroundColor  = kColorBackgroundViewController
        self.tableView.separatorStyle   = UITableViewCellSeparatorStyle.None
        
        self.setupSections()
        self.setupNavigationBar()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.customizeNavigationBar()
        self.configureNavigationBarBackBtn(kColorNavigationBar)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)
    }
    
    func setupSections() {
//        self.setupSectionSocial()
        self.setupNotify()
//        self.setupNewMessage()
        self.setupPrivacy()
        self.logoutBtn()        
    }
    
    func setupSectionSocial() {
        let section = XLFormSectionDescriptor()
        var row: XLFormRowDescriptor
        self.form.addFormSection(section)
        
        row = XLFormRowDescriptor(tag: tag.facebook, rowType: XLFormRowDescriptorTypeBooleanSwitch, title: "Facebook".uppercaseString.localized)
        self.stylesRow(row)
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: tag.twitter, rowType: XLFormRowDescriptorTypeBooleanSwitch, title: "Twitter".uppercaseString.localized)
        self.stylesRow(row)
        section.addFormRow(row)
    }
    
    func selectorsByArray(options: [(String, String)]) -> [XLFormOptionsObject]{
        var result = [XLFormOptionsObject]()
        var _: [String: String]
        
        for option in options {
            let obj = XLFormOptionsObject(value: option.0, displayText: option.1)
            result.append(obj)
        }
        
        return result
    }
    
    func setupNotify() {
        let install = PFInstallation.currentInstallation()
        
        let section = XLFormSectionDescriptor()
        var row: XLFormRowDescriptor
        self.form.addFormSection(section)
        
        row = XLFormRowDescriptor(tag: tag.apn, rowType: XLFormRowDescriptorTypeBooleanSwitch, title: "Push notifications".uppercaseString.localized)
        
        if let _ = install[kInstallationUserKey] as? PFObject {
            row.value = true
        }
        
        self.stylesRow(row)
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: tag.events, rowType: XLFormRowDescriptorTypeMultipleSelector, title: "events".uppercaseString.localized)
        row.selectorOptions = self.selectorsByArray([
            (kActivityTypeFollow,       "Followers".localized),
            (kActivityTypeLike,         "Likes".localized),
            (kActivityTypeComment,      "Comments".localized),
        ])
        self.stylesDetailRow(row)
        row.value = install[kInstallationEventsKey] as? [AnyObject]
        self.stylesRow(row)
        section.addFormRow(row)
    }
    
    func stylesDetailRow(row: XLFormRowDescriptor) {
        row.cellConfig.setObject(UIFont(name: "OpenSans-Semibold", size: 13)!, forKey: "detailTextLabel.font")
        row.cellConfig.setObject(UIColor(red:0.33, green:0.39, blue:0.42, alpha:1), forKey: "detailTextLabel.textColor")
    }
    
    func setupPrivacy() {
        let section = XLFormSectionDescriptor()
        var row: XLFormRowDescriptor
        self.form.addFormSection(section)
        
        row = XLFormRowDescriptor(tag: tag.privacy, rowType: XLFormRowDescriptorTypeButton, title: "Privacy".uppercaseString.localized)
        self.styleButtonsRow(row)
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: tag.feedback, rowType: XLFormRowDescriptorTypeButton, title: "Feedback".uppercaseString.localized)
        self.styleButtonsRow(row)
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: tag.clearCache, rowType: XLFormRowDescriptorTypeButton, title: "Clear cache".uppercaseString.localized)
        row.action.formSelector = Selector("didTapClearCache:")
        self.styleButtonsRow(row)
        section.addFormRow(row)
    }
    
    func setupNewMessage() {
        let section = XLFormSectionDescriptor()
        section.title = "New messages".uppercaseString.localized
        var row: XLFormRowDescriptor
        
        self.form.addFormSection(section)

        row = XLFormRowDescriptor(tag: tag.sound, rowType: XLFormRowDescriptorTypeBooleanSwitch, title: "sound".uppercaseString.localized)
        self.stylesRow(row)
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: tag.vibration, rowType: XLFormRowDescriptorTypeBooleanSwitch, title: "Vibration".uppercaseString.localized)
        self.stylesRow(row)
        section.addFormRow(row)
    }
    
    func styleButtonsRow(row: XLFormRowDescriptor) {
        row.cellConfig.setObject(UIColor(red:0.33, green:0.39, blue:0.42, alpha:1), forKey: "textLabel.textColor")
        row.cellConfig.setObject(NSTextAlignment.Left.rawValue, forKey: "textLabel.textAlignment")
        row.cellConfig.setObject(UIFont(name: "OpenSans-Semibold", size: 14)!, forKey: "textLabel.font")
    }
    
    func logoutBtn() {
        let section = XLFormSectionDescriptor()
        let row = XLFormRowDescriptor(tag: tag.logout, rowType: XLFormRowDescriptorTypeButton, title: "logout".uppercaseString.localized)
        
        self.form.addFormSection(section)
        
        row.cellConfig.setObject(UIColor(red:0.07, green:0.62, blue:0.84, alpha:1), forKey: "textLabel.textColor")
        row.cellConfig.setObject(NSTextAlignment.Left.rawValue, forKey: "textLabel.textAlignment")
        row.cellConfig.setObject(UIFont(name: "OpenSans-Semibold", size: 14)!, forKey: "textLabel.font")
        row.action.formSelector = Selector("didTapLogout:")
        section.addFormRow(row)
    }
    
    func didTapLogout(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            Installation.unRegisterPushDevice()
        });
        
        MyCache.sharedCache.clear()
        PFQuery.clearAllCachedResults()
        PFUser.logOut()
    }
    
    func didTapClearCache(sender: AnyObject) {
        MyCache.sharedCache.clear()
    }
    
    func didTapPrivacy(sender: AnyObject) {
        
    }
    
    func performApn(newValue: AnyObject) {
        if let access = newValue as? Bool {
            if access  == true {
                Installation.registerPushDevice()
            } else {
                Installation.unRegisterPushDevice()
            }
        }
    }
    
    func performApnEvents(newValue: AnyObject) {
        let install = PFInstallation.currentInstallation()
        var events = [AnyObject]()
        let values = newValue as! [AnyObject]
        
        for options in values {
            var event: String
            if options is XLFormOptionObject {
                event = options.formValue() as! String
            } else {
                event = options as! String
            }
            
            if !event.isEmpty {
                events.append(event)
            }
        }
        
        install.setObject(events, forKey: kInstallationEventsKey)
        install.saveInBackground()
    }
    
    override func formRowDescriptorValueHasChanged(formRow: XLFormRowDescriptor!, oldValue: AnyObject!, newValue: AnyObject!) {
        
        if let rowTag = formRow.tag {
            switch rowTag {
            case tag.events:
                self.performApnEvents(newValue)
                break
            case tag.apn:
                self.performApn(newValue)
                break
            default:
                print("settings is not perform")
            }
        }
    }
}