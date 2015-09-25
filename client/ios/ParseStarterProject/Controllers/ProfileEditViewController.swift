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
import Bolts
import VGParallaxHeader

@objc(ProfileEditViewController) class ProfileEditViewController: BaseFormViewController {
    var owner: PFObject?
    var headerView: ProfileEditHeaderView?
    
    struct tag {
        static let firstName        = kUserFirstNameKey         //"firstName"
        static let lastName         = kUserLastNameKey          //"lastName"
        static let displayName      = kUserDisplayNameKey       //"displayName"
        static let country          = kUserCountryKey           //"country"
        static let city             = kUserCityKey              //"city"
        static let cover            = kUserProfileCoverKey      //"cover"
        static let picture          = kUserProfilePictureKey    //"picture"
        static let dateOfBirth      = kUserDateOfBirthKey       //"dateOfBirth"
    }
    
    var data: [String: AnyObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.setupHeaderView()
        
        self.data = [String: AnyObject]()//храним данные
        
        self.view.backgroundColor = kColorBackgroundViewController
        self.tableView.backgroundColor = kColorBackgroundViewController
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None

        self.form = XLFormDescriptor()
        
        self.setupSections()
        self.setupNavigationBar()
    }
    
    func setupHeaderView() {
        let header = ProfileEditHeaderView()
        header.delegate = self
        header.objectDidLoad(self.owner!)
        
        self.tableView.setParallaxHeaderView(header, mode: VGParallaxHeaderMode.Fill, height: 240)
        self.headerView = header
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.customizeNavigationBar(.Transparent)
        self.configureNavigationBarBackBtn(UIColor.whiteColor())
        self.configureNavigationBarRightBtn(UIColor.whiteColor())
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        self.tableView.shouldPositionParallaxHeader();
    }
    
    override func configureNavigationBarBackBtn(color: UIColor) {
        let navigationItem  = self.defineNavigationItem()
        
        let attributes = [
            NSForegroundColorAttributeName: color,
            NSFontAttributeName: kFontNavigationItem
        ]
        
        let cancelBarButtonItem = UIBarButtonItem(title: "Cancel".uppercaseString.localized, style: UIBarButtonItemStyle.Plain, target: self, action: "didTapCancel:")
        cancelBarButtonItem.setTitleTextAttributes(attributes, forState: UIControlState.Normal)
        navigationItem.leftBarButtonItem = cancelBarButtonItem
    }
    
    func configureNavigationBarRightBtn(color: UIColor) {
        let navigationItem  = self.defineNavigationItem()
        
        let attributes = [
            NSForegroundColorAttributeName: color,
            NSFontAttributeName: kFontNavigationItem
        ]
        
        let editBarButtonItem = UIBarButtonItem(title: "Done".uppercaseString.localized, style: UIBarButtonItemStyle.Plain, target: self, action: "didTapDone:")
        editBarButtonItem.setTitleTextAttributes(attributes, forState: UIControlState.Normal)
        navigationItem.rightBarButtonItem = editBarButtonItem
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent;
    }
    
    func setupSections() {
        var row: XLFormRowDescriptor
        var section: XLFormSectionDescriptor
        let owner = self.owner!
        
        section = XLFormSectionDescriptor()
        self.form.addFormSection(section)
        
        row = XLFormRowDescriptor(tag: tag.firstName, rowType: XLFormRowDescriptorTypeText, title: "First Name".uppercaseString.localized)
        row.value = owner[kUserFirstNameKey] as? String
        self.stylesRow(row)
        self.stylesTextFieldRow(row)
        section.addFormRow(row)
        

        row = XLFormRowDescriptor(tag: tag.lastName, rowType: XLFormRowDescriptorTypeText, title: "Last Name".uppercaseString.localized)
        row.value = owner[kUserLastNameKey] as? String
        self.stylesRow(row)
        self.stylesTextFieldRow(row)
        section.addFormRow(row)
        
        
        row = XLFormRowDescriptor(tag: tag.displayName, rowType: XLFormRowDescriptorTypeText, title: "Display Name".uppercaseString.localized)
        row.value = UserModel.displayname(owner)
        self.stylesRow(row)
        self.stylesTextFieldRow(row)
        section.addFormRow(row)
        
        
        section = XLFormSectionDescriptor()
        self.form.addFormSection(section)

        row = XLFormRowDescriptor(tag: tag.country, rowType: XLFormRowDescriptorTypeText, title: "Country".uppercaseString.localized)
        row.value = UserModel.country(owner)
        self.stylesRow(row)
        self.stylesTextFieldRow(row)
        section.addFormRow(row)
        

        row = XLFormRowDescriptor(tag: tag.city, rowType: XLFormRowDescriptorTypeText, title: "City".uppercaseString.localized)
        row.value = UserModel.city(owner)
        self.stylesRow(row)
        self.stylesTextFieldRow(row)
        section.addFormRow(row)
        
        
        row = XLFormRowDescriptor(tag: tag.dateOfBirth, rowType: XLFormRowDescriptorTypeDate, title: "Date of birth".uppercaseString.localized)
        row.value = owner[kUserDateOfBirthKey] as? NSDate
        self.stylesRow(row)
        self.stylesDateRow(row)
        section.addFormRow(row)
    }
    
    func stylesDateRow(row: XLFormRowDescriptor) {
        row.cellConfig.setObject(UIFont(name: "OpenSans-Semibold", size: 13)!, forKey: "detailTextLabel.font")
        row.cellConfig.setObject(UIColor(red:0.33, green:0.39, blue:0.42, alpha:1), forKey: "detailTextLabel.textColor")
    }
    
    func stylesTextFieldRow(row: XLFormRowDescriptor) {
        row.cellConfig.setObject(UIFont(name: "OpenSans-Semibold", size: 13)!, forKey: "textField.font")
        row.cellConfig.setObject(UIColor(red:0.33, green:0.39, blue:0.42, alpha:1), forKey: "textField.textColor")
        row.cellConfig.setObject(UIColor(red:0.33, green:0.39, blue:0.42, alpha:1), forKey: "textField.tintColor")
        row.cellConfig.setObject(NSTextAlignment.Right.rawValue, forKey: "textField.textAlignment")
        row.cellConfig.setObject(UITextFieldViewMode.Never.rawValue, forKey: "textField.clearButtonMode")
    }
    
    
    func didTapDone(sender: AnyObject?) {
        
        for (key, value) in self.data! {
            self.owner?.setObject(value, forKey: key)
        }
        
        let overlay = OverlayView.createInView(self.view)
        self.owner!.saveInBackground().continueWithBlock { (task: BFTask!) -> AnyObject! in
            dispatch_async(dispatch_get_main_queue()) {
                overlay.removeFromSuperview()
                self.popViewController()
                NSNotificationCenter.defaultCenter().postNotificationName(kUserUpdateProfile, object: self.owner!)
            }
            
            return task
        }
    }

    func didTapCancel(sender: AnyObject?) {
       popViewController()
    }
    
    override func formRowDescriptorValueHasChanged(formRow: XLFormRowDescriptor!, oldValue: AnyObject!, newValue: AnyObject!) {
        
        if let tag = formRow.tag {
            self.data![tag] = newValue
        }
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
        let profile = ProfileEditViewController()
        profile.owner = model
        
        return profile
    }
}

extension ProfileEditViewController: ProfileEditHeaderViewDelegate {
    func profileView(view: ProfileEditHeaderView, didTapChangeCover button: UIButton) {
        SelectImageHelper.selectAndUploadFile(self, sourceView: button, scenario: .CoverProfile)
    }
    
    func profileView (view: ProfileEditHeaderView, didTapChangePicture button: UIButton) {
        SelectImageHelper.selectAndUploadFile(self, sourceView: button, scenario: .PictureProfile)
    }
}

extension ProfileEditViewController {
    func performLoadedImage(image: UIImage) {
        if let scenario = SelectImageHelper.lastPresentScenario {
            let user    = PFUser.currentUser()
            let userID  = user!.objectId ?? "unknown"
            let date    = NSDate.timeIntervalSinceReferenceDate()
            
            SelectImageHelper.uploadImage(image,
                imageName: "\(userID)_\(date)")
                { (file: PFFile, error: NSError?) in
                    
                    if (error == nil) {
                        switch(scenario) {
                        case .PictureProfile:
                            self.data![tag.picture] = file
                            self.headerView?.updatePicture(file)
                            break
                        case .CoverProfile:
                            self.data![tag.cover] = file
                            self.headerView?.updateCover(file)
                            break
                        default:
                            print("scenario is invalid")
                        }
                    }
            }
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            cropImageWithCropViewController(image)
        }
    }
}


extension ProfileEditViewController {
    override func cropViewController(image: UIImage) {
        self.performLoadedImage(image)
    }
}