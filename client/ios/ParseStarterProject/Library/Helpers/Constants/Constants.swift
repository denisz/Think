let kAppName: String = "Phink"
let kColorNavigationBar = UIColor(red:0.2, green:0.2, blue:0.2, alpha:1)
let kColorBackgroundViewController = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1)
let kColorSwitchTint = UIColor(red:0, green:0.64, blue:0.85, alpha:1)
let kFontNavigationBarTitle = UIFont(name: "OpenSans-Light", size: 19)!
let kFontNavigationItem = UIFont(name: "OpenSans-Light", size: 18)!
let kWidthScreen = 320


//Cache keys
let kUserDefaultCacheFollowingKey = "com.think.userDefaults.cache.following"


//common Fields
let kClassCreatedAt = "createdAt"
let kClassUpdatedAt = "updatedAt"
let kClassObjectId  = "objectId"


// MARK: - User
let kUserClassKey               = "User"

//fields
let kUserFirstNameKey           = "first_name"
let kUserLastNameKey            = "last_name"
let kUserUsernameKey            = "username"
let kUserProfilePictureKey      = "profile_picture"
let kUserProfileCoverKey        = "profile_cover"
let kUserSettingsKey            = "settings"
let kUserDateOfBirthKey         = "date_of_birth"
let kUserCountryKey             = "country"
let kUserCityKey                = "city"

//MARK: - Activity Class
let kActivityClassKey           = "Activity"

// type values
let kActivityTypeLike           = "like" //лайк
let kActivityTypeFollow         = "follow" //слежка за пользователем
let kActivityTypeComment        = "comment"//коммент поста
let kActivityTypeNewPost        = "new_post"//создания нового поста


//status
//let kActivityStatusTypeActive    = "active"
//let kActivityStatusTypeRemoved   = "removed"
//let kActivityStatusTypeBanned    = "banned"

// fields
let kActivityTypeKey            = "type"//тип статус
let kActivityFromUserKey        = "from_user"//источник
let kActivityToUserKey          = "to_user"//пользователя назанчение
let kActivityContentKey         = "content"//пользовательские данные (например: текст комментария)
let kActivityPostKey            = "post"//ссылка на пост (например лайк)
let kActivityPictureKey         = "picture" //картинка (например в комментариях)

//MARK: - Post Class
let kPostClassKey               = "Post"

//fields
let kPostContentKey             = "content"
let kPostContentObjKey          = "content_obj"
let kPostContentShortKey        = "content_short"
let kPostTitleKey               = "title"
let kPostOwnerKey               = "owner"
let kPostOwnerUserNameKey       = "owner.username"
let kPostCretedAtKey            = "created_at"
let kPostTagsKey                = "tags"
let kPostCoverKey               = "cover"
let kPostSettingsKey            = "settings"
let kPostStatusKey              = "status"
let kPostCounterLikesKey        = "counter_likes"
let kPostCounterCommentsKey     = "counter_comments"


//post status

let kPostStatusPublic       = "public"
let kPostStatusDraft        = "draft"

//fields settings
let kPostOptPostTo        = "postTo"
let kPostOptVisibleTo     = "visibleTo"
let kPostOptComments      = "comments"
let kPostOptExportTo      = "exportTo"
let kPostOptLocation      = "location"
let kPostOptHideComments  = "hideComments"
let kPostOptSocialCounter = "socialCounter"
let kPostOptAdultContent  = "adultContent"


//fields Post block
let kPostBlockTextKey           = "text"
let kPostBlockStyleKey          = "style"


//MARK: Bookmark
let kBookmarkClassKey           = "Bookmark"

//fields
let kBookmarkUserKey            = "user"
let kBookmarkPostKey            = "post"
let kBookmarkPostOwnerKey       = "post.owner"

// MARK: Installation
let kInstallationUserKey        = "user"
let kInstallationChannelsKey    = "channels"

// MARK: Notification
let kAPNSAlertKey = "alert"
let kAPNSBadgeKey = "badge"
let kAPNSSoundKey = "sound"

let kPushPayloadPayloadTypeKey          = "p"
let kPushPayloadPayloadTypeActivityKey  = "a"

let kPushPayloadActivityTypeKey         = "t"
let kPushPayloadActivityLikeKey         = "l"
let kPushPayloadActivityCommentKey      = "c"
let kPushPayloadActivityFollowKey       = "f"
let kPushPayloadActivityCreatePostKey   = "n"

let kPushPayloadFromUserObjectIdKey     = "fu"
let kPushPayloadToUserObjectIdKey       = "tu"
let kPushPayloadPoseObjectIdKey         = "pid"

//notifications
let kUserUnlikedPost        = "com.think.user.unliked.post"
let kUserLikedPost          = "com.think.user.liked.post"
let kUserAddBookmark        = "com.think.user.add.bookmark"
let kUserFollowingUser      = "com.think.following.user"
let kUserUnfollowUser       = "com.think.unfollow.user"
let kUserRaisePost          = "com.think.raise.post"
let kUserSendComment        = "com.think.send.comment"
let kUserUpdateProfile      = "com.think.update.profile"

//side menu notifications
enum kSideMenu: String {
    case Notificaiton       = "com.think.side.noitification"
    case Feed               = "com.think.side.feed"
    case Top                = "com.think.side.top"
    case Bookmarks          = "com.think.side.bookmarks"
    case Settings           = "com.think.side.settings"
    case Drafts             = "com.think.side.drafts"
    case Profile            = "com.think.side.profile"
    case Digest             = "com.think.side.digest"
    case Messages           = "com.think.side.messages"
    case Logout             = "com.think.side.logout"
    
    static let allValues = [Notificaiton, Feed, Top, Bookmarks, Settings, Drafts, Profile, Digest, Messages]
}

enum ScrollDirection {
    case ScrollDirectionNone
    case ScrollDirectionRight
    case ScrollDirectionLeft
    case ScrollDirectionUp
    case ScrollDirectionDown
    case ScrollDirectionCrazy
    
    init() {
        self = .ScrollDirectionUp
    }
}

// MARK: Post blocks
let kReusableTitlePostViewCell      = "TitlePostViewCell"
let kReusableTextPostViewCell       = "TextPostViewCell"
let kReusablePicturePostViewCell    = "PicturePostViewCell"
let kReusableCoverPostViewCell      = "CoverPostViewCell"
let kReusablePostBlockViewCell      =  "PostBlockViewCell"
let kReusableFollowUserViewCell     = "FollowUserViewCell"
let kReusableFeedPostViewCell       = "FeedPostViewCell"
let kReusableProfilePostViewCell    = "ProfilePostViewCell"
let kReusableNotificationsViewCell  = "NotificationViewCell"
let kReusableBookmarksViewCell      = "BookmarksViewCell"
let kReusableDraftsViewCell         = "DraftsViewCell"
let kReusableMessageViewCell        = "MessageViewCell"
let kReusableSideMenuViewCell       = "SideMenuViewCell"
let kReusableCommentViewCell        = "CommentViewCell"



















