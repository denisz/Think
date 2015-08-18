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

enum PostBlockType: Int {
    case Text
    case Title
    case Picture
    case Cover
    case Unknown
}

class PostBlock: NSObject {
    var type: PostBlockType
    var content: String = ""
    var picture: PFFile?
    var backgroundColor: UIColor?
    var textColor: UIColor?
    
    init(type: PostBlockType) {
        self.type = type
    }
}

let kReusableTitlePostViewCell      = "TitlePostViewCell"
let kReusableTextPostViewCell       = "TextPostViewCell"
let kReusablePicturePostViewCell    = "PicturePostViewCell"
let kReusableCoverPostViewCell      = "CoverPostViewCell"

@objc(NewPostViewController) class NewPostViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBottomLayoutContraint: NSLayoutConstraint!
    @IBOutlet weak var toolbarBottomLayoutContraint: NSLayoutConstraint!
    @IBOutlet weak var toolbar: ToolbarNewPostView!

    
    var blocks: [PostBlock]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.blocks = [PostBlock]()
        
        self.title = "New post"

        self.setupTableView()
        self.setupNavigationBar()
        self.setupToolbar()

        //сразу добавляем блок с заголовком и один блок с текстом
        self.blocks?.append(PostBlock(type: PostBlockType.Cover))
        self.blocks?.append(PostBlock(type: PostBlockType.Title))
        self.blocks?.append(PostBlock(type: PostBlockType.Text))
        
        self.tableView.reloadData()
        self.setupKeyboard()
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
        let controller = SettingsPostViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func getReadyPost() -> [String]{
        var result = [String]()
        
        return result
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
            let newBlock = PostBlock(type: PostBlockType.Unknown)
            self.blocks!.insert(newBlock, atIndex: idx)
        } else {
            self.blocks!.append(PostBlock(type: PostBlockType.Unknown))
        }
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
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIndentifier) as? BlockPostViewCell
        
        cell!.parentViewController = self
        cell!.delegate = self
        cell!.prepareView(block)
        
        return cell!
    }
    
    func blockByIndexPath(indexPath: NSIndexPath) -> PostBlock {
        return self.blocks![indexPath.row]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var block = blockByIndexPath(indexPath)
        
        if block.type == PostBlockType.Title {
            return self.tableView(tableView, cellForTitleAtIndexPath: indexPath, block: block)
        }
        
        return self.tableView(tableView, cellForBlockAtIndexPath: indexPath, block: block)
    }

}

extension NewPostViewController: BlockPostViewCellDelegate {
    func block(cell: UITableViewCell, didTapNextBlock block: PostBlock) {
        self.insertNewBlockAfterBlock(block, type: PostBlockType.Text)
        //сделать анимацию
        self.tableView.reloadData()
    }
}

extension NewPostViewController: ToolbarNewPostViewDelegate {
    func toolbar(view: ToolbarNewPostView, didTapNewBlock sender: UIButton) {
        
    }
}