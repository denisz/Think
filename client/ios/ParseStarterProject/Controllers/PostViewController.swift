//
//  PostViewController.swift
//  Think
//
//  Created by denis zaytcev on 8/10/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import ParseUI
import UIKit
import VGParallaxHeader

@objc(PostViewController) class PostViewController: BaseQueryViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var likesCounter: LabelViewWithIcon!
    @IBOutlet weak var commentsCounter: UILabel!
    @IBOutlet weak var followAuthor: UIButtonRoundedBorder!
    @IBOutlet weak var contentView: PostContentView!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var dateView: UILabel!
    @IBOutlet weak var tagsView: UILabel!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var authorPicture: PFImageView!
    @IBOutlet weak var commentsTableView: CommentsTableView!
    
    var headerView: PostViewHeaderView?
    var stickyView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.setupScrollView()
        self.setupNavigationBar()
        self.setupStickyView()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.scrollView.shouldPositionParallaxHeader()
        self.fakeNavigationBar?.alpha   = self.scrollView.parallaxHeader.progress
        self.stickyView?.alpha          = 1 - self.scrollView.parallaxHeader.progress
    }
    
    func setupStickyView() {
        let frame = CGRectMake(0, 0, 320, 20)
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor(red:0.33, green:0.39, blue:0.42, alpha:1)
        view.alpha = 0
        
        self.view.addSubview(view)
        self.stickyView = view
        
        BaseUIView.constraintToTop(view, size: frame.size, offset: 0)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.customizeNavigationBar(.Transparent)
        self.configureNavigationBarBackBtn(UIColor.whiteColor())
        self.configureNavigationBarRightBtn(UIColor.whiteColor())
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userLikedOrUnlikedPost:", name: kUserUnlikedPost, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userLikedOrUnlikedPost:", name: kUserLikedPost, object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userFollowOrUnFollowAuthorPost:", name: kUserFollowingUser, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userFollowOrUnFollowAuthorPost:", name: kUserUnfollowUser, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kUserUnlikedPost,   object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kUserLikedPost,     object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kUserFollowingUser, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kUserUnfollowUser,  object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
    }
    
    override func objectDidLoad(object: PFObject) {
        super.objectDidLoad(object)
        
        self.authorName.text        = Post.usernameOwner(object)
        self.likesCounter.text      = Post.likesCounter(object)
        self.commentsCounter.text   = Post.commentsCounter(object, suffix: "comments".uppercaseString)
        self.titleView.text         = Post.title(object)
        
        self.authorPicture.image          = kUserPlaceholder
        self.authorPicture.file           = Post.pictureOwner(object)
        
        self.authorPicture.loadInBackground()
        self.authorPicture.cornerEdge()
        
        self.tagsView.text = Post.tagsString(object)
        
        self.commentsTableView.object = self.object
        self.commentsTableView.loadObjects()
        
        self.headerView?.objectDidLoad(object)
        self.contentView.updateObject(object)
    }
    
    override func queryForView() -> PFQuery {
        let query = PFQuery(className: self.parseClassName!)
        query.includeKey(kPostOwnerKey)
        return query;
    }
    
    func updateColorAndCountLikes(like: Bool) {
        self.likesCounter.text = Post.likesCounter(self.object!)

        if like {
            likesCounter.setColor(UIColor(red:0, green:0.64, blue:0.85, alpha:1))
        } else {
            likesCounter.setColor(UIColor(red:0.26, green:0.26, blue:0.26, alpha:1))
        }
    }
    
    func setupScrollView() {
        self.headerView = PostViewHeaderView()
        
        self.scrollView.delegate = self
        self.scrollView.setParallaxHeaderView(self.headerView!, mode: VGParallaxHeaderMode.Fill, height: 245)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: "didDoubleTapBookmarkPost")
        doubleTapGesture.numberOfTapsRequired = 2
        self.headerView!.addGestureRecognizer(doubleTapGesture)
    }
    
    func configureNavigationBarRightBtn(color: UIColor) {
        let navigationItem = self.defineNavigationItem()
        
        var image = UIImage(named: "ic_more2") as UIImage!
        image = image.imageWithColor(color)
        
        let btnBack:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        btnBack.addTarget(self, action: "didTapMoreBtn:", forControlEvents: UIControlEvents.TouchUpInside)
        btnBack.setImage(image, forState: UIControlState.Normal)
        btnBack.imageEdgeInsets = UIEdgeInsets(top: 13, left: 26, bottom: 13, right: 0)
        btnBack.setTitleColor(kColorNavigationBar, forState: UIControlState.Normal)
        btnBack.sizeToFit()
        
        let myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: btnBack)
        navigationItem.rightBarButtonItem = myCustomBackButtonItem
    }
    
    func didTapMoreBtn(sender: AnyObject?) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)

        
        let reportAction = UIAlertAction(title: "Report".localized, style: .Default) { (action) -> Void in
            self.didTapReport()
        }
        
        let shareAction = UIAlertAction(title: "Share via socials".localized, style: .Default) { (action) -> Void in
            self.didTapShare()
        }
        
        let bookmarkAction = UIAlertAction(title: "Save to read later".localized, style: .Default) { (action) -> Void in
            self.didTapBookmarkPost()
        }
        
        let raiseAction = UIAlertAction(title: "Raise post public".localized, style: .Default) { (action) -> Void in
            self.didTapRaisePost()
        }
        
        let followAction = UIAlertAction(title: "Follow author".localized, style: .Default) { (action) -> Void in
            self.didTapFollowAuthor()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .Cancel, handler: nil)
        
        actionSheet.addAction(shareAction)

        if Post.determineCurrentUserAuthor(self.object!) {
            actionSheet.addAction(raiseAction)
        } else {
            actionSheet.addAction(bookmarkAction)
            actionSheet.addAction(reportAction)
            actionSheet.addAction(followAction)
        }

        actionSheet.addAction(cancelAction)
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func didDoubleTapBookmarkPost() {
        if let header = self.scrollView.parallaxHeader {
            BookmarkMarkView.showInCenterView(header)
            Bookmark.createWith(self.object!)
        }
    }
    
    func didTapBookmarkPost() {
        Bookmark.createWith(self.object!)
    }
    
    func didTapRaisePost() {
        Post.raisePost(self.object!)
    }
    
    func didTapReport() {
    }
    
    @IBAction func didTapLikePost() {
        if let object = self.object {
            Activity.handlerLikePost(object)
        }
    }
    
    @IBAction func didTapFollowAuthor() {
        if let object = self.object {
            let owner = object[kPostOwnerKey] as! PFObject
            Activity.handlerFollowUser(owner)
        }
    }
    
    @IBAction func didTapComments() {
        let comments = CommentsViewController.CreateWithModel(self.object!)
        self.navigationController?.pushViewController(comments, animated: true)
    }
    
    func didTapShare() {
        let post = self.object!
        let textToShare = Post.stringForShare(post)
        let activityVC = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    dynamic func userLikedOrUnlikedPost(notification: NSNotification) {
        self.updateColorAndCountLikes(Activity.isLikePost(self.object!))
    }
    
    dynamic func userFollowOrUnFollowAuthorPost(notification: NSNotification) {
        followAuthor.selectedOnSet(true)
    }
    
    class func CreateWithModel(model: PFObject) -> PostViewController {
        var post = PostViewController()
        post.object = model
        post.parseClassName = kPostClassKey
        
        return post
    }
    
    class func CreateWithId(objectId: String) -> PostViewController {
        return CreateWithModel(PFObject(withoutDataWithClassName: "Post", objectId: objectId))
    }
}
