//
//  RRTagController.swift
//  RRTagController
//
//  Created by Remi Robert on 20/02/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

import UIKit
import XLForm

struct Tag {
    var _isSelected: Bool
    var isLocked: Bool
    var textContent: String
}

let colorUnselectedTag = UIColor.whiteColor()
let colorSelectedTag = UIColor(red:0.26, green:0.26, blue:0.26, alpha:1)

let colorTextUnSelectedTag = UIColor(red:0.33, green:0.33, blue:0.35, alpha:1)
let colorTextSelectedTag = UIColor.whiteColor()

class RRTagController: XLFormViewController, XLFormRowDescriptorViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    internal var rowDescriptor: XLFormRowDescriptor?
    
    private var tags: Array<Tag>!
    private var navigationBarItem: UINavigationItem!
    private var leftButton: UIBarButtonItem!
    private var rigthButton: UIBarButtonItem!
    private var _totalTagsSelected = 0
    private let addTagView = RRAddTagView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 70))
    private var heightKeyboard: CGFloat = 0
    
    var blockFinih: ((selectedTags: Array<Tag>, unSelectedTags: Array<Tag>) -> ())!
    var blockCancel: (() -> ())!

    var totalTagsSelected: Int {
        get {
            return self._totalTagsSelected
        }
        set {
            if newValue == 0 {
                self._totalTagsSelected = 0
                return
            }
            self._totalTagsSelected += newValue
            self._totalTagsSelected = (self._totalTagsSelected < 0) ? 0 : self._totalTagsSelected
            self.navigationBarItem = UINavigationItem(title: "Tags".localized)
            self.navigationBarItem.leftBarButtonItem = self.leftButton
            if (self._totalTagsSelected == 0) {
                self.navigationBarItem.rightBarButtonItem = nil
            }
            else {
                self.navigationBarItem.rightBarButtonItem = self.rigthButton
            }
            self.navigationBar.pushNavigationItem(self.navigationBarItem, animated: false)
        }
    }
    
    lazy var collectionTag: UICollectionView = {
        let layoutCollectionView = UICollectionViewFlowLayout()
        layoutCollectionView.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layoutCollectionView.itemSize = CGSizeMake(90, 20)
        layoutCollectionView.minimumLineSpacing = 10
        layoutCollectionView.minimumInteritemSpacing = 5
        let collectionTag = UICollectionView(frame: self.view.frame, collectionViewLayout: layoutCollectionView)
        collectionTag.contentInset = UIEdgeInsets(top: 84, left: 0, bottom: 20, right: 0)
        collectionTag.delegate = self
        collectionTag.dataSource = self
        collectionTag.backgroundColor = UIColor.whiteColor()
        collectionTag.registerClass(RRTagCollectionViewCell.self, forCellWithReuseIdentifier: RRTagCollectionViewCellIdentifier)
        return collectionTag
    }()
    
    lazy var addNewTagCell: RRTagCollectionViewCell = {
        let addNewTagCell = RRTagCollectionViewCell()
        addNewTagCell.contentView.addSubview(addNewTagCell.textContent)
        addNewTagCell.textContent.text = "+"
        addNewTagCell.frame.size = CGSizeMake(40, 40)
        addNewTagCell.backgroundColor = UIColor.grayColor()
        return addNewTagCell
    }()
    
    lazy var controlPanelEdition: UIView = {
        let controlPanel = UIView(frame: CGRectMake(0, UIScreen.mainScreen().bounds.size.height + 50, UIScreen.mainScreen().bounds.size.width, 50))
        controlPanel.backgroundColor = UIColor.whiteColor()
        
        var attributes = [
            NSForegroundColorAttributeName: UIColor(red:0.26, green:0.26, blue:0.26, alpha:1),
            NSFontAttributeName: UIFont(name: "OpenSans-Semibold", size: 15)!
        ]
        
        let buttonCancel = UIButton(frame: CGRectMake(10, 10, 100, 30))
        let attributesCancel = NSAttributedString(string: "Cancel".localized, attributes: attributes)
        buttonCancel.setAttributedTitle(attributesCancel, forState: UIControlState.Normal)
        
        buttonCancel.backgroundColor = UIColor.whiteColor()
        buttonCancel.addTarget(self, action: "cancelEditTag", forControlEvents: UIControlEvents.TouchUpInside)

        let buttonAccept = UIButton(frame: CGRectMake(UIScreen.mainScreen().bounds.size.width - 110, 10, 100, 30))
        let attributesAccept = NSAttributedString(string: "Create".localized, attributes: attributes)
        buttonAccept.setAttributedTitle(attributesAccept, forState: UIControlState.Normal)
        
        buttonAccept.backgroundColor = UIColor.whiteColor()
        buttonAccept.addTarget(self, action: "createNewTag", forControlEvents: UIControlEvents.TouchUpInside)
        
        controlPanel.addSubview(buttonCancel)
        controlPanel.addSubview(buttonAccept)
        return controlPanel
    }()
    
    lazy var navigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 64))
        
        self.navigationBarItem = UINavigationItem(title: "Tags".localized)
        self.navigationBarItem.leftBarButtonItem = self.leftButton
        
        navigationBar.pushNavigationItem(self.navigationBarItem, animated: true)
        navigationBar.tintColor = colorSelectedTag
        return navigationBar
    }()
    
    func cancelTagController() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func finishTagController() {
        var selected = [String]()
        
        for currentTag in tags {
            if currentTag._isSelected {
                selected.append(currentTag.textContent)
            }
        }
        
        self.rowDescriptor?.value = selected
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func cancelEditTag() {
        self.view.endEditing(true)
        UIView.animateWithDuration(0.375, delay: 0, options: UIViewAnimationOptions.allZeros, animations: { () -> Void in
            self.addTagView.frame.origin.y = 0
            self.controlPanelEdition.frame.origin.y = UIScreen.mainScreen().bounds.size.height
            self.collectionTag.alpha = 1
            }) { (anim:Bool) -> Void in
            
        }
    }
    
    func createNewTag() {
        let spaceSet = NSCharacterSet.whitespaceCharacterSet()
        let contentTag = addTagView.textEdit.text.stringByTrimmingCharactersInSet(spaceSet)
        if strlen(contentTag) > 0 {
            let newTag = Tag(_isSelected: false, isLocked: false, textContent: contentTag)
            tags.insert(newTag, atIndex: tags.count)
            collectionTag.reloadData()            
        }
        cancelEditTag()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            if indexPath.row < tags.count {
                return RRTagCollectionViewCell.contentHeight(tags[indexPath.row].textContent)
            }
            return CGSizeMake(40, 40)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedCell: RRTagCollectionViewCell? = collectionView.cellForItemAtIndexPath(indexPath) as? RRTagCollectionViewCell
        
        if indexPath.row < tags.count {
            var currentTag = tags[indexPath.row]
            
            if tags[indexPath.row]._isSelected == false {
                tags[indexPath.row]._isSelected = true
                selectedCell?.animateSelection(tags[indexPath.row]._isSelected)
                totalTagsSelected = 1
            }
            else {
                tags[indexPath.row]._isSelected = false
                selectedCell?.animateSelection(tags[indexPath.row]._isSelected)
                totalTagsSelected = -1
            }
        }
        else {
            addTagView.textEdit.text = nil
            UIView.animateWithDuration(0.375, delay: 0,
                options: UIViewAnimationOptions.allZeros, animations: { () -> Void in
                self.collectionTag.alpha = 0.3
                self.addTagView.frame.origin.y = 64
                }, completion: { (anim: Bool) -> Void in
                    self.addTagView.textEdit.becomeFirstResponder()
                    println("")
            })
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: RRTagCollectionViewCell? = collectionView.dequeueReusableCellWithReuseIdentifier(RRTagCollectionViewCellIdentifier, forIndexPath: indexPath) as? RRTagCollectionViewCell
        
        if indexPath.row < tags.count {
            let currentTag = tags[indexPath.row]
            cell?.initContent(currentTag)
        }
        else {
            cell?.initAddButtonContent()
        }
        return cell!
    }
    
    func keyboardWillShow(notification: NSNotification) {
        // TODO: change value
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                heightKeyboard = keyboardSize.height
                UIView.animateWithDuration(0.375, delay: 0,
                    options: UIViewAnimationOptions.allZeros, animations: { () -> Void in
                    self.controlPanelEdition.frame.origin.y = self.view.frame.size.height - self.heightKeyboard - 50
                }, completion: nil)
            }
        }
        else {
            heightKeyboard = 0
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        heightKeyboard = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        var attributes = [
            NSForegroundColorAttributeName: UIColor(red:0.26, green:0.26, blue:0.26, alpha:1),
            NSFontAttributeName: kFontNavigationBarTitle
        ]
        
        leftButton = UIBarButtonItem(title: "Cancel".localized, style: UIBarButtonItemStyle.Plain, target: self, action: "cancelTagController")
        leftButton.setTitleTextAttributes(attributes, forState: UIControlState.Normal)
        
        rigthButton = UIBarButtonItem(title: "OK".localized, style: UIBarButtonItemStyle.Done, target: self, action: "finishTagController")
        rigthButton.setTitleTextAttributes(attributes, forState: UIControlState.Normal)
        
        self.tags = [Tag]()
        
        if let value: AnyObject = rowDescriptor!.value {

        }
        
        totalTagsSelected = 0
        self.view.addSubview(collectionTag)
        self.view.addSubview(addTagView)
        self.view.addSubview(controlPanelEdition)
        self.view.addSubview(navigationBar)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil)
    }
    
    class func displayTagController(#parentController: UIViewController, tagsString: [String]?,
        blockFinish: (selectedTags: Array<Tag>, unSelectedTags: Array<Tag>)->(), blockCancel: ()->()) {
        let tagController = RRTagController()
            tagController.tags = Array()
            if tagsString != nil {
                for currentTag in tagsString! {
                    tagController.tags.append(Tag(_isSelected: false, isLocked: false, textContent: currentTag))
                }
            }
            tagController.blockCancel = blockCancel
            tagController.blockFinih = blockFinish
            parentController.presentViewController(tagController, animated: true, completion: nil)
    }

    class func displayTagController(#parentController: UIViewController, tags: [Tag]?,
        blockFinish: (selectedTags: Array<Tag>, unSelectedTags: Array<Tag>)->(), blockCancel: ()->()) {
            let tagController = RRTagController()
            tagController.tags = tags
            tagController.blockCancel = blockCancel
            tagController.blockFinih = blockFinish
            parentController.presentViewController(tagController, animated: true, completion: nil)
    }
    
}
