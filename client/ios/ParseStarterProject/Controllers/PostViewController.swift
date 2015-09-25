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
    
    override func configureStateMachine() {
        super.configureStateMachine()
        let contentAdultView = ContentAdultView(frame: view.frame)
        contentAdultView.tapGestureRecognizer.addTarget(self, action: Selector("didTapLeftBtn"))
        denyView = contentAdultView

    }
    
    override func allowContent() -> Bool {
        return Post.allowContent(self.object!)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.scrollView.shouldPositionParallaxHeader()
        self.fakeNavigationBar?.alpha   = self.scrollView.parallaxHeader.progress
        self.stickyView?.alpha          = 1 - self.scrollView.parallaxHeader.progress
    }
    
    func setupStickyView() {
        let frame = CGRectMake(0, 0, 320, 20)
        let view = UIView(frame: frame)
        view.backgroundColor = kColorStickyTop
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:
            "userLikedOrUnlikedPost:",             name: kUserUnlikedPost, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:
            "userLikedOrUnlikedPost:",             name: kUserLikedPost, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userFollowOrUnFollowAuthorPost:",     name: kUserFollowingUser, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userFollowOrUnFollowAuthorPost:",     name: kUserUnfollowUser, object: nil)
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
        self.titleView.text         = Post.title(object)
        
        self.authorPicture.image          = kUserPlaceholder
        self.authorPicture.file           = Post.pictureOwner(object)
        
        self.authorPicture.loadInBackground()
        self.authorPicture.cornerEdge()
        
        self.updateLikesCounter()
        self.updateCommentCounter()
        self.updateFollowButton()
        
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
    
    func updateCommentCounter() {
        self.commentsCounter.text   = Post.commentsCounter(self.object!, suffix: "comments".uppercaseString)
    }
    
    func updateLikesCounter() {
        let isLiked = Activity.isLikePost(self.object!)
        self.likesCounter.text = Post.likesCounter(self.object!)

        if isLiked {
            likesCounter.setColor(kColorLikeActive)
        } else {
            likesCounter.setColor(kColorLikeUnactive)
        }
    }
    
    func updateFollowButton() {
        if let author = Post.owner(self.object!) {
            self.followAuthor.hidden = UserModel.isEqualCurrentUser(author)
            self.followAuthor.selectedOnSet(MyCache.sharedCache.followStatusForUser(author))
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
        
        let btnBack:UIButton = UIButton(type: UIButtonType.Custom)
        btnBack.addTarget(self, action: "didTapMoreBtn:", forControlEvents: UIControlEvents.TouchUpInside)
        btnBack.setImage(image, forState: UIControlState.Normal)
        btnBack.imageEdgeInsets = UIEdgeInsets(top: 13, left: 26, bottom: 13, right: 0)
        btnBack.setTitleColor(kColorNavigationBar, forState: UIControlState.Normal)
        btnBack.sizeToFit()
        
        let myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: btnBack)
        navigationItem.rightBarButtonItem = myCustomBackButtonItem
    }
    
    func didTapMoreBtn(sender: AnyObject?) {
        PostHelper.actionSheet(self.object!, controller: self)
    }
    
    func didDoubleTapBookmarkPost() {
        if let header = self.scrollView.parallaxHeader {
            BookmarkMarkView.showInCenterView(header)
            Bookmark.createWith(self.object!)
        }
    }
    
    @IBAction func didTapLikePost() {
        PostHelper.didTapLikePost(self.object!)
    }
    
    @IBAction func didTapFollowAuthor() {
        PostHelper.didTapFollowAuthor(self.object!)
    }
    
    @IBAction func didTapPageAuthor() {
        if let user = Post.owner(self.object!) {
            let controller = ProfileViewController.CreateWithModel(user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func didTapComments() {
        PostHelper.didTapComments(self.object!, controller: self)
    }
    
    dynamic func userLikedOrUnlikedPost(notification: NSNotification) {
        self.updateLikesCounter()
    }
    
    dynamic func userFollowOrUnFollowAuthorPost(notification: NSNotification) {
        self.updateFollowButton()
    }
    
    class func CreateWithModel(model: PFObject) -> PostViewController {
        let post = PostViewController()
        post.object = model
        post.parseClassName = kPostClassKey
        
        return post
    }
    
    class func CreateWithId(objectId: String) -> PostViewController {
        return CreateWithModel(PFObject(withoutDataWithClassName: kPostClassKey, objectId: objectId))
    }
}
