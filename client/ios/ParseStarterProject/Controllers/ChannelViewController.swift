//
//  CommentsViewController
//  AsyncMessagesViewController
//
//  Created by Huy Nguyen on 17/02/15.
//  Copyright (c) 2015 Huy Nguyen. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import AsyncDisplayKit
import LoremIpsum

@objc(ChannelViewController) class ChannelViewController: BaseMessageCollectionView {
    var owner: PFObject?
    
    private let users: [UserMessage]
    private var currentUser: UserMessage? {
        return users.filter({$0.ID == self.dataSource.currentUserID()}).first
    }
    
    init() {
        let avatarImageSize = CGSizeMake(kAMMessageCellNodeAvatarImageSize, kAMMessageCellNodeAvatarImageSize)
        users = (0..<5).map() {
            let avatarURL = LoremIpsum.URLForPlaceholderImageFromService(.LoremPixel, withSize: avatarImageSize)
            return UserMessage(ID: "user-\($0)", name: LoremIpsum.name(), avatarURL: avatarURL)
        }
        
        let dataSource = DefaultAsyncMessagesCollectionViewDataSource(currentUserID: users[0].ID)
        super.init(dataSource: dataSource)
        
        collectionView.asyncDelegate = self
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Lise Carter"
        
        self.customizeTextField()
        self.setupNavigationBar()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.customizeNavigationBar()
        self.configureNavigationBarBackBtn(kColorNavigationBar)
        self.configureNavigationBarRightBtn(kColorNavigationBar)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default;
    }
    
    func configureNavigationBarRightBtn(color: UIColor) {
        let navigationItem = self.defineNavigationItem()
        let image = UIImage(named: "ava_profile")
        
        let btnBack = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        btnBack.addTarget(self, action: "didTapNewPostBtn:", forControlEvents: UIControlEvents.TouchUpInside)
        btnBack.setImage(image, forState: UIControlState.Normal)
        btnBack.imageEdgeInsets = UIEdgeInsets(top: -4, left: -4, bottom: -4, right: -4)
        btnBack.setTitleColor(kColorNavigationBar, forState: UIControlState.Normal)
        btnBack.frame = CGRectMake(0, 0, 36, 36)
        btnBack.cornerEdge()
        
        let bar = UIBarButtonItem(customView: btnBack)
        navigationItem.rightBarButtonItem = bar
    }
    
    func customizeTextField() {
        self.textInputbar.backgroundColor = UIColor.whiteColor()
        self.textInputbar.contentInset = UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0);
        self.textInputbar.autoHideRightButton = false
        self.textInputbar.textView.layer.borderWidth = 0
        self.textInputbar.textView.font = UIFont(name: "OpenSans", size: 16)!
        self.textInputbar.layer.borderWidth = 0
        self.textInputbar.layer.masksToBounds = true
        self.textInputbar.setShadowImage(UIImage(), forToolbarPosition: UIBarPosition.Any)
        
        let sendImage = UIImage(named: "ic_send")
        let rightButton = self.textInputbar.rightButton
        rightButton.tintColor = kColorNavigationBar
        rightButton.setImage(sendImage, forState: UIControlState.Normal)
        rightButton.setTitle("", forState: UIControlState.Normal)
    }
    
    override func didPressRightButton(sender: AnyObject!) {
        if let user = currentUser {
            let message = Message(
                contentType: kAMMessageDataContentTypeText,
                content: textView.text,
                date: NSDate(),
                sender: user)
            dataSource.collectionView(collectionView, insertMessages: [message]) {completed in
                self.scrollCollectionViewToBottom()
            }
        }
        super.didPressRightButton(sender)
    }
    
    private func generateMessages() {
        var messages = [Message]()
        for i in 0..<200 {
            let isTextMessage = arc4random_uniform(4) <= 2 // 75%
            let contentType = isTextMessage ? kAMMessageDataContentTypeText : kAMMessageDataContentTypeNetworkImage
            let content = isTextMessage
                ? LoremIpsum.wordsWithNumber((random() % 100) + 1)
                : LoremIpsum.URLForPlaceholderImageFromService(.LoremPixel, withSize: CGSizeMake(200, 200)).absoluteString
            
            let sender = users[random() % users.count]
            
            let previousMessage: Message? = i > 0 ? messages[i - 1] : nil
            let hasSameSender = (sender.ID == previousMessage?.senderID()) ?? false
            let date = hasSameSender ? previousMessage!.date().dateByAddingTimeInterval(5) : LoremIpsum.date()
            
            let message = Message(
                contentType: contentType,
                content: content,
                date: date,
                sender: sender
            )
            messages.append(message)
        }
        dataSource.collectionView(collectionView, insertMessages: messages, completion: nil)
    }
    
    func changeCurrentUser() {
        let otherUsers = users.filter({$0.ID != self.dataSource.currentUserID()})
        let newUser = otherUsers[random() % otherUsers.count]
        dataSource.collectionView(collectionView, updateCurrentUserID: newUser.ID)
    }
    
    
    class func CreateWithModel(model: PFObject) -> ChannelViewController{
        var channel = ChannelViewController()
        channel.owner = model
        return channel
    }
    
    class func CreateWithId(objectId: String) -> ChannelViewController {
        return CreateWithModel(PFObject(withoutDataWithClassName: "_User", objectId: objectId))
    }
}