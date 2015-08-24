//
//  NewPost.swift
//  Think
//
//  Created by denis zaytcev on 8/10/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import ParseUI
import UIKit
import Bolts

@objc(NewPostViewController) class NewPostViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBottomLayoutContraint: NSLayoutConstraint!
    @IBOutlet weak var toolbarBottomLayoutContraint: NSLayoutConstraint!
    @IBOutlet weak var toolbar: ToolbarNewPostView!

    var blocks: [PostBlock]?
    var currentEditingBlock: PostBlock?
    var object: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.blocks = [PostBlock]()
        self.title  = "New post"
        
        self.object = Post.createWith()
        
        self.setupTableView()
        self.setupNavigationBar()
        self.setupToolbar()

        //сразу добавляем блок с заголовком и один блок с текстом и ковер
        self.blocks?.append(PostBlock(type: PostBlockType.Cover))
        self.blocks?.append(PostBlock(type: PostBlockType.Title))
        self.blocks?.append(PostBlock(type: PostBlockType.Text))
        
        self.tableView.reloadData()
        self.setupKeyboard(false)
    }
    
    deinit {
        self.unsetupKeyboard()
    }

    override func updateConstraintKeyboard(hide: Bool, minY: CGFloat, maxY: CGFloat) {
        self.tableViewBottomLayoutContraint.constant    = maxY - minY + 60
        self.toolbarBottomLayoutContraint.constant      = maxY - minY
    }
    
    func setupToolbar() {
        self.toolbar.delegate = self
        self.toolbar.parentController = self
    }
    
    func setupTableView() {
        self.tableView.registerNib(UINib(nibName: kReusableTitlePostViewCell,   bundle: nil), forCellReuseIdentifier: kReusableTitlePostViewCell)
        self.tableView.registerNib(UINib(nibName: kReusableTextPostViewCell,    bundle: nil), forCellReuseIdentifier: kReusableTextPostViewCell)
        self.tableView.registerNib(UINib(nibName: kReusablePicturePostViewCell, bundle: nil), forCellReuseIdentifier: kReusablePicturePostViewCell)
        self.tableView.registerNib(UINib(nibName: kReusableCoverPostViewCell,   bundle: nil), forCellReuseIdentifier: kReusableCoverPostViewCell)
        
        self.tableView.estimatedRowHeight = 100;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.configureNavigationBarRightBtn(kColorNavigationBar)
        self.configureNavigationBarBackBtn(kColorNavigationBar)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
    }
    
    override var imageLeftBtn: String {
        return kImageNamedForCloseBtn
    }

    func configureNavigationBarRightBtn(color: UIColor) {
        let navigationItem = self.defineNavigationItem()
        
        var image = UIImage(named: "ic_next") as UIImage!
        image = image.imageWithColor(color)
        
        var btnBack:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        btnBack.addTarget(self, action: "didTapNextBtn:", forControlEvents: UIControlEvents.TouchUpInside)
        btnBack.setImage(image, forState: UIControlState.Normal)
        btnBack.imageEdgeInsets = UIEdgeInsets(top: 9, left: 18, bottom: 9, right: 0)
        btnBack.setTitleColor(color, forState: UIControlState.Normal)
        btnBack.sizeToFit()
        
        let myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: btnBack)
        navigationItem.rightBarButtonItem  = myCustomBackButtonItem
    }
    
    func didTapNextBtn(sender: AnyObject?) {
        self.hideKeyboard()
        let overlay = OverlayView.createInView(self.view)
        self.preparePost()
        
        self.object?.saveInBackground().continueWithBlock({ (task: BFTask!) -> AnyObject! in
            dispatch_async(dispatch_get_main_queue()) {
                overlay.removeFromSuperview()
            }
            
            if (task.error != nil) {
                let alertView = UIAlertView(
                   title: "Error save your post",
                   message: "Post error save",
                   delegate: nil,
                   cancelButtonTitle: "Not Now",
                   otherButtonTitles: "OK"
                 )
                dispatch_async(dispatch_get_main_queue()) {
                    alertView.show()
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    let controller = SettingsPostViewController()
                    controller.object = self.object!
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
            
            return nil
        })
        
    }
    
    func blockByType(type: PostBlockType) -> [PostBlock]{
        return self.blocks!.filter{ $0.type == type }
    }
    
    func titlePost() -> String{
        return self.blockByType(PostBlockType.Title)[0].toObject()[kPostBlockTextKey]!
    }
    
    func preparePost(){
        var result = [String]()
        
        let title           = self.titlePost()
        let contentObject   = self.blockByType(PostBlockType.Text).map({ $0.toObject() })
//        let content         = JSONStringify(contentObject)
        
        self.object?.setObject(contentObject, forKey: kPostContentObjKey)
        self.object?.setObject(title,   forKey: kPostTitleKey)
    }
    
    override func didTapLeftBtn(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle  {
        return UIStatusBarStyle.Default
    }
}

extension NewPostViewController: UITableViewDelegate {
    func insertNewBlockAfterBlock(block: PostBlock, type: PostBlockType) {
        var index = self.blocks?.find{$0 == block}
        
        if let idx = index {
            let newBlock = PostBlock(type: type)
            self.blocks!.insert(newBlock, atIndex: idx)
            let indexPath = NSIndexPath(forRow: idx, inSection: 0)
            
            self.tableView.beginUpdates()
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            self.tableView.endUpdates()
        } else {
            self.appendBlock(type)
        }
    }
    
    func appendBlock(type: PostBlockType) {
        let block = PostBlock(type: type)
        self.blocks!.append(block)
        let index = self.blocks?.find{$0 == block}
        let indexPath = NSIndexPath(forRow: index!, inSection: 0)
        
        self.tableView.beginUpdates()
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        self.tableView.endUpdates()
        
//        if type == PostBlockType.Text {
//            if let cell = self.cellByBlock(block)  {
//                let textCell = cell as! TextBlockPostViewCell
//                textCell.textView.becomeFirstResponder()
//            }
//        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
}

extension NewPostViewController: UITableViewDataSource {
    func getIndexPathForTitle () -> NSIndexPath {
        return NSIndexPath(forRow: 0, inSection: 0)
    }
    
    func parseReuseIdentifierByType(type: PostBlockType) -> String {
        switch(type) {
        case .Text:
            return kReusableTextPostViewCell
        case .Picture:
            return kReusablePicturePostViewCell
        case .Title:
            return kReusableTitlePostViewCell
        case .Cover:
            return kReusableCoverPostViewCell
        default:
            return ""
        }
    }
    
    func blockByIndexPath(indexPath: NSIndexPath) -> PostBlock {
        return self.blocks![indexPath.row]
    }
    
    func cellByBlock(block: PostBlock) -> UITableViewCell? {
        let index = self.blocks?.find({$0 == block })
        if let idx = index {
            let indexPath = NSIndexPath(forRow: idx, inSection: 0)
            return self.tableView.cellForRowAtIndexPath(indexPath)
        }
        
        return nil
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.blocks!.count
    }
    
    func tableView(tableView: UITableView, cellForTitleAtIndexPath indexPath: NSIndexPath, block: PostBlock) -> UITableViewCell  {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(kReusableTitlePostViewCell) as? TitlePostViewCell
        
        cell!.prepareView(block)
        return cell!
    }
    
    func tableView(tableView: UITableView, cellForBlockAtIndexPath indexPath: NSIndexPath, block: PostBlock) -> UITableViewCell  {
        
        let cellIndentifier = self.parseReuseIdentifierByType(block.type)
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIndentifier, forIndexPath: indexPath) as! BlockPostViewCell
        
        cell.clearView()
        cell.parentViewController = self
        cell.delegate = self
        cell.prepareView(block)
        
        return cell
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let block = blockByIndexPath(indexPath)
        
        if block.type == PostBlockType.Title {
            return self.tableView(tableView, cellForTitleAtIndexPath: indexPath, block: block)
        }
        
        return self.tableView(tableView, cellForBlockAtIndexPath: indexPath, block: block)
    }

}

extension NewPostViewController: BlockPostViewCellDelegate {
    func block(cell: UITableViewCell, didTapNextBlock block: PostBlock) {
        self.insertNewBlockAfterBlock(block, type: PostBlockType.Text)
    }
    
    func block(cell: UITableViewCell, shouldActiveBlock block: PostBlock) {
        self.currentEditingBlock = block
    }
}

extension NewPostViewController: ToolbarNewPostViewDelegate {
    func toolbar(view: ToolbarNewPostView, didTapNewBlock sender: UIView) {
        self.appendBlock(PostBlockType.Text)
    }
    
    func toolbar(view: ToolbarNewPostView, didTapHideKeyboard sender: UIView) {
        self.hideKeyboard()
    }
    
    func toolbar(view: ToolbarNewPostView, didTapChangeStyle sender: UIView) {
        if let block = self.currentEditingBlock {
            block.style = PostBlockStyle.Gray
        }
    }
}