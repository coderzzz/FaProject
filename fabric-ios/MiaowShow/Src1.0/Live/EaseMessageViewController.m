/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "EaseMessageViewController.h"

#import <Foundation/Foundation.h>
//#import <Photos/Photos.h>
//#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoManager.h"
#import "NSDate+Category.h"
//#import "EaseUsersListViewController.h"
#import "EaseMessageReadManager.h"
//#import "EaseEmotionManager.h"
//#import "EaseEmoji.h"
//#import "EaseEmotionEscape.h"
#import "EaseCustomMessageCell.h"
//#import "UIImage+EMGIF.h"
//#import "EaseLocalDefine.h"
//#import "EaseSDKHelper.h"

#define KHintAdjustY    50

#define IOS_VERSION [[UIDevice currentDevice] systemVersion]>=9.0

typedef enum : NSUInteger {
    EMRequestRecord,
    EMCanRecord,
    EMCanNotRecord,
} EMRecordResponse;


@implementation EaseAtTarget
- (instancetype)initWithUserId:(NSString*)userId andNickname:(NSString*)nickname
{
    if (self = [super init]) {
        _userId = [userId copy];
        _nickname = [nickname copy];
    }
    return self;
}
@end

@interface EaseMessageViewController ()<EaseMessageCellDelegate>
{
    UIMenuItem *_copyMenuItem;
    UIMenuItem *_deleteMenuItem;
    UILongPressGestureRecognizer *_lpgr;
    NSMutableArray *_atTargets;
    BOOL hideToolBar;
    dispatch_queue_t _messageQueue;
    BOOL _isRecording;
}

@property (strong, nonatomic) id<IMessageModel> playingVoiceModel;
@property (nonatomic) BOOL isKicked;
@property (nonatomic) BOOL isPlayingAudio;
@property (assign, nonatomic) int pageN;
@property (nonatomic, strong) NSMutableArray *atTargets;

@end

@implementation EaseMessageViewController


@synthesize deleteConversationIfNull = _deleteConversationIfNull;
@synthesize messageCountOfPage = _messageCountOfPage;
@synthesize timeCellHeight = _timeCellHeight;
@synthesize messageTimeIntervalTag = _messageTimeIntervalTag;

- (instancetype)initWithConversationChatter:(NSString *)conversationChatter
{
    
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {

        _messageCountOfPage = 10;
        _timeCellHeight = 30;
        _deleteConversationIfNull = YES;
        _scrollToBottomWhenAppear = YES;
        _messsagesSource = [NSMutableArray array];
        _messageQueue = dispatch_queue_create("hyphenate.com", NULL);

    }
    
    return self;
}

- (instancetype)initWithMsg:(EMMessage *)msg hideToolBar:(BOOL)hide
{
    
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        
        _messageCountOfPage = 10;
        _timeCellHeight = 30;
        _deleteConversationIfNull = YES;
        _scrollToBottomWhenAppear = YES;
        _messsagesSource = [NSMutableArray array];
        _messageQueue = dispatch_queue_create("hyphenate.com", NULL);
        hideToolBar = hide;
        [self addMessageToDataSource:msg progress:nil];
//        [_messsagesSource addObject:msg];
    }
    
    return self;
}

- (void)setToUserId:(NSString *)toUserId{
    
    _toUserId = toUserId;
    BAIRUITECH_BRAccount *account = [BAIRUITECH_BRAccoutTool account];
    self.dataArray = [NSMutableArray array];
    [self.tableView reloadData];
    for (NSDictionary *dic in [FabricSocket shareInstances].messages) {
        
        NSString *reciveId = [NSString stringWithFormat:@"%@",dic[@"receiverid"]];
        NSString *sendId = [NSString stringWithFormat:@"%@",dic[@"senderid"]];
        if (![reciveId isEqualToString:@"0"]) {
            
            if (([reciveId isEqualToString:self.toUserId] && [sendId isEqualToString:account.userId]) || ([reciveId isEqualToString:account.userId] && [sendId isEqualToString:self.toUserId])) {
//                
//                EMMessage *message = [[EMMessage alloc]init];
//                EMMessageBody *body = [EMMessageBody new];
//                body.type = EMMessageBodyTypeText;
//                message.body = body;
//                NSDictionary *content = [self dictionaryWithJsonString:dic[@"content"]];
//                message.text = content[@"msg"];
//                message.from = content[@"nickName"];
//                message.avatar = [NSString stringWithFormat:@"%@%@",ImageURL,content[@"userLogo"]];
//                message.direction = [sendId isEqualToString:account.userId]?EMMessageDirectionSend:EMMessageDirectionReceive;
//                message.timestamp = [[NSString stringWithFormat:@"%@",dic[@"time"]] longLongValue];
//                [self addMessageToDataSource:message progress:nil];
                
                
                
                
                int type = [[NSString stringWithFormat:@"%@",dic[@"type"]] intValue];
                NSDictionary *content = [self dictionaryWithJsonString:dic[@"content"]];
                if (type <=1) {
                    
                    EMMessage *message = [[EMMessage alloc]init];
                    EMMessageBody *body = [EMMessageBody new];
                    body.type = EMMessageBodyTypeText;
                    message.body = body;
                    message.text = content[@"msg"];
                    message.from = content[@"nickName"];
                    message.avatar = [NSString stringWithFormat:@"%@%@",ImageURL,content[@"userLogo"]];
                    message.direction = [sendId isEqualToString:account.userId]?EMMessageDirectionSend:EMMessageDirectionReceive;
                    message.timestamp = [[NSString stringWithFormat:@"%@",dic[@"time"]] longLongValue];
                    [self addMessageToDataSource:message progress:nil];
                }
                else if (type == 2){
                    
                    EMMessage *message = [[EMMessage alloc]init];
                    EMMessageBody *body = [EMMessageBody new];
                    body.type = EMMessageBodyTypeImage;
                    message.body = body;
                    message.from =  content[@"nickName"];
                    message.imageURL = [NSString stringWithFormat:@"%@",content[@"msg"]];
                    message.avatar = [NSString stringWithFormat:@"%@%@",ImageURL,content[@"userLogo"]];
                    message.direction = EMMessageDirectionReceive;
                    message.timestamp = [[NSString stringWithFormat:@"%@",dic[@"time"]] longLongValue];
                    [self addMessageToDataSource:message progress:nil];
                }
                else if (type == 3){
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
                        EMMessage *message = [[EMMessage alloc]init];
                        EMMessageBody *body = [EMMessageBody new];
                        body.type = EMMessageBodyTypeVoice;
                        message.body = body;
                        message.from = content[@"nickName"];
                        NSArray *ary = [content[@"msg"] componentsSeparatedByString:@"&"];
                        
                        
                        NSData *data = [NSData dataWithContentsOfURL:
                                        [NSURL URLWithString:[NSString stringWithFormat:@"%@",ary.firstObject]]];
                        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.amr",dic[@"time"]]];
                        [data writeToFile:filePath atomically:YES];
                        message.voicePath = filePath;
                        message.duration = [ary.lastObject floatValue];;
                        message.avatar = [NSString stringWithFormat:@"%@%@",ImageURL,content[@"userLogo"]];
                        message.direction = EMMessageDirectionReceive;
                        message.timestamp = [[NSString stringWithFormat:@"%@",dic[@"time"]] longLongValue];
                        [self addMessageToDataSource:message progress:nil];
                    });
                }
                
                
                
            }
        }
    }
    if (!(self.dataArray.count>0)) {
        
        [self.tableView.mj_header beginRefreshing];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:248 / 255.0 green:248 / 255.0 blue:248 / 255.0 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideImagePicker) name:@"hideImagePicker" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didReceiveMessage:) name:@"FSDidReceiveMessage" object:nil];
    //Initialization
    CGFloat chatbarHeight = [EaseChatToolbar defaultHeight];
    EMChatToolbarType barType =  EMChatToolbarTypeGroup;
    
    if (!hideToolBar) {
    
        self.showRefreshHeader = YES;
        self.chatToolbar = [[EaseChatToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - chatbarHeight, self.view.frame.size.width, chatbarHeight) type:barType];
        self.chatToolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        
    }
    
    
    //Initializa the gesture recognizer
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardHidden:)];
    [self.view addGestureRecognizer:tap];
    
    _lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    _lpgr.minimumPressDuration = 0.5;
    [self.tableView addGestureRecognizer:_lpgr];
    
    
    //Register the delegate
    [EMCDDeviceManager sharedInstance].delegate = self;
//
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[EaseBaseMessageCell appearance] setSendBubbleBackgroundImage:[[UIImage imageNamed:@"EaseUIResource.bundle/chat_sender_bg"] stretchableImageWithLeftCapWidth:5 topCapHeight:35]];
    [[EaseBaseMessageCell appearance] setRecvBubbleBackgroundImage:[[UIImage imageNamed:@"EaseUIResource.bundle/chat_receiver_bg"] stretchableImageWithLeftCapWidth:35 topCapHeight:35]];
    
    [[EaseBaseMessageCell appearance] setSendMessageVoiceAnimationImages:@[[UIImage imageNamed:@"EaseUIResource.bundle/chat_sender_audio_playing_full"], [UIImage imageNamed:@"EaseUIResource.bundle/chat_sender_audio_playing_000"], [UIImage imageNamed:@"EaseUIResource.bundle/chat_sender_audio_playing_001"], [UIImage imageNamed:@"EaseUIResource.bundle/chat_sender_audio_playing_002"], [UIImage imageNamed:@"EaseUIResource.bundle/chat_sender_audio_playing_003"]]];
    [[EaseBaseMessageCell appearance] setRecvMessageVoiceAnimationImages:@[[UIImage imageNamed:@"EaseUIResource.bundle/chat_receiver_audio_playing_full"],[UIImage imageNamed:@"EaseUIResource.bundle/chat_receiver_audio_playing000"], [UIImage imageNamed:@"EaseUIResource.bundle/chat_receiver_audio_playing001"], [UIImage imageNamed:@"EaseUIResource.bundle/chat_receiver_audio_playing002"], [UIImage imageNamed:@"EaseUIResource.bundle/chat_receiver_audio_playing003"]]];
    
    [[EaseBaseMessageCell appearance] setAvatarSize:40.f];
    [[EaseBaseMessageCell appearance] setAvatarCornerRadius:20.f];
    
    [[EaseChatBarMoreView appearance] setMoreViewBackgroundColor:[UIColor colorWithRed:240 / 255.0 green:242 / 255.0 blue:247 / 255.0 alpha:1.0]];


}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[EMCDDeviceManager sharedInstance] stopPlaying];
    [EMCDDeviceManager sharedInstance].delegate = nil;
    
    if (_imagePicker){
        [_imagePicker dismissViewControllerAnimated:NO completion:nil];
        _imagePicker = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.isViewDidAppear = YES;
//    [[EaseSDKHelper shareHelper] setIsShowingimagePicker:NO];
    
    if (self.scrollToBottomWhenAppear) {
        [self _scrollViewToBottom:NO];
    }
    self.scrollToBottomWhenAppear = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.isViewDidAppear = NO;
    [[EMCDDeviceManager sharedInstance] disableProximitySensor];
}


- (NSMutableArray*)atTargets
{
    if (!_atTargets) {
        _atTargets = [NSMutableArray array];
    }
    return _atTargets;
}

#pragma mark - setter

//- (void)setIsViewDidAppear:(BOOL)isViewDidAppear
//{
//    _isViewDidAppear =isViewDidAppear;
//    if (_isViewDidAppear)
//    {
//        NSMutableArray *unreadMessages = [NSMutableArray array];
//        for (EMMessage *message in self.messsagesSource)
//        {
//            if ([self shouldSendHasReadAckForMessage:message read:NO])
//            {
//                [unreadMessages addObject:message];
//            }
//        }
//        if ([unreadMessages count])
//        {
//            [self _sendHasReadResponseForMessages:unreadMessages isRead:YES];
//        }
//        
//        [_conversation markAllMessagesAsRead:nil];
//    }
//}

- (void)setChatToolbar:(EaseChatToolbar *)chatToolbar
{
    [_chatToolbar removeFromSuperview];
    
    _chatToolbar = chatToolbar;
    if (_chatToolbar) {
        [self.view addSubview:_chatToolbar];
    }
    
    CGRect tableFrame = self.tableView.frame;
    tableFrame.size.height = self.view.frame.size.height - _chatToolbar.frame.size.height;
    self.tableView.frame = tableFrame;
    if ([chatToolbar isKindOfClass:[EaseChatToolbar class]]) {
        [(EaseChatToolbar *)self.chatToolbar setDelegate:self];
        self.chatBarMoreView = (EaseChatBarMoreView*)[(EaseChatToolbar *)self.chatToolbar moreView];
//        self.faceView = (EaseFaceView*)[(EaseChatToolbar *)self.chatToolbar faceView];
        self.recordView = (EaseRecordView*)[(EaseChatToolbar *)self.chatToolbar recordView];
    }
}

- (void)setDataSource:(id<EaseMessageViewControllerDataSource>)dataSource
{
    _dataSource = dataSource;
    
//    [self setupEmotion];
}

- (void)setDelegate:(id<EaseMessageViewControllerDelegate>)delegate
{
    _delegate = delegate;
}

#pragma mark - private helper

/*!
 @method
 @brief tableView滑动到底部
 @discussion
 @result
 */
- (void)_scrollViewToBottom:(BOOL)animated
{
    if (self.tableView.contentSize.height > self.tableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        [self.tableView setContentOffset:offset animated:animated];
    }
}

/*!
 @method
 @brief 当前设备是否可以录音
 @discussion
 @param aComplation 判断结果
 @result
 */
- (void)_canRecordComplation:(void(^)(EMRecordResponse))aComplation
{
    AVAuthorizationStatus videoAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (videoAuthStatus == AVAuthorizationStatusNotDetermined) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            if (aComplation) {
                aComplation(EMRequestRecord);
            }
        }];
    }
    else if(videoAuthStatus == AVAuthorizationStatusRestricted || videoAuthStatus == AVAuthorizationStatusDenied) {
        aComplation(EMCanNotRecord);
    }
    else{
        aComplation(EMCanRecord);
    }
}

- (void)showMenuViewController:(UIView *)showInView
                  andIndexPath:(NSIndexPath *)indexPath
                   messageType:(EMMessageBodyType)messageType
{
    if (_menuController == nil) {
        _menuController = [UIMenuController sharedMenuController];
    }
    
    if (_deleteMenuItem == nil) {
        _deleteMenuItem = [[UIMenuItem alloc] initWithTitle:@"Delete" action:@selector(deleteMenuAction:)];
    }
    
    if (_copyMenuItem == nil) {
        _copyMenuItem = [[UIMenuItem alloc] initWithTitle:@"Copy" action:@selector(copyMenuAction:)];
    }
    
    if (messageType == EMMessageBodyTypeText) {
        [_menuController setMenuItems:@[_copyMenuItem, _deleteMenuItem]];
    } else {
        [_menuController setMenuItems:@[_deleteMenuItem]];
    }
    [_menuController setTargetRect:showInView.frame inView:showInView.superview];
    [_menuController setMenuVisible:YES animated:YES];
}

- (void)_stopAudioPlayingWithChangeCategory:(BOOL)isChange
{
    //停止音频播放及播放动画
    [[EMCDDeviceManager sharedInstance] stopPlaying];
    [[EMCDDeviceManager sharedInstance] disableProximitySensor];
    [EMCDDeviceManager sharedInstance].delegate = nil;
    
}

/*!
 @method
 @brief mov格式视频转换为MP4格式
 @discussion
 @param movUrl   mov视频路径
 @result  MP4格式视频路径
 */
- (NSURL *)_convert2Mp4:(NSURL *)movUrl
{
    NSURL *mp4Url = nil;
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:movUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset
                                                                              presetName:AVAssetExportPresetHighestQuality];
        NSString *mp4Path = [NSString stringWithFormat:@"%@/%d%d.mp4", [EMCDDeviceManager dataPath], (int)[[NSDate date] timeIntervalSince1970], arc4random() % 100000];
        mp4Url = [NSURL fileURLWithPath:mp4Path];
        exportSession.outputURL = mp4Url;
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputFileType = AVFileTypeMPEG4;
        dispatch_semaphore_t wait = dispatch_semaphore_create(0l);
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed: {
                    NSLog(@"failed, error:%@.", exportSession.error);
                } break;
                case AVAssetExportSessionStatusCancelled: {
                    NSLog(@"cancelled.");
                } break;
                case AVAssetExportSessionStatusCompleted: {
                    NSLog(@"completed.");
                } break;
                default: {
                    NSLog(@"others.");
                } break;
            }
            dispatch_semaphore_signal(wait);
        }];
        long timeout = dispatch_semaphore_wait(wait, DISPATCH_TIME_FOREVER);
        if (timeout) {
            NSLog(@"timeout.");
        }
        if (wait) {
            //dispatch_release(wait);
            wait = nil;
        }
    }
    
    return mp4Url;
}

///*!
// @method
// @brief 通过当前会话类型，返回消息聊天类型
// @discussion
// @result
// */
//- (EMChatType)_messageTypeFromConversationType
//{
//    EMChatType type = EMChatTypeChat;
//    switch (self.conversation.type) {
//        case EMConversationTypeChat:
//            type = EMChatTypeChat;
//            break;
//        case EMConversationTypeGroupChat:
//            type = EMChatTypeGroupChat;
//            break;
//        case EMConversationTypeChatRoom:
//            type = EMChatTypeChatRoom;
//            break;
//        default:
//            break;
//    }
//    return type;
//}

/*!
 @method
 @brief 下载消息附件
 @discussion
 @param message  待下载附件的消息
 @result
 */
- (void)_downloadMessageAttachments:(id)message
{
    /*
    __weak typeof(self) weakSelf = self;
    void (^completion)(EMMessage *aMessage, EMError *error) = ^(EMMessage *aMessage, EMError *error) {
        if (!error)
        {
            [weakSelf _reloadTableViewDataWithMessage:message];
        }
        else
        {
            [weakSelf showHint:@"thumbnail for failure!"];
        }
    };
    
    EMMessageBody *messageBody = message.body;
    if ([messageBody type] == EMMessageBodyTypeImage) {
        EMImageMessageBody *imageBody = (EMImageMessageBody *)messageBody;
        if (imageBody.thumbnailDownloadStatus > EMDownloadStatusSuccessed)
        {
            //download the message thumbnail
//            [[[EMClient sharedClient] chatManager] downloadMessageThumbnail:message progress:nil completion:completion];
        }
    }
    else if ([messageBody type] == EMMessageBodyTypeVideo)
    {
        EMVideoMessageBody *videoBody = (EMVideoMessageBody *)messageBody;
        if (videoBody.thumbnailDownloadStatus > EMDownloadStatusSuccessed)
        {
            //download the message thumbnail
//            [[[EMClient sharedClient] chatManager] downloadMessageThumbnail:message progress:nil completion:completion];
        }
    }
    else if ([messageBody type] == EMMessageBodyTypeVoice)
    {
        EMVoiceMessageBody *voiceBody = (EMVoiceMessageBody*)messageBody;
        if (voiceBody.downloadStatus > EMDownloadStatusSuccessed)
        {
            //download the message attachment
//            [[EMClient sharedClient].chatManager downloadMessageAttachment:message progress:nil completion:^(EMMessage *message, EMError *error) {
//                if (!error) {
//                    [weakSelf _reloadTableViewDataWithMessage:message];
//                }
//                else {
//                    [weakSelf showHint:@"voice for failure!"];
//                }
//            }];
        }
    }
     */
}

/*!
 @method
 @brief 传入消息是否需要发动已读回执
 @discussion
 @param message  待判断的消息
 @param read     消息是否已读
 @result
 */
- (BOOL)shouldSendHasReadAckForMessage:(id)message
                                  read:(BOOL)read
{
    return YES;
    /*
//    NSString *account = [[EMClient sharedClient] currentUsername];
    if (message.chatType != EMChatTypeChat || message.isReadAcked || message.direction == EMMessageDirectionSend || ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) || !self.isViewDidAppear)
    {
        return NO;
    }
    
    EMMessageBody *body = message.body;
    if (((body.type == EMMessageBodyTypeVideo) ||
         (body.type == EMMessageBodyTypeVoice) ||
         (body.type == EMMessageBodyTypeImage)) &&
        !read)
    {
        return NO;
    }
    else
    {
        return YES;
    }
     */
}

/*!
 @method
 @brief 为传入的消息发送已读回执
 @discussion
 @param messages  待发送已读回执的消息数组
 @param isRead    是否已读
 @result
 */
- (void)_sendHasReadResponseForMessages:(NSArray*)messages
                                 isRead:(BOOL)isRead
{
    /*
    NSMutableArray *unreadMessages = [NSMutableArray array];
    for (NSInteger i = 0; i < [messages count]; i++)
    {
        EMMessage *message = messages[i];
        BOOL isSend = YES;
        if (_dataSource && [_dataSource respondsToSelector:@selector(messageViewController:shouldSendHasReadAckForMessage:read:)]) {
            isSend = [_dataSource messageViewController:self
                         shouldSendHasReadAckForMessage:message read:isRead];
        }
        else{
            isSend = [self shouldSendHasReadAckForMessage:message
                                                     read:isRead];
        }
        
        if (isSend)
        {
            [unreadMessages addObject:message];
        }
    }
    
    if ([unreadMessages count])
    {
        for (EMMessage *message in unreadMessages)
        {
//            [[EMClient sharedClient].chatManager sendMessageReadAck:message completion:nil];
        }
    }
     */
}

- (BOOL)_shouldMarkMessageAsRead
{
    BOOL isMark = YES;
    if (_dataSource && [_dataSource respondsToSelector:@selector(messageViewControllerShouldMarkMessagesAsRead:)]) {
        isMark = [_dataSource messageViewControllerShouldMarkMessagesAsRead:self];
    }
    else{
        if (([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) || !self.isViewDidAppear)
        {
            isMark = NO;
        }
    }
    
    return isMark;
}

///*!
// @method
// @brief 位置消息被点击选择
// @discussion
// @param model 消息model
// @result
// */
//- (void)_locationMessageCellSelected:(id<IMessageModel>)model
//{
//    _scrollToBottomWhenAppear = NO;
//    
//    EaseLocationViewController *locationController = [[EaseLocationViewController alloc] initWithLocation:CLLocationCoordinate2DMake(model.latitude, model.longitude)];
//    [self.navigationController pushViewController:locationController animated:YES];
//}

/*!
 @method
 @brief 视频消息被点击选择
 @discussion
 @param model 消息model
 @result
 */
- (void)_videoMessageCellSelected:(id<IMessageModel>)model
{
    _scrollToBottomWhenAppear = NO;
    
    /*
    EMVideoMessageBody *videoBody = (EMVideoMessageBody*)model.message.body;
    
    NSString *localPath = [model.fileLocalPath length] > 0 ? model.fileLocalPath : videoBody.localPath;
    if ([localPath length] == 0) {
        [self showHint:@"video for failure!"];
        return;
    }
    
    dispatch_block_t block = ^{
        //send the acknowledgement
        [self _sendHasReadResponseForMessages:@[model.message]
                                       isRead:YES];
        
        NSURL *videoURL = [NSURL fileURLWithPath:localPath];
        MPMoviePlayerViewController *moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
        [moviePlayerController.moviePlayer prepareToPlay];
        moviePlayerController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
        [self presentMoviePlayerViewControllerAnimated:moviePlayerController];
    };
    
    __weak typeof(self) weakSelf = self;
    void (^completion)(EMMessage *aMessage, EMError *error) = ^(EMMessage *aMessage, EMError *error) {
        if (!error)
        {
            [weakSelf _reloadTableViewDataWithMessage:aMessage];
        }
        else
        {
            [weakSelf showHint:@"thumbnail for failure!"];
        }
    };
    
    if (videoBody.thumbnailDownloadStatus == EMDownloadStatusFailed || ![[NSFileManager defaultManager] fileExistsAtPath:videoBody.thumbnailLocalPath]) {
        [self showHint:@"begin downloading thumbnail image, click later"];
//        [[EMClient sharedClient].chatManager downloadMessageThumbnail:model.message progress:nil completion:completion];
        return;
    }
    
    if (videoBody.downloadStatus == EMDownloadStatusSuccessed && [[NSFileManager defaultManager] fileExistsAtPath:localPath])
    {
        block();
        return;
    }
    
    [self showHudInView:self.view hint:@"downloading video..."];
//    [[EMClient sharedClient].chatManager downloadMessageAttachment:model.message progress:nil completion:^(EMMessage *message, EMError *error) {
//        [weakSelf hideHud];
//        if (!error) {
//            block();
//        }else{
//            [weakSelf showHint:@"video for failure!"];
//        }
//    }];
     */
}

/*!
 @method
 @brief 图片消息被点击选择
 @discussion
 @param model 消息model
 @result
 */
- (void)_imageMessageCellSelected:(id<IMessageModel>)model
{
    if (model.image) {
        
        [[EaseMessageReadManager defaultManager] showBrowserWithImages:@[model.image]];
    }
    else{
        
        [[EaseMessageReadManager defaultManager] showBrowserWithImages:@[model.fileURLPath]];
    }
    
}

/*!
 @method
 @brief 语音消息被点击选择
 @discussion
 @param model 消息model
 @result
 */
- (void)_audioMessageCellSelected:(id<IMessageModel>)model
{

    _scrollToBottomWhenAppear = NO;
//    EMVoiceMessageBody *body = (EMVoiceMessageBody*)model.message.body;
//    EMDownloadStatus downloadStatus = [body downloadStatus];
//    if (downloadStatus == EMDownloadStatusDownloading) {
//        [self showHint:@"downloading voice, click later"];
//        return;
//    }
//    else if (downloadStatus == EMDownloadStatusFailed)
//    {
//        [self showHint:@"downloading voice, click later"];
////        [[EMClient sharedClient].chatManager downloadMessageAttachment:model.message progress:nil completion:nil];
//        return;
//    }
    
    // play the audio
    if (model.bodyType == EMMessageBodyTypeVoice) {
        //send the acknowledgement
//        [self _sendHasReadResponseForMessages:@[model.message] isRead:YES];
        __weak EaseMessageViewController *weakSelf = self;
        BOOL isPrepare = [[EaseMessageReadManager defaultManager] prepareMessageAudioModel:model updateViewCompletion:^(EaseMessageModel *prevAudioModel, EaseMessageModel *currentAudioModel) {
            if (prevAudioModel || currentAudioModel) {
                [weakSelf.tableView reloadData];
            }
        }];
        
        if (isPrepare) {
            _isPlayingAudio = YES;
            __weak EaseMessageViewController *weakSelf = self;
            [[EMCDDeviceManager sharedInstance] enableProximitySensor];
            [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:model.fileURLPath completion:^(NSError *error) {
                [[EaseMessageReadManager defaultManager] stopMessageAudioModel];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                    weakSelf.isPlayingAudio = NO;
                    [[EMCDDeviceManager sharedInstance] disableProximitySensor];
                });
            }];
        }
        else{
            _isPlayingAudio = NO;
        }
    }

}

#pragma mark - pivate data

/*!
 @method
 @brief 加载历史消息
 @discussion
 @param messageId 参考消息的ID
 @param count     获取条数
 @param isAppend  是否在dataArray直接添加
 @result
 */
- (void)_loadMessagesBefore:(NSString*)messageId
                      count:(NSInteger)count
                     append:(BOOL)isAppend
{
    __weak typeof(self) weakSelf = self;
    void (^refresh)(NSArray *messages) = ^(NSArray *messages) {
        dispatch_async(_messageQueue, ^{
            //Format the message
            NSArray *formattedMessages = [weakSelf formatMessages:messages];
            
            //Refresh the page
            dispatch_async(dispatch_get_main_queue(), ^{
                EaseMessageViewController *strongSelf = weakSelf;
                if (strongSelf) {
                    NSInteger scrollToIndex = 0;
                    if (isAppend) {
                        [strongSelf.messsagesSource insertObjects:messages atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [messages count])]];
                        
                        //Combine the message
                        id object = [strongSelf.dataArray firstObject];
                        if ([object isKindOfClass:[NSString class]]) {
                            NSString *timestamp = object;
                            [formattedMessages enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id model, NSUInteger idx, BOOL *stop) {
                                if ([model isKindOfClass:[NSString class]] && [timestamp isEqualToString:model]) {
                                    [strongSelf.dataArray removeObjectAtIndex:0];
                                    *stop = YES;
                                }
                            }];
                        }
                        scrollToIndex = [strongSelf.dataArray count];
                        [strongSelf.dataArray insertObjects:formattedMessages atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [formattedMessages count])]];
                    }
                    else {
                        [strongSelf.messsagesSource removeAllObjects];
                        [strongSelf.messsagesSource addObjectsFromArray:messages];
                        
                        [strongSelf.dataArray removeAllObjects];
                        [strongSelf.dataArray addObjectsFromArray:formattedMessages];
                    }
                    
//                    EMMessage *latest = [strongSelf.messsagesSource lastObject];
//                    strongSelf.messageTimeIntervalTag = latest.timestamp;
                    
                    [strongSelf.tableView reloadData];
                    
                    [strongSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.dataArray count] - scrollToIndex - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }
            });
            
            //re-download all messages that are not successfully downloaded
//            for (EMMessage *message in messages)
//            {
//                [weakSelf _downloadMessageAttachments:message];
//            }
            
            //send the read acknoledgement
//            [weakSelf _sendHasReadResponseForMessages:messages
//                                               isRead:NO];
        });
    };
    
//    [self.conversation loadMessagesStartFromId:messageId count:(int)count searchDirection:EMMessageSearchDirectionUp completion:^(NSArray *aMessages, EMError *aError) {
//        if (!aError && [aMessages count]) {
//            refresh(aMessages);
//        }
//    }];
}

#pragma mark - GestureRecognizer

-(void)keyBoardHidden:(UITapGestureRecognizer *)tapRecognizer
{
    if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
        [self.chatToolbar endEditing:YES];
    }
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan && [self.dataArray count] > 0)
    {
        CGPoint location = [recognizer locationInView:self.tableView];
        NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:location];
        BOOL canLongPress = NO;
        if (_dataSource && [_dataSource respondsToSelector:@selector(messageViewController:canLongPressRowAtIndexPath:)]) {
            canLongPress = [_dataSource messageViewController:self
                                   canLongPressRowAtIndexPath:indexPath];
        }
        
        if (!canLongPress) {
            return;
        }
        
        if (_dataSource && [_dataSource respondsToSelector:@selector(messageViewController:didLongPressRowAtIndexPath:)]) {
            [_dataSource messageViewController:self
                    didLongPressRowAtIndexPath:indexPath];
        }
        else{
            id object = [self.dataArray objectAtIndex:indexPath.row];
            if (![object isKindOfClass:[NSString class]]) {
                EaseMessageCell *cell = (EaseMessageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                [cell becomeFirstResponder];
                _menuIndexPath = indexPath;
                [self showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:cell.model.bodyType];
            }
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self.dataArray objectAtIndex:indexPath.row];
    
    //time cell
    if ([object isKindOfClass:[NSString class]]) {
        NSString *TimeCellIdentifier = [EaseMessageTimeCell cellIdentifier];
        EaseMessageTimeCell *timeCell = (EaseMessageTimeCell *)[tableView dequeueReusableCellWithIdentifier:TimeCellIdentifier];
        
        if (timeCell == nil) {
            timeCell = [[EaseMessageTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TimeCellIdentifier];
            timeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        timeCell.title = object;
        return timeCell;
    }
    else{
        id<IMessageModel> model = object;
//        if (_delegate && [_delegate respondsToSelector:@selector(messageViewController:cellForMessageModel:)]) {
//            UITableViewCell *cell = [_delegate messageViewController:tableView cellForMessageModel:model];
//            if (cell) {
//                if ([cell isKindOfClass:[EaseMessageCell class]]) {
//                    EaseMessageCell *emcell= (EaseMessageCell*)cell;
//                    if (emcell.delegate == nil) {
//                        emcell.delegate = self;
//                    }
//                }
//                return cell;
//            }
//        }
//        
        
        NSString *CellIdentifier = [EaseMessageCell cellIdentifierWithModel:model];
        
        EaseBaseMessageCell *sendCell = (EaseBaseMessageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        // Configure the cell...
        if (sendCell == nil) {
            sendCell = [[EaseBaseMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier model:model];
            sendCell.selectionStyle = UITableViewCellSelectionStyleNone;
            sendCell.delegate = self;
        }
        
        sendCell.model = model;
        return sendCell;
    }
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self.dataArray objectAtIndex:indexPath.row];
    if ([object isKindOfClass:[NSString class]]) {
        return self.timeCellHeight;
    }
    else{
        id<IMessageModel> model = object;
//        if (_delegate && [_delegate respondsToSelector:@selector(messageViewController:heightForMessageModel:withCellWidth:)]) {
//            CGFloat height = [_delegate messageViewController:self heightForMessageModel:model withCellWidth:tableView.frame.size.width];
//            if (height) {
//                return height;
//            }
//        }
        
//        if (_dataSource && [_dataSource respondsToSelector:@selector(isEmotionMessageFormessageViewController:messageModel:)]) {
//            BOOL flag = [_dataSource isEmotionMessageFormessageViewController:self messageModel:model];
//            if (flag) {
//                return [EaseCustomMessageCell cellHeightWithModel:model];
//            }
//        }
        
        return [EaseBaseMessageCell cellHeightWithModel:model];
    }
}


#pragma mark - EaseMessageCellDelegate

- (void)messageCellSelected:(id<IMessageModel>)model
{
    if (_delegate && [_delegate respondsToSelector:@selector(messageViewController:didSelectMessageModel:)]) {
        BOOL flag = [_delegate messageViewController:self didSelectMessageModel:model];
        if (flag) {
            [self _sendHasReadResponseForMessages:@[model.message] isRead:YES];
            return;
        }
    }
    
    switch (model.bodyType) {
        case EMMessageBodyTypeImage:
        {
            _scrollToBottomWhenAppear = NO;
            [self _imageMessageCellSelected:model];
        }
            break;
        case EMMessageBodyTypeLocation:
        {
//            [self _locationMessageCellSelected:model];
        }
            break;
        case EMMessageBodyTypeVoice:
        {
            [self _audioMessageCellSelected:model];
        }
            break;
        case EMMessageBodyTypeVideo:
        {
            [self _videoMessageCellSelected:model];
            
        }
            break;
        case EMMessageBodyTypeFile:
        {
            _scrollToBottomWhenAppear = NO;
            [self showHint:@"Custom implementation!"];
        }
            break;
        default:
            break;
    }
}

- (void)statusButtonSelcted:(id<IMessageModel>)model withMessageCell:(EaseMessageCell*)messageCell
{
//    if ((model.messageStatus != EMMessageStatusFailed) && (model.messageStatus != EMMessageStatusPending))
//    {
//        return;
//    }
//    
//    __weak typeof(self) weakself = self;
//    [[[EMClient sharedClient] chatManager] resendMessage:model.message progress:nil completion:^(EMMessage *message, EMError *error) {
//        if (!error) {
//            [weakself _refreshAfterSentMessage:message];
//        }
//        else {
//            [weakself.tableView reloadData];
//        }
//    }];
    
    [self.tableView reloadData];
}

- (void)avatarViewSelcted:(id<IMessageModel>)model
{
    if (_delegate && [_delegate respondsToSelector:@selector(messageViewController:didSelectAvatarMessageModel:)]) {
        [_delegate messageViewController:self didSelectAvatarMessageModel:model];
        
        return;
    }
    
    _scrollToBottomWhenAppear = NO;
}

#pragma mark - EMChatToolbarDelegate

- (void)chatToolbarDidChangeFrameToHeight:(CGFloat)toHeight
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.tableView.frame;
        rect.origin.y = 0;
        rect.size.height = self.view.frame.size.height - toHeight;
        self.tableView.frame = rect;
    }];
    
    [self _scrollViewToBottom:NO];
}

- (void)inputTextViewWillBeginEditing:(EaseTextView *)inputTextView
{
    if (_menuController == nil) {
        _menuController = [UIMenuController sharedMenuController];
    }
    [_menuController setMenuItems:nil];
}

- (void)didSendText:(NSString *)text
{
    if (text && text.length > 0) {
        [self sendTextMessage:text];
        [self.atTargets removeAllObjects];
    }
}

- (void)didSendText:(NSString *)text withExt:(NSDictionary*)ext
{

    if (text && text.length > 0) {
        [self sendTextMessage:text withExt:ext];
    }
}

- (void)didStartRecordingVoiceAction:(UIView *)recordView
{
    if ([self.delegate respondsToSelector:@selector(messageViewController:didSelectRecordView:withEvenType:)]) {
        [self.delegate messageViewController:self didSelectRecordView:recordView withEvenType:EaseRecordViewTypeTouchDown];
    } else {
        if ([self.recordView isKindOfClass:[EaseRecordView class]]) {
            [(EaseRecordView *)self.recordView recordButtonTouchDown];
        }
    }
    
    [self _canRecordComplation:^(EMRecordResponse recordResponse) {
        switch (recordResponse) {
            case EMRequestRecord:
                
                break;
            case EMCanRecord:
            {
                _isRecording = YES;
                EaseRecordView *tmpView = (EaseRecordView *)recordView;
                tmpView.center = self.view.center;
                [self.view addSubview:tmpView];
                [self.view bringSubviewToFront:recordView];
                int x = arc4random() % 100000;
                NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
                NSString *fileName = [NSString stringWithFormat:@"%d%d",(int)time,x];
                
                [[EMCDDeviceManager sharedInstance] asyncStartRecordingWithFileName:fileName completion:^(NSError *error)
                 {
                     if (error) {
                         NSLog(@"%@",@"failure to start recording");
                         _isRecording = NO;
                     }
                 }];
                
            }
                break;
            case EMCanNotRecord:
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"record.failToPermission", @"No recording permission") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
                [alertView show];
            }
                break;
            default:
                break;
        }
    }];
}


- (void)didCancelRecordingVoiceAction:(UIView *)recordView
{
    if(_isRecording) {
        [[EMCDDeviceManager sharedInstance] cancelCurrentRecording];
        if ([self.delegate respondsToSelector:@selector(messageViewController:didSelectRecordView:withEvenType:)]) {
            [self.delegate messageViewController:self didSelectRecordView:recordView withEvenType:EaseRecordViewTypeTouchUpOutside];
        } else {
            if ([self.recordView isKindOfClass:[EaseRecordView class]]) {
                [(EaseRecordView *)self.recordView recordButtonTouchUpOutside];
            }
            [self.recordView removeFromSuperview];
        }
        
        _isRecording = NO;
    }
}

- (void)didFinishRecoingVoiceAction:(UIView *)recordView
{
    if (_isRecording) {
        if ([self.delegate respondsToSelector:@selector(messageViewController:didSelectRecordView:withEvenType:)]) {
            [self.delegate messageViewController:self didSelectRecordView:recordView withEvenType:EaseRecordViewTypeTouchUpInside];
        } else {
            if ([self.recordView isKindOfClass:[EaseRecordView class]]) {
                [(EaseRecordView *)self.recordView recordButtonTouchUpInside];
            }
            [self.recordView removeFromSuperview];
        }
        __weak typeof(self) weakSelf = self;
        [[EMCDDeviceManager sharedInstance] asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
            if (!error) {
                [weakSelf sendVoiceMessageWithLocalPath:recordPath duration:aDuration];
            }
            else {
                [weakSelf showHudInView:self.view hint:error.domain];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf hideHud];
                });
            }
        }];
        _isRecording = NO;
    }
}

- (void)didDragInsideAction:(UIView *)recordView
{
    if ([self.delegate respondsToSelector:@selector(messageViewController:didSelectRecordView:withEvenType:)]) {
        [self.delegate messageViewController:self didSelectRecordView:recordView withEvenType:EaseRecordViewTypeDragInside];
    } else {
        if ([self.recordView isKindOfClass:[EaseRecordView class]]) {
            [(EaseRecordView *)self.recordView recordButtonDragInside];
        }
    }
}

- (void)didDragOutsideAction:(UIView *)recordView
{
    if ([self.delegate respondsToSelector:@selector(messageViewController:didSelectRecordView:withEvenType:)]) {
        [self.delegate messageViewController:self didSelectRecordView:recordView withEvenType:EaseRecordViewTypeDragOutside];
    } else {
        if ([self.recordView isKindOfClass:[EaseRecordView class]]) {
            [(EaseRecordView *)self.recordView recordButtonDragOutside];
        }
    }
}

#pragma mark - EaseChatBarMoreViewDelegate

- (void)moreView:(EaseChatBarMoreView *)moreView didItemInMoreViewAtIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(messageViewController:didSelectMoreView:AtIndex:)]) {
        [self.delegate messageViewController:self didSelectMoreView:moreView AtIndex:index];
        return;
    }
}

- (void)moreViewTakePicAction:(EaseChatBarMoreView *)moreView{
    
    [PhotoManager shareManager].configureBlock = ^(id image){
        if(image == nil)
        {
            return ;
        }
        [self sendImageMessage:image];
    };
    [self presentViewController:[PhotoManager shareManager].camera animated:YES completion:nil];
}






//- (void)upLoadAvtar:(NSData *)image{
//    
//    [self showHudInView:self.view];
//    [BAIRUITECH_NetWorkManager FinanceLiveShow_uploadPic:@{@"imgFrom":@"2"} withFullUrlString:@"/base/imgUpload" withImageData:image withSuccessBlock:^(NSDictionary *object) {
//        
//        [self hideHud];
//
//        
//    } withFailureBlock:^(NSError *error) {
//        
//        [self showHint:error.description];
//    } withUpLoadProgress:^(float progress) {
//        
//    }];
//}


- (void)moreViewPhotoAction:(EaseChatBarMoreView *)moreView{
    
    [PhotoManager shareManager].configureBlock = ^(id image){
        if(image == nil)
        {
            return ;
        }
        [self sendImageMessage:image];
    };
    [self presentViewController:[PhotoManager shareManager].pickingImageView animated:YES completion:nil];
}

//- (void)moreViewVideoCallAction:(EaseChatBarMoreView *)moreView
//{
//    // Hide the keyboard
//    [self.chatToolbar endEditing:YES];
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_CALL object:@{@"chatter":self.conversation.conversationId, @"type":[NSNumber numberWithInt:1]}];
//}

//#pragma mark - EMLocationViewDelegate
//
//-(void)sendLocationLatitude:(double)latitude
//                  longitude:(double)longitude
//                 andAddress:(NSString *)address
//{
//    [self sendLocationMessageLatitude:latitude longitude:longitude andAddress:address];
//}

#pragma mark - Hyphenate

#pragma mark - EMChatManagerDelegate

//- (void)didReceiveMessages:(NSArray *)aMessages
//{
////    for (EMMessage *message in aMessages) {
////        if ([self.conversation.conversationId isEqualToString:message.conversationId]) {
////            [self addMessageToDataSource:message progress:nil];
////            
////            [self _sendHasReadResponseForMessages:@[message]
////                                           isRead:NO];
////            
////            if ([self _shouldMarkMessageAsRead])
////            {
////                [self.conversation markMessageAsReadWithId:message.messageId error:nil];
////            }
////        }
////    }
//}

- (void)didReceiveCmdMessages:(NSArray *)aCmdMessages
{
//    for (EMMessage *message in aCmdMessages) {
//        if ([self.conversation.conversationId isEqualToString:message.conversationId]) {
//            [self showHint:@"receive cmd message"];
//            break;
//        }
//    }
}

- (void)didReceiveHasDeliveredAcks:(NSArray *)aMessages
{
//    for(EMMessage *message in aMessages){
//        [self _updateMessageStatus:message];
//    }
}

- (void)didReceiveHasReadAcks:(NSArray *)aMessages
{
//    for (EMMessage *message in aMessages) {
//        if (![self.conversation.conversationId isEqualToString:message.conversationId]){
//            continue;
//        }
//        
//        __block id<IMessageModel> model = nil;
//        __block BOOL isHave = NO;
//        [self.dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
//         {
//             if ([obj conformsToProtocol:@protocol(IMessageModel)])
//             {
//                 model = (id<IMessageModel>)obj;
//                 if ([model.messageId isEqualToString:message.messageId])
//                 {
//                     model.message.isReadAcked = YES;
//                     isHave = YES;
//                     *stop = YES;
//                 }
//             }
//         }];
//        
//        if(!isHave){
//            return;
//        }
//        
//        if (_delegate && [_delegate respondsToSelector:@selector(messageViewController:didReceiveHasReadAckForModel:)]) {
//            [_delegate messageViewController:self didReceiveHasReadAckForModel:model];
//        }
//        else{
//            [self.tableView reloadData];
//        }
//    }
}

//- (void)didMessageStatusChanged:(EMMessage *)aMessage
//                          error:(EMError *)aError;
//{
//    [self _updateMessageStatus:aMessage];
//}
//
//- (void)didMessageAttachmentsStatusChanged:(EMMessage *)message
//                                     error:(EMError *)error{
//    if (!error) {
//        EMFileMessageBody *fileBody = (EMFileMessageBody*)[message body];
//        if ([fileBody type] == EMMessageBodyTypeImage) {
//            EMImageMessageBody *imageBody = (EMImageMessageBody *)fileBody;
//            if ([imageBody thumbnailDownloadStatus] == EMDownloadStatusSuccessed)
//            {
//                [self _reloadTableViewDataWithMessage:message];
//            }
//        }else if([fileBody type] == EMMessageBodyTypeVideo){
//            EMVideoMessageBody *videoBody = (EMVideoMessageBody *)fileBody;
//            if ([videoBody thumbnailDownloadStatus] == EMDownloadStatusSuccessed)
//            {
//                [self _reloadTableViewDataWithMessage:message];
//            }
//        }else if([fileBody type] == EMMessageBodyTypeVoice){
//            if ([fileBody downloadStatus] == EMDownloadStatusSuccessed)
//            {
//                [self _reloadTableViewDataWithMessage:message];
//            }
//        }
//        
//    }else{
//        
//    }
//}

#pragma mark - EMCDDeviceManagerProximitySensorDelegate

- (void)proximitySensorChanged:(BOOL)isCloseToUser
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if (isCloseToUser)
    {
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    } else {
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        if (self.playingVoiceModel == nil) {
            [[EMCDDeviceManager sharedInstance] disableProximitySensor];
        }
    }
    [audioSession setActive:YES error:nil];
}

#pragma mark - action

- (void)copyMenuAction:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        pasteboard.string = model.text;
    }
    
    self.menuIndexPath = nil;
}

- (void)deleteMenuAction:(id)sender
{
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        NSMutableIndexSet *indexs = [NSMutableIndexSet indexSetWithIndex:self.menuIndexPath.row];
        NSMutableArray *indexPaths = [NSMutableArray arrayWithObjects:self.menuIndexPath, nil];
        
//        [self.conversation deleteMessageWithId:model.message.messageId error:nil];
        [self.messsagesSource removeObject:model.message];
        
        if (self.menuIndexPath.row - 1 >= 0) {
            id nextMessage = nil;
            id prevMessage = [self.dataArray objectAtIndex:(self.menuIndexPath.row - 1)];
            if (self.menuIndexPath.row + 1 < [self.dataArray count]) {
                nextMessage = [self.dataArray objectAtIndex:(self.menuIndexPath.row + 1)];
            }
            if ((!nextMessage || [nextMessage isKindOfClass:[NSString class]]) && [prevMessage isKindOfClass:[NSString class]]) {
                [indexs addIndex:self.menuIndexPath.row - 1];
                [indexPaths addObject:[NSIndexPath indexPathForRow:(self.menuIndexPath.row - 1) inSection:0]];
            }
        }
        
        [self.dataArray removeObjectsAtIndexes:indexs];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
    
    self.menuIndexPath = nil;
}

#pragma mark - public

- (NSArray *)formatMessages:(NSArray *)messages
{
    NSMutableArray *formattedArray = [[NSMutableArray alloc] init];
    if ([messages count] == 0) {
        return formattedArray;
    }

    for (EMMessage *message in messages) {
        //Calculate time interval
        CGFloat interval = (self.messageTimeIntervalTag - message.timestamp) / 1000;
        if (self.messageTimeIntervalTag < 0 || interval > 60 || interval < -60) {
            NSDate *messageDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)message.timestamp];
            NSString *timeStr = @"";
            
            if (_dataSource && [_dataSource respondsToSelector:@selector(messageViewController:stringForDate:)]) {
                timeStr = [_dataSource messageViewController:self stringForDate:messageDate];
            }
            else{
                timeStr = [messageDate formattedTime];
            }
            [formattedArray addObject:timeStr];
            self.messageTimeIntervalTag = message.timestamp;
        }
        
        //Construct message model
        id<IMessageModel> model = nil;
        if (_dataSource && [_dataSource respondsToSelector:@selector(messageViewController:modelForMessage:)]) {
            model = [_dataSource messageViewController:self modelForMessage:message];
        }
        else{
            model = [[EaseMessageModel alloc] initWithMessage:message];
            model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
            model.failImageName = @"EaseUIResource.bundle/imageDownloadFail";
        }
        
        if (model) {
            [formattedArray addObject:model];
        }
    }
    
    return formattedArray;
}

-(void)addMessageToDataSource:(EMMessage *)message
                     progress:(id)progress
{
    [self.messsagesSource addObject:message];
    
    __weak EaseMessageViewController *weakSelf = self;
    dispatch_async(_messageQueue, ^{
        NSArray *messages = [weakSelf formatMessages:@[message]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.dataArray addObjectsFromArray:messages];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[weakSelf.dataArray count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        });
    });
}

#pragma mark - public
- (void)tableViewDidTriggerHeaderRefresh
{
    self.messageTimeIntervalTag = -1;
    [self loadMore];
//    NSString *messageId = nil;
//    if ([self.messsagesSource count] > 0) {
//        messageId = [(EMMessage *)self.messsagesSource.firstObject messageId];
//    }
//    else {
//        messageId = nil;
//    }
//    [self _loadMessagesBefore:messageId count:self.messageCountOfPage append:YES];
//
//    [self tableViewDidFinishTriggerHeader:YES reload:YES];
}

- (void)loadMore{
    
    
    
    _pageN += 1;
    
    [self getData];
}

- (void)getData{
    
    
    __weak typeof(self) weakSelf = self;
    void (^refresh)(NSArray *messages) = ^(NSArray *messages) {
        dispatch_async(_messageQueue, ^{
            //Format the message
            NSArray *formattedMessages = [weakSelf formatMessages:messages];
            
            //Refresh the page
            dispatch_async(dispatch_get_main_queue(), ^{
                EaseMessageViewController *strongSelf = weakSelf;
                if (strongSelf) {
                    NSInteger scrollToIndex = 0;
                    if (1) {
                        [strongSelf.messsagesSource insertObjects:messages atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [messages count])]];
                        
                        //Combine the message
                        id object = [strongSelf.dataArray firstObject];
                        if ([object isKindOfClass:[NSString class]]) {
                            NSString *timestamp = object;
                            [formattedMessages enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id model, NSUInteger idx, BOOL *stop) {
                                if ([model isKindOfClass:[NSString class]] && [timestamp isEqualToString:model]) {
                                    [strongSelf.dataArray removeObjectAtIndex:0];
                                    *stop = YES;
                                }
                            }];
                        }
                        scrollToIndex = [strongSelf.dataArray count];
                        [strongSelf.dataArray insertObjects:formattedMessages atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [formattedMessages count])]];
                    }
                    else {
                        [strongSelf.messsagesSource removeAllObjects];
                        [strongSelf.messsagesSource addObjectsFromArray:messages];
                        
                        [strongSelf.dataArray removeAllObjects];
                        [strongSelf.dataArray addObjectsFromArray:formattedMessages];
                    }
                    
                    //                    EMMessage *latest = [strongSelf.messsagesSource lastObject];
                    //                    strongSelf.messageTimeIntervalTag = latest.timestamp;
                    
                    [strongSelf.tableView reloadData];
                    
                    [strongSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.dataArray count] - scrollToIndex - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }
            });
            
            //re-download all messages that are not successfully downloaded
            //            for (EMMessage *message in messages)
            //            {
            //                [weakSelf _downloadMessageAttachments:message];
            //            }
            
            //send the read acknoledgement
            //            [weakSelf _sendHasReadResponseForMessages:messages
            //                                               isRead:NO];
        });
    };
    
    
    BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
    
    [BAIRUITECH_NetWorkManager FinanceLiveShow_chatHis:@{@"userId":user.userId,@"userIdB":self.toUserId,@"pageNo":@(_pageN),@"pageSize":@"10"} withSuccessBlock:^(NSDictionary *object) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if([object[@"ret"] intValue] == 0){
            
            NSLog(@"ss");
            NSArray *chatList = object[@"data"][@"chatList"];
            BAIRUITECH_BRAccount *account = [BAIRUITECH_BRAccoutTool account];
            NSMutableArray *messages = [NSMutableArray array];
            for (NSDictionary *dic in chatList) {
                
                int type = [dic[@"chatContentType"] intValue];
                if (type == 1) {
                    
                    EMMessage *message = [[EMMessage alloc]init];
                    EMMessageBody *body = [EMMessageBody new];
                    body.type = EMMessageBodyTypeText;
                    message.body = body;
                    message.text = dic[@"chatContent"];
                    message.from = dic[@"userNameA"];
                    NSString *senderId = [NSString stringWithFormat:@"%@",dic[@"userIdA"]];
                    message.direction = [senderId isEqualToString:account.userId]?EMMessageDirectionSend:EMMessageDirectionReceive;
                    long long time = [[NSString stringWithFormat:@"%@",dic[@"createTime"]] longLongValue];
                    message.timestamp = time;
                    [messages addObject:message];
                }

                else if (type ==2){
                    
                    EMMessage *message = [[EMMessage alloc]init];
                    EMMessageBody *body = [EMMessageBody new];
                    body.type = EMMessageBodyTypeImage;
                    message.body = body;
                    message.imageURL = [NSString stringWithFormat:@"%@",dic[@"chatContent"]];
                    message.from = dic[@"userNameA"];
                    NSString *senderId = [NSString stringWithFormat:@"%@",dic[@"userIdA"]];
                    message.direction = [senderId isEqualToString:account.userId]?EMMessageDirectionSend:EMMessageDirectionReceive;
                    long long time = [[NSString stringWithFormat:@"%@",dic[@"createTime"]] longLongValue];
                    message.timestamp = time;
                    [messages addObject:message];
                }
                else if (type == 3){
                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
                    
//                        BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
                        EMMessage *message = [[EMMessage alloc]init];
                        EMMessageBody *body = [EMMessageBody new];
                        body.type = EMMessageBodyTypeVoice;
                        message.body = body;
                        message.from = dic[@"userNameA"];
                        NSArray *ary = [dic[@"chatContent"] componentsSeparatedByString:@"&"];
                        NSData *data = [NSData dataWithContentsOfURL:
                                        [NSURL URLWithString:[NSString stringWithFormat:@"%@",ary.firstObject]]];
                        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.amr",dic[@"time"]]];
                        [data writeToFile:filePath atomically:YES];
                        message.voicePath = filePath;
                        message.duration = [ary.lastObject floatValue];;
                        NSString *senderId = [NSString stringWithFormat:@"%@",dic[@"userIdA"]];
                        message.direction = [senderId isEqualToString:account.userId]?EMMessageDirectionSend:EMMessageDirectionReceive;
                        long long time = [[NSString stringWithFormat:@"%@",dic[@"createTime"]] longLongValue];
                        message.timestamp = time;
                        [messages addObject:message];
//                    });
                }
                
            }
            
            if ([messages count]) {
                
                refresh(messages);
            }
            
            
            
            
        }else{
            
            [BAIRUITECH_BRTipView showTipTitle:object[@"msg"] delay:1];
        }
        
    } withFailureBlock:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
}


#pragma mark - send message

- (void)_refreshAfterSentMessage:(id)aMessage
{
//    if ([self.messsagesSource count] && [EMClient sharedClient].options.sortMessageByServerTime) {
//        NSString *msgId = aMessage.messageId;
//        EMMessage *last = self.messsagesSource.lastObject;
//        if ([last isKindOfClass:[EMMessage class]]) {
//            
//            __block NSUInteger index = NSNotFound;
//            index = NSNotFound;
//            [self.messsagesSource enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(EMMessage *obj, NSUInteger idx, BOOL *stop) {
//                if ([obj isKindOfClass:[EMMessage class]] && [obj.messageId isEqualToString:msgId]) {
//                    index = idx;
//                    *stop = YES;
//                }
//            }];
//            if (index != NSNotFound) {
//                [self.messsagesSource removeObjectAtIndex:index];
//                [self.messsagesSource addObject:aMessage];
//                
//                //格式化消息
//                self.messageTimeIntervalTag = -1;
//                NSArray *formattedMessages = [self formatMessages:self.messsagesSource];
//                [self.dataArray removeAllObjects];
//                [self.dataArray addObjectsFromArray:formattedMessages];
//                [self.tableView reloadData];
//                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.dataArray count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//                return;
//            }
//        }
//    }
    [self.tableView reloadData];
}

- (void)_sendMessage:(EMMessage *)message
{
//    if (self.conversation.type == EMConversationTypeGroupChat){
//        message.chatType = EMChatTypeGroupChat;
//    }
//    else if (self.conversation.type == EMConversationTypeChatRoom){
//        message.chatType = EMChatTypeChatRoom;
//    }
//    
//    [self addMessageToDataSource:message
//                        progress:nil];
    
//    __weak typeof(self) weakself = self;
//    [[EMClient sharedClient].chatManager sendMessage:message progress:^(int progress) {
//        if (weakself.dataSource && [weakself.dataSource respondsToSelector:@selector(messageViewController:updateProgress:messageModel:messageBody:)]) {
//            [weakself.dataSource messageViewController:weakself updateProgress:progress messageModel:nil messageBody:message.body];
//        }
//    } completion:^(EMMessage *aMessage, EMError *aError) {
//        if (!aError) {
//            [weakself _refreshAfterSentMessage:aMessage];
//        }
//        else {
//            [weakself.tableView reloadData];
//        }
//    }];
}

- (void)sendTextMessage:(NSString *)text
{
    NSDictionary *ext = nil;
//    if (self.conversation.type == EMConversationTypeGroupChat) {
//        NSArray *targets = [self _searchAtTargets:text];
//        if ([targets count]) {
//            __block BOOL atAll = NO;
//            [targets enumerateObjectsUsingBlock:^(NSString *target, NSUInteger idx, BOOL *stop) {
//                if ([target compare:kGroupMessageAtAll options:NSCaseInsensitiveSearch] == NSOrderedSame) {
//                    atAll = YES;
//                    *stop = YES;
//                }
//            }];
//            if (atAll) {
//                ext = @{kGroupMessageAtList: kGroupMessageAtAll};
//            }
//            else {
//                ext = @{kGroupMessageAtList: targets};
//            }
//        }
//    }
    [self sendTextMessage:text withExt:ext];
}

- (void)sendTextMessage:(NSString *)text withExt:(NSDictionary*)ext
{
//    EMMessage *message = [EaseSDKHelper sendTextMessage:text
//                                                     to:self.conversation.conversationId
//                                            messageType:[self _messageTypeFromConversationType]
//                                             messageExt:ext];
//    [self.socket sendTextMsg:text targetUserId:self.toUserId];
    
    [[FabricSocket shareInstances]sendTextMsg:text targetUserId:self.toUserId roomId:@"0"];
}


//
//- (void)sendImageMessageWithData:(NSData *)imageData
//{
//    id progress = nil;
//    if (_dataSource && [_dataSource respondsToSelector:@selector(messageViewController:progressDelegateForMessageBodyType:)]) {
////        progress = [_dataSource messageViewController:self progressDelegateForMessageBodyType:EMMessageBodyTypeImage];
//    }
//    else{
//        progress = self;
//    }
//    
////    EMMessage *message = [EaseSDKHelper sendImageMessageWithImageData:imageData
////                                                                   to:self.conversation.conversationId
////                                                          messageType:[self _messageTypeFromConversationType]
////                                                           messageExt:nil];
////    [self _sendMessage:message];
//}

- (void)sendImageMessage:(UIImage *)image
{
    BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
    EMMessage *message = [[EMMessage alloc]init];
    EMMessageBody *body = [EMMessageBody new];
    body.type = EMMessageBodyTypeImage;
    message.body = body;
    message.from = user.nickName;
    message.image = image;
    message.avatar = [NSString stringWithFormat:@"%@%@",ImageURL,user.userLogo];
    message.direction = EMMessageDirectionSend;
    NSDate *date = [NSDate date];
    message.timestamp = date.timeIntervalSince1970;

    [self addMessageToDataSource:message progress:nil];

    NSData *data  = UIImageJPEGRepresentation(image, 0.1);
    [BAIRUITECH_NetWorkManager FinanceLiveShow_uploadPic:@{@"imgFrom":@"2"} withFullUrlString:@"/base/imgUpload" withImageData:data withSuccessBlock:^(NSDictionary *object) {
        
//        [self hideHud];
        
        NSLog(@"uploadPic --------%@",object);
        NSString *imgURL = [NSString stringWithFormat:@"%@%@",object[@"data"][@"imgUrlPre"],object[@"data"][@"imgUrl"]];
        [[FabricSocket shareInstances]sendImage:imgURL targetUserId:self.toUserId roomId:@"0"];
//        [[FabricSocket shareInstances]sendTextMsg:text targetUserId:self.toUserId roomId:@"0"];
        
    } withFailureBlock:^(NSError *error) {
        
        NSLog(@"uploadPicerror --------%@",error);
//        [self showHint:error.description];
    } withUpLoadProgress:^(float progress) {
        NSLog(@"uploadProgress --------%f",progress);

    }];
    
//    id progress = nil;
//    if (_dataSource && [_dataSource respondsToSelector:@selector(messageViewController:progressDelegateForMessageBodyType:)]) {
////        progress = [_dataSource messageViewController:self progressDelegateForMessageBodyType:EMMessageBodyTypeImage];
//    }
//    else{
//        progress = self;
//    }
//    
////    EMMessage *message = [EaseSDKHelper sendImageMessageWithImage:image
////                                                               to:self.conversation.conversationId
////                                                      messageType:[self _messageTypeFromConversationType]
////                                                       messageExt:nil];
////    [self _sendMessage:message];
}

- (void)sendVoiceMessageWithLocalPath:(NSString *)localPath
                             duration:(NSInteger)duration
{
    
    BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
    EMMessage *message = [[EMMessage alloc]init];
    EMMessageBody *body = [EMMessageBody new];
    body.type = EMMessageBodyTypeVoice;
    message.body = body;
    message.from = user.nickName;
    message.voicePath = localPath;
    message.duration = duration;
    message.avatar = [NSString stringWithFormat:@"%@%@",ImageURL,user.userLogo];
    message.direction = EMMessageDirectionSend;
    NSDate *date = [NSDate date];
    message.timestamp = date.timeIntervalSince1970;
    [self addMessageToDataSource:message progress:nil];
    
    NSData *data  = [[NSData alloc]initWithContentsOfFile:localPath];;
    [BAIRUITECH_NetWorkManager FinanceLiveShow_uploadVoice:@{@"imgFrom":@"2"} withFullUrlString:@"/base/imgUpload" withImageData:data withSuccessBlock:^(NSDictionary *object) {
        
        //        [self hideHud];
        
        NSLog(@"uploadVoice --------%@",object);
        NSString *VoiceURL = [NSString stringWithFormat:@"%@%@&%ld",object[@"data"][@"imgUrlPre"],object[@"data"][@"imgUrl"],(long)duration];
        [[FabricSocket shareInstances]sendVoice:VoiceURL targetUserId:self.toUserId roomId:@"0"];
        //        [[FabricSocket shareInstances]sendTextMsg:text targetUserId:self.toUserId roomId:@"0"];
        
    } withFailureBlock:^(NSError *error) {
        
        NSLog(@"uploadPicerror --------%@",error);
        //        [self showHint:error.description];
    } withUpLoadProgress:^(float progress) {
        NSLog(@"uploadProgress --------%f",progress);
        
    }];
    
    
    
    
    
//    id progress = nil;
//    if (_dataSource && [_dataSource respondsToSelector:@selector(messageViewController:progressDelegateForMessageBodyType:)]) {
////        progress = [_dataSource messageViewController:self progressDelegateForMessageBodyType:EMMessageBodyTypeVoice];
//    }
//    else{
//        progress = self;
//    }
    
//    EMMessage *message = [EaseSDKHelper sendVoiceMessageWithLocalPath:localPath
//                                                             duration:duration
//                                                                   to:self.conversation.conversationId
//                                                          messageType:[self _messageTypeFromConversationType]
//                                                           messageExt:nil];
//    [self _sendMessage:message];
}

//- (void)sendVideoMessageWithURL:(NSURL *)url
//{
//    id progress = nil;
//    if (_dataSource && [_dataSource respondsToSelector:@selector(messageViewController:progressDelegateForMessageBodyType:)]) {
////        progress = [_dataSource messageViewController:self progressDelegateForMessageBodyType:EMMessageBodyTypeVideo];
//    }
//    else{
//        progress = self;
//    }
//    
////    EMMessage *message = [EaseSDKHelper sendVideoMessageWithURL:url
////                                                             to:self.conversation.conversationId
////                                                    messageType:[self _messageTypeFromConversationType]
////                                                     messageExt:nil];
////    [self _sendMessage:message];
//}

- (void)sendFileMessageWith:(id)message {
    [self _sendMessage:message];
}

#pragma mark - notifycation

#pragma mark FabricSocketNotification
-(void)didReceiveMessage:(NSNotification *)notifi{
    
    
    NSDictionary *message = [self dictionaryWithJsonString:notifi.object];
    if (!message) {
        
        return;
    }
    NSString *reciveId = [NSString stringWithFormat:@"%@",message[@"receiverid"]];
    NSString *sendId = [NSString stringWithFormat:@"%@",message[@"senderid"]];
    BAIRUITECH_BRAccount *account = [BAIRUITECH_BRAccoutTool account];
    if (![reciveId isEqualToString:@"0"]) {
        
        if (([reciveId isEqualToString:self.toUserId] && [sendId isEqualToString:account.userId]) || ([reciveId isEqualToString:account.userId] && [sendId isEqualToString:self.toUserId])) {
         
            [self recivePrivateMsg:message];
            
        }
        
        return;
    }
    
}


- (void)recivePrivateMsg:(NSDictionary *)msg{
    
    
    NSString *cmd = [NSString stringWithFormat:@"%@",msg[@"cmd"]];
    NSString *senderId = [NSString stringWithFormat:@"%@",msg[@"senderid"]];
    BAIRUITECH_BRAccount *account = [BAIRUITECH_BRAccoutTool account];
    if ([cmd isEqualToString:@"501"]) {
        
        //        NSDictionary *gift = [self dictionaryWithJsonString:msg[@"content"]];
        //        [self showGiftWithDic:gift];
        //        return;
    }
    
    if ([cmd isEqualToString:@"601"]) {
        
        
        int type = [[NSString stringWithFormat:@"%@",msg[@"type"]] intValue];
        NSDictionary *content = [self dictionaryWithJsonString:msg[@"content"]];
        if (type <=1) {
            
            EMMessage *message = [[EMMessage alloc]init];
            EMMessageBody *body = [EMMessageBody new];
            body.type = EMMessageBodyTypeText;
            message.body = body;
            message.text = content[@"msg"];
            message.from = content[@"nickName"];
            message.avatar = [NSString stringWithFormat:@"%@%@",ImageURL,content[@"userLogo"]];
            message.direction = [senderId isEqualToString:account.userId]?EMMessageDirectionSend:EMMessageDirectionReceive;
            message.timestamp = [[NSString stringWithFormat:@"%@",msg[@"time"]] longLongValue];
            [self addMessageToDataSource:message progress:nil];
        }
        else if (type == 2){
            
            EMMessage *message = [[EMMessage alloc]init];
            EMMessageBody *body = [EMMessageBody new];
            body.type = EMMessageBodyTypeImage;
            message.body = body;
            message.from =  content[@"nickName"];
            message.imageURL = [NSString stringWithFormat:@"%@",content[@"msg"]];
            message.avatar = [NSString stringWithFormat:@"%@%@",ImageURL,content[@"userLogo"]];
            message.direction = EMMessageDirectionReceive;
            message.timestamp = [[NSString stringWithFormat:@"%@",msg[@"time"]] longLongValue];
            [self addMessageToDataSource:message progress:nil];
        }
        else if (type == 3){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
                EMMessage *message = [[EMMessage alloc]init];
                EMMessageBody *body = [EMMessageBody new];
                body.type = EMMessageBodyTypeVoice;
                message.body = body;
                message.from = content[@"nickName"];
                NSArray *ary = [content[@"msg"] componentsSeparatedByString:@"&"];
                
                
                NSData *data = [NSData dataWithContentsOfURL:
                                [NSURL URLWithString:[NSString stringWithFormat:@"%@",ary.firstObject]]];
                NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.amr",msg[@"time"]]];
                [data writeToFile:filePath atomically:YES];
                message.voicePath = filePath;
                message.duration = [ary.lastObject floatValue];;
                message.avatar = [NSString stringWithFormat:@"%@%@",ImageURL,user.userLogo];
                message.direction = EMMessageDirectionReceive;
                message.timestamp = [[NSString stringWithFormat:@"%@",msg[@"time"]] longLongValue];
                [self addMessageToDataSource:message progress:nil];
            });
            
        }
        
    }
    
    
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)str
{
    if (str == nil) {
        return nil;
    }
    
    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        //  NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

- (void)didBecomeActive
{
    self.messageTimeIntervalTag = -1;
    self.dataArray = [[self formatMessages:self.messsagesSource] mutableCopy];
    [self.tableView reloadData];
    
//    if (self.isViewDidAppear)
//    {
//        NSMutableArray *unreadMessages = [NSMutableArray array];
//        for (EMMessage *message in self.messsagesSource)
//        {
//            if ([self shouldSendHasReadAckForMessage:message read:NO])
//            {
//                [unreadMessages addObject:message];
//            }
//        }
//        if ([unreadMessages count])
//        {
//            [self _sendHasReadResponseForMessages:unreadMessages isRead:YES];
//        }
//        
////        [_conversation markAllMessagesAsRead:nil];
//        if (self.dataSource && [self.dataSource respondsToSelector:@selector(messageViewControllerMarkAllMessagesAsRead:)]) {
//            [self.dataSource messageViewControllerMarkAllMessagesAsRead:self];
//        }
//    }
}

- (void)hideImagePicker
{
//    if (_imagePicker && [EaseSDKHelper shareHelper].isShowingimagePicker) {
//        [_imagePicker dismissViewControllerAnimated:NO completion:nil];
//    }
}

#pragma mark - private
- (void)_reloadTableViewDataWithMessage:(id)message
{
    if (1)
    {
//        for (int i = 0; i < self.dataArray.count; i ++) {
//            id object = [self.dataArray objectAtIndex:i];
//            if ([object isKindOfClass:[EaseMessageModel class]]) {
//                id<IMessageModel> model = object;
//                if ([message.messageId isEqualToString:model.messageId]) {
//                    id<IMessageModel> model = nil;
//                    if (self.dataSource && [self.dataSource respondsToSelector:@selector(messageViewController:modelForMessage:)]) {
//                        model = [self.dataSource messageViewController:self modelForMessage:message];
//                    }
//                    else{
//                        model = [[EaseMessageModel alloc] initWithMessage:message];
//                        model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
//                        model.failImageName = @"imageDownloadFail";
//                    }
//                    
//                    [self.tableView beginUpdates];
//                    [self.dataArray replaceObjectAtIndex:i withObject:model];
//                    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//                    [self.tableView endUpdates];
//                    break;
//                }
//            }
//        }
    }
}

- (void)_updateMessageStatus:(id)aMessage
{
    BOOL isChatting = 1;
//    if (aMessage && isChatting) {
//        id<IMessageModel> model = nil;
//        if (_dataSource && [_dataSource respondsToSelector:@selector(messageViewController:modelForMessage:)]) {
//            model = [_dataSource messageViewController:self modelForMessage:aMessage];
//        }
//        else{
//            model = [[EaseMessageModel alloc] initWithMessage:aMessage];
//            model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
//            model.failImageName = @"imageDownloadFail";
//        }
//        if (model) {
//            __block NSUInteger index = NSNotFound;
//            [self.dataArray enumerateObjectsUsingBlock:^(EaseMessageModel *model, NSUInteger idx, BOOL *stop){
//                if ([model conformsToProtocol:@protocol(IMessageModel)]) {
//                    if ([aMessage.messageId isEqualToString:model.message.messageId])
//                    {
//                        index = idx;
//                        *stop = YES;
//                    }
//                }
//            }];
//            
//            if (index != NSNotFound)
//            {
//                [self.dataArray replaceObjectAtIndex:index withObject:model];
//                [self.tableView beginUpdates];
//                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//                [self.tableView endUpdates];
//            }
//        }
//    }
}

- (NSArray*)_searchAtTargets:(NSString*)text
{
    NSMutableArray *targets = nil;
    if (text.length > 1) {
        targets = [NSMutableArray array];
        NSArray *splits = [text componentsSeparatedByString:@"@"];
        if ([splits count]) {
            for (NSString *split in splits) {
                if (split.length) {
                    NSString *atALl = @"all";
                    if (split.length >= atALl.length && [split compare:atALl options:NSCaseInsensitiveSearch range:NSMakeRange(0, atALl.length)] == NSOrderedSame) {
                        [targets removeAllObjects];
//                        [targets addObject:kGroupMessageAtAll];
                        return targets;
                    }
                    for (EaseAtTarget *target in self.atTargets) {
                        if ([target.userId length]) {
                            if ([split hasPrefix:target.userId] || (target.nickname && [split hasPrefix:target.nickname])) {
                                [targets addObject:target.userId];
                                [self.atTargets removeObject:target];
                                break;
                            }
                        }
                    }
                }
            }
        }
    }
    return targets;
}


@end
