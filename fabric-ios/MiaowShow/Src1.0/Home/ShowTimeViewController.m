//
//  ShowTimeViewController.m
//  MiaowShow
//
//  Created by ALin on 16/6/14.
//  Copyright © 2016年 ALin. All rights reserved.
//

#import "ShowTimeViewController.h"
#import <LFLiveKit.h>
#import "ALinBottomToolView.h"
#import "ALinLiveAnchorView.h"
#import "ALinCatEarView.h"
#import "ALinLive.h"
#import "ALinUser.h"
//#import "UIImage+ALinExtension.h"
#import "ALinLiveEndView.h"

#import <SDWebImageDownloader.h>
#import <BarrageRenderer.h>
#import "BAIRUITECH_GiftViewController.h"
#import "BAIRUITECH_AudienceSendGiftView.h"
#import "MsgViewController.h"
#import "BAIRUITECH_GrowingInputView.h"
#import "FabricSocket.h"
#import "BRLoginNavigationController.h"
#import "BRLoginViewController.h"
#import "FabricWebViewController.h"
#import "LiveSliderViewController.h"
#import "PrivateListController.h"
#import "ShareView.h"
@interface ShowTimeViewController () <LFLiveSessionDelegate,BAIRUITECH_GrowingInputViewDelegate,BAIRUITECH_giftViewControllerDelegate>

/** RTMP地址 */
@property (nonatomic, copy) NSString *rtmpUrl;
@property (nonatomic, strong) LFLiveSession *session;
@property (nonatomic, weak) UIView *livingPreView;



///** 底部的工具栏 */
//@property(nonatomic, weak) ALinBottomToolView *toolView;
/** 顶部主播相关视图 */
@property(nonatomic, weak) ALinLiveAnchorView *anchorView;


/** 底部的工具栏 */
@property(nonatomic, weak) ALinBottomToolView *toolView;

@property (nonatomic, weak) ALinLiveEndView *endView;

@property (weak, nonatomic) BAIRUITECH_GrowingInputView *growingInputView;//输入框
@property (nonatomic, strong) UIButton *publicChatBtn;


@property(nonatomic, strong) BAIRUITECH_GiftViewController *giftVC;
@property(nonatomic, strong) UIButton *backgroundButton;
@property (nonatomic, strong) UIView *giftView;

@property (nonatomic, strong) MsgViewController *msgVC;
@property (nonatomic, weak) UITableView *msgTable;
@property (nonatomic, strong) NSMutableArray *msgList;

@property (nonatomic, strong) ShareView *shareView;
//@property (nonatomic, strong) FabricSocket *socket;

@property (nonatomic, strong) LiveSliderViewController *sliderVC;
@property (nonatomic, strong) PrivateListController *privateVC;

@property (nonatomic, strong) UIButton *switchCamera;

@end

@implementation ShowTimeViewController

- (UIButton *)switchCamera{
    
    if (!_switchCamera) {
        
        _switchCamera = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 40, 50, 50)];
        [_switchCamera setImage:[UIImage imageNamed:@"镜头切换"] forState:UIControlStateNormal];
        [_switchCamera addTarget:self action:@selector(switchAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_switchCamera];
    }
    return _switchCamera;
}

- (ShareView *)shareView{
    
    if (!_shareView) {
        
        _shareView = [[ShareView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
    }
    return _shareView;
}

-(PrivateListController *)privateVC{
    
    if (!_privateVC) {
        
        _privateVC = [[PrivateListController alloc]init];
        _privateVC.view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
//        _privateVC.socket = self.socket;
    }
    return _privateVC;
}


-(LiveSliderViewController *)sliderVC{
    
    if (!_sliderVC) {
        
        _sliderVC = [[LiveSliderViewController alloc]init];
        _sliderVC.view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        __weak typeof(self) weak = self;
        [_sliderVC setDidSelect:^(UIButton *btn){
            
//            [weak showSlider:NO];
            if (btn.tag == 1) {
                
                [weak openLight:btn];
            }else if (btn.tag == 2){
                
               
                [weak switchAction];
               
            }else if (btn.tag == 3){
                
                

            };
        }];
        [_sliderVC setHideBlock:^{
            
            [weak showSlider:NO];
        }];
        
    }
    return _sliderVC;
}

- (void)switchAction
{
    AVCaptureDevicePosition devicePositon = self.session.captureDevicePosition;
    self.session.captureDevicePosition = (devicePositon == AVCaptureDevicePositionBack) ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
    
}
- (void)openLight:(UIButton *)btn{
    
    
//    sender.selected = !sender.selected;
//    if (sender.isSelected == YES) { //打开闪光灯
//        AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//        NSError *error = nil;
//        
//        if ([captureDevice hasTorch]) {
//            BOOL locked = [captureDevice lockForConfiguration:&error];
//            if (locked) {
//                captureDevice.torchMode = AVCaptureTorchModeOn;
//                [captureDevice unlockForConfiguration];
//            }
//        }
//    }else{//关闭闪光灯
//        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//        if ([device hasTorch]) {
//            [device lockForConfiguration:nil];
//            [device setTorchMode: AVCaptureTorchModeOff];
//            [device unlockForConfiguration];
//        }
//    }
    
    AVCaptureDevice *device  = self.session.videoCaptureSource.videoCamera.inputCamera;
    
    //修改前必须先锁定
    [device lockForConfiguration:nil];
    
    //必须判定是否有闪光灯，否则如果没有闪光灯会崩溃
    if ([device hasFlash]) {
        
        if (device.flashMode == AVCaptureFlashModeOff) {
            device.flashMode = AVCaptureFlashModeOn;
            device.torchMode = AVCaptureTorchModeOn;
            btn.selected = YES;
        } else if (device.flashMode == AVCaptureFlashModeOn) {
            device.flashMode = AVCaptureFlashModeOff;
            device.torchMode = AVCaptureTorchModeOff;
            btn.selected = NO;
            
        }
        
    }
    else{
        
        [self showHint:@"前置摄像不支持打开闪光灯"];
    }
    [device unlockForConfiguration];
}



- (void)showSlider:(BOOL)show{
    
    CGFloat y = show?0:SCREEN_HEIGHT;
    [UIView animateWithDuration:0.5 animations:^{
        
        _sliderVC.view.frame = CGRectMake(0, y, SCREEN_WIDTH, SCREEN_HEIGHT);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)showPrivate:(BOOL)show{
    
    CGFloat y = show?0:SCREEN_HEIGHT;
    [UIView animateWithDuration:0.5 animations:^{
        
        _privateVC.view.frame = CGRectMake(0, y, SCREEN_WIDTH, SCREEN_HEIGHT);
        [_privateVC.chatVC.view endEditing:YES];
        
    } completion:^(BOOL finished) {
        
    }];
}




- (UIButton *)publicChatBtn{
    
    if (!_publicChatBtn) {
        
        self.publicChatBtn = [[UIButton alloc]init];
        [self.publicChatBtn setTintColor:[UIColor whiteColor]];
        self.publicChatBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        
        [self.publicChatBtn setBackgroundImage:[UIImage imageNamed:@"公聊-背景"] forState:UIControlStateNormal];
        [self.view addSubview:self.publicChatBtn];
        [self.publicChatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(10);
            make.bottom.equalTo(self.view).offset(-20);
            
            make.size.mas_equalTo(CGSizeMake(97, 28));
        }];
        @weakify(self)
        [self.publicChatBtn bk_addEventHandler:^(UIButton *sender) {
            @strongify(self)
            [self showInputView];

        } forControlEvents:UIControlEventTouchUpInside];
        
        

    }
    return _publicChatBtn;
}

//展示输入框
- (void)showInputView {
    if (self.growingInputView == nil) {//输入框懒加载
        BAIRUITECH_GrowingInputView *growingInputView = [[BAIRUITECH_GrowingInputView alloc] initWithFrame:CGRectZero];
        self.growingInputView  = growingInputView;
        
        self.growingInputView.frame = CGRectMake(0, SCREEN_HEIGHT - [BAIRUITECH_GrowingInputView defaultHeight], SCREEN_WIDTH, [BAIRUITECH_GrowingInputView defaultHeight]);
        self.growingInputView.placeholder = @"我来说点什么吧~";
        self.growingInputView.delegate = self;
        self.growingInputView.parentView = self.view;
        
        [self.view addSubview:self.growingInputView];
    }
    self.growingInputView.hidden = NO;
    //在键盘下面插入一个退键盘的button,点击背景button退键盘
    UIButton *backgroundButton = [[UIButton alloc] init];
    [self.view insertSubview:backgroundButton belowSubview:self.growingInputView];
    [backgroundButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.equalTo(self.view);
    }];
    @weakify(self)
    [backgroundButton bk_addEventHandler:^(id sender) {
        @strongify(self)
        //退键盘,隐藏输入框
        [self.view endEditing:YES];
        self.growingInputView.hidden = YES;
        [backgroundButton removeFromSuperview];
    } forControlEvents:UIControlEventTouchUpInside];
    //让组件内部的textView成为第一响应者
    [self.growingInputView activateInput];
    
}
#pragma mark BAIRUITECH_GrowingInputViewDelegate
//点击发送按钮
- (BOOL)growingInputView:(BAIRUITECH_GrowingInputView *)growingInputView didSendText:(NSString *)text
{
    if (text.length>120) {
        [BAIRUITECH_BRTipView showTipTitle:@"提示:消息最多120个字" delay:1];
        return NO;
    }
    if (text.length < 1) {
        [BAIRUITECH_BRTipView showTipTitle:@"提示:消息不能为空" delay:1];
        return NO;
    }
    
    BAIRUITECH_BRAccount * acount=  [BAIRUITECH_BRAccoutTool account];
    NSString *userName=@" ";
    if (acount !=nil && acount.nickName != nil) {
        userName=  acount.nickName;
    }
    
    
//    [self.socket sendTextMsg:text targetUserId:@"0"];
    [[FabricSocket shareInstances]sendTextMsg:text targetUserId:@"0" roomId:[NSString stringWithFormat:@"%lu",(unsigned long)self.live.roomId]];
    self.growingInputView.text=@"";
    return YES;
    
}

- (MsgViewController *)msgVC{
    
    if (!_msgVC) {
        
        self.msgVC = [MsgViewController new];
        [self addChildViewController:self.msgVC];
        [self.view addSubview:self.msgVC.view];
        self.msgTable = self.msgVC.tableView;
//        self.msgTable.backgroundColor = [UIColor redColor];
        [self.msgVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@10);
            make.top.equalTo(@150);
            make.height.offset(SCREEN_HEIGHT - 100 - 100);
            make.width.offset(SCREEN_WIDTH/2);
        }];
    }
    return _msgVC;
}

- (ALinBottomToolView *)toolView
{
    if (!_toolView) {
        ALinBottomToolView *toolView = [[ALinBottomToolView alloc] init];
        [toolView setClickToolBlock:^(LiveToolType type) {
            
            if ([self isLogin]) {
                
                switch (type) {
                        
                    case LiveToolTypePrivateTalk:
                        [self showPrivate:YES];
                        break;
                    case LiveToolTypeShare:
                        [self.shareView showInView:self.view];
                        break;
                    case LiveToolTypeMall:
                        [self showMall];
                        break;
                    case LiveToolTypeGift:
                        
                        [self setUpGiftView];
                        break;
                    case LiveToolTypeMore:
                        [self showSlider:YES];
                        break;
                    default:
                        break;
                }
            }
            else{
                
                [self showLogin];
            }
        }];
        [self.view addSubview:toolView];
//        [self.view insertSubview:toolView aboveSubview:self.placeHolderView];
        [toolView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@0);
            make.bottom.equalTo(@-20);
            make.height.equalTo(@35);
            make.width.offset(35 * 5 + 36);
        }];
        _toolView = toolView;
    }
    return _toolView;
}
- (void)showMall{
    
//    FabricWebViewController *vc = [[FabricWebViewController alloc]init];
//    vc.strUrl = [NSString stringWithFormat:@"http://wap.fabric.cn/wap/shop.html?id=%@",self.live.userId];
    
    BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
    
    FabricWebViewController *vc = [[FabricWebViewController alloc]init];
    vc.strUrl = [NSString stringWithFormat:@"http://wap.fabric.cn/wap/shop.html?id=%@&userId=%@&token=%@",self.live.userId,user.userId,user.token];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
    
}


- (ALinLiveAnchorView *)anchorView
{
    if (!_anchorView) {
        ALinLiveAnchorView *anchorView = [ALinLiveAnchorView liveAnchorView];
        anchorView.careBtn.hidden = YES;
//        [anchorView setClickDeviceShow:^(bool isSelected) {
////            if (_moviePlayer) {
////                _moviePlayer.shouldShowHudView = !isSelected;
////            }
//        }];
        [anchorView setClickBack:^{
            
            [self close];
        }];
        [anchorView setClickShop:^{
            
            [self showMall];
        }];
        [self.view addSubview:anchorView];
//        [self.view insertSubview:anchorView aboveSubview:self.placeHolderView];
        [anchorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.height.equalTo(@85);
            make.top.equalTo(@0);
        }];
        _anchorView = anchorView;
    }
    return _anchorView;
}

#pragma mark  BAIRUITECH_giftViewControllerDelegate
- (void)setUpGiftView{
    
    
    self.backgroundButton = [[UIButton alloc]init];
    [self.view addSubview:self.backgroundButton];
    [self.backgroundButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.equalTo(self.view);
    }];
    @weakify(self)
    [self.backgroundButton bk_addEventHandler:^(UIButton *sender) {
        @strongify(self)
        
        [UIView animateWithDuration:0.5 animations:^{
            [self.giftView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.backgroundButton).offset(self.giftView.height);
            }];
            [self.view layoutIfNeeded];
        }completion:^(BOOL finished) {
            [sender removeFromSuperview];
            [self.giftView removeFromSuperview];
            self.giftVC = nil;
        }];
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view layoutIfNeeded];
    
    
    
    //加载子控制器
    self.giftVC = [[BAIRUITECH_GiftViewController alloc] init];
    //        [self addChildViewController:self.giftVC];
    self.giftVC.delegate = self;
    self.giftView = self.giftVC.view;
    
    
    [self.backgroundButton addSubview:self.giftVC.view];
    CGFloat height = 0;
    //    if (self.landscape) {//如果是横屏
    //        height = SCREEN_HEIGHT / 2 + 30;
    //    }else {
    height = SCREEN_WIDTH / 3 * 2 + 70;
    //    }
    [self.giftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backgroundButton);
        make.right.equalTo(self.backgroundButton);
        make.bottom.equalTo(self.backgroundButton).offset(height);
        make.height.mas_equalTo(height);
    }];
    [self.view layoutIfNeeded];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.giftView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.backgroundButton);
        }];
        [self.view layoutIfNeeded];
    }];
    
    [self getGifts];
    
}

- (void)getMallInfo:(NSUInteger)roomId{
    
    [BAIRUITECH_NetWorkManager FinanceLiveShow_mallInfo:@{@"roomId":@(roomId)} withSuccessBlock:^(NSDictionary *object) {
        
        
        if([object[@"ret"] intValue] == 0){
            
            
            self.anchorView.peopleLabel.text = [NSString stringWithFormat:@"TEL %@",object[@"data"][@"companyTele"]];
            
            
            
        }else{
            
            //            [BAIRUITECH_BRTipView showTipTitle:object[@"msg"] delay:1];
        }
        
    } withFailureBlock:^(NSError *error) {
        
        YJLog(@"%@",error);
        
    }];
    
}

- (void)getGifts{
    
    
    __weak  typeof(self) weakSelf = self;
    [BAIRUITECH_NetWorkManager FinanceLiveShow_getGiftList:nil withSuccessBlock:^(NSDictionary *object) {
        
        
        if([object[@"ret"] intValue] == 0){
            
            NSArray *datas = [object[@"data"] copy];
            NSMutableArray *list  = [NSMutableArray array];
            if (datas.count >0) {
                
                
                for (NSDictionary *dic in datas) {
                    
                    NSArray *giftList = [dic[@"giftList"] copy];
                    NSMutableArray *models = [BAIRUITECH_GiftListModel mj_objectArrayWithKeyValuesArray:giftList];
                    for (BAIRUITECH_GiftListModel *model in models) {
                        
                        model.categoryName = dic[@"categoryName"];
                    }
                    if (models.count>0) {
                        [list addObject:models];
                        
                    }
                }
                
                
                
            }
            
            weakSelf.giftVC.giftListArray = list;
            
            
        }else{
            
            [BAIRUITECH_BRTipView showTipTitle:object[@"msg"] delay:1];
        }
        
    } withFailureBlock:^(NSError *error) {
        
        YJLog(@"%@",error);
        
    }];
    
}


//礼物界面,点击取消按钮
-(void)giftViewController:(UIViewController *)giftVC didClickExitButton:(UIButton *)exitButton{
    
    //    self.msgTableView.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        [self.giftView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(self.giftView.height);
        }];
        [self.view layoutIfNeeded];
    }completion:^(BOOL finished) {
        [self.giftVC.view removeFromSuperview];
        self.giftVC = nil;
    }];
    
}
//礼物界面,点击赠送礼物按钮
-(void)giftViewController:(UIViewController *)giftVC gift:(BAIRUITECH_GiftListModel *)model{
    /**
     *  cmd#userId#liveActivityId#giftId#giftCount#wealth(指令标识#赠送用户id #直播 id#赠送礼物id#赠送礼物数量#主播财富值）
     */
    
    
    [self sendGifts:model];
    
}

- (void)sendGifts:(BAIRUITECH_GiftListModel *)model{
    
    
    BAIRUITECH_BRAccount *  account = [BAIRUITECH_BRAccoutTool account];
    
    NSDictionary *dic = @{@"fromUserId":account.userId,@"toUserId":self.live.userId,@"giftId":model.id,@"giftNum":@"1",@"roomId":@(self.live.roomId)};
    [BAIRUITECH_NetWorkManager FinanceLiveShow_giveGift:dic withSuccessBlock:^(NSDictionary *object) {
        
        
        if([object[@"ret"] intValue] == 0){
            
            
            
            
        }else{
            
            [BAIRUITECH_BRTipView showTipTitle:object[@"msg"] delay:1];
        }
        
    } withFailureBlock:^(NSError *error) {
        
        YJLog(@"%@",error);
        
    }];
    
}



//礼物界面,点击充值按钮
-(void)giftViewController:(UIViewController *)giftVC didClickPayButton:(UIButton *)exitButton {
    //    [self showHUDWithText:@"充值功能马上上线" textColor:nil sleepTime:1];
}


//显示观众送礼视图
- (void)showAudienceSendGiftViewWithAudiencePhoto:(NSString *)photo nickName:(NSString *)nickName giftName:(NSString *)giftName giftPic:(NSString *)giftPic giftWealth:(int )giftWealth giftCount:(int )giftCount {
    
    
    BAIRUITECH_AudienceSendGiftView *audienceSendGiftView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([BAIRUITECH_AudienceSendGiftView class]) owner:nil options:nil].lastObject;
    [self.view addSubview:audienceSendGiftView];
    //    [self.allInfoView insertSubview:audienceSendGiftView aboveSubview:self.msgTableView];
    [audienceSendGiftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.height * 0.5 - 30);
        make.left.equalTo(self.view).offset(5);
        make.size.mas_equalTo(CGSizeMake(246, 70));
    }];
    [self.view layoutIfNeeded];
    //    [audienceSendGiftView.audienceImageView sd_setImageWithURL:[NSURL URLWithString:photo] placeholderImage:[UIImage imageNamed:@"AnyChatSDKResources.bundle/占位图/讲师加载"]];
    //    audienceSendGiftView.audienceNameLabel.text = nickName;
    [audienceSendGiftView.giftImageView sd_setImageWithURL:[NSURL URLWithString:giftPic] placeholderImage:[UIImage imageNamed:@"live链接"]];
    
    audienceSendGiftView.audienceImageView.image = [UIImage imageNamed:@"头像"];
    audienceSendGiftView.audienceNameLabel.text = nickName;
    //    audienceSendGiftView.giftImageView.image = [UIImage imageNamed:giftPic];
    
    audienceSendGiftView.wealthLabel.text = [NSString stringWithFormat:@"+%d",giftWealth];
    audienceSendGiftView.giftNameLabel.text = [NSString stringWithFormat:@"送了一个%@",giftName];
    audienceSendGiftView.giftCount = giftCount;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [audienceSendGiftView removeFromSuperview];
    });
}

////显示观众送礼视图
//- (void)showAudienceSendGiftViewWithAudiencePhoto:(NSString *)photo nickName:(NSString *)nickName giftName:(NSString *)giftName giftPic:(NSString *)giftPic giftWealth:(int )giftWealth giftCount:(int )giftCount {
//    
//    
//    BAIRUITECH_AudienceSendGiftView *audienceSendGiftView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([BAIRUITECH_AudienceSendGiftView class]) owner:nil options:nil].lastObject;
//    [self.view addSubview:audienceSendGiftView];
//    //    [self.allInfoView insertSubview:audienceSendGiftView aboveSubview:self.msgTableView];
//    [audienceSendGiftView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.view.height * 0.5 - 30);
//        make.left.equalTo(self.view).offset(5);
//        make.size.mas_equalTo(CGSizeMake(246, 70));
//    }];
////    [self layoutIfNeeded];
//    //    [audienceSendGiftView.audienceImageView sd_setImageWithURL:[NSURL URLWithString:photo] placeholderImage:[UIImage imageNamed:@"AnyChatSDKResources.bundle/占位图/讲师加载"]];
//    //    audienceSendGiftView.audienceNameLabel.text = nickName;
//    [audienceSendGiftView.giftImageView sd_setImageWithURL:[NSURL URLWithString:giftPic] placeholderImage:[UIImage imageNamed:@"live链接"]];
//    
//    audienceSendGiftView.audienceImageView.image = [UIImage imageNamed:@"头像"];
//    audienceSendGiftView.audienceNameLabel.text = nickName;
//    //    audienceSendGiftView.giftImageView.image = [UIImage imageNamed:giftPic];
//    
//    audienceSendGiftView.wealthLabel.text = [NSString stringWithFormat:@"+%d",giftWealth];
//    audienceSendGiftView.giftNameLabel.text = [NSString stringWithFormat:@"送了一个%@",giftName];
//    audienceSendGiftView.giftCount = giftCount;
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [audienceSendGiftView removeFromSuperview];
//    });
//}


//#pragma mark FabricSocketDelegate
//-(void)fbSocket:(FabricSocket *)fbSocket didReceiveMessage:(NSDictionary *)message{
//    
//    NSString *cmd = [NSString stringWithFormat:@"%@",message[@"cmd"]];
//    if ([cmd isEqualToString:@"501"]) {
//        
//        NSDictionary *gift = [self dictionaryWithJsonString:message[@"content"]];
//        [self showGiftWithDic:gift];
//        return;
//    }
//    
//    if ([cmd isEqualToString:@"601"]) {
//        
//
//        NSDictionary *msg = [self dictionaryWithJsonString:message[@"content"]];
//        if (msg) {
//            
//            [self.msgList addObject:msg];
//            [self.msgVC setList:self.msgList];
//        }
//        
//        
//        return;
//    }
//
//}

#pragma mark FabricSocketNotification
-(void)didReceiveMessage:(NSNotification *)notifi{
    
    NSDictionary *message = [self dictionaryWithJsonString:notifi.object];
    if (!message) {
        
        return;
    }
    NSString *reciveId = [NSString stringWithFormat:@"%@",message[@"receiverid"]];
    if (![reciveId isEqualToString:@"0"]) {
        
//        [self recivePrivateMsg:message];
        
        
        return;
    }
    
    
    NSString *cmd = [NSString stringWithFormat:@"%@",message[@"cmd"]];
    if ([cmd isEqualToString:@"501"]) {
        
        NSDictionary *gift = [self dictionaryWithJsonString:message[@"content"]];
        [self showGiftWithDic:gift];
        return;
    }
    
    if ([cmd isEqualToString:@"601"]) {
        
        NSDictionary *msg = [self dictionaryWithJsonString:message[@"content"]];
        if (msg) {
            
            [self.msgList addObject:msg];
            [self.msgVC setList:self.msgList];
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
        
        EMMessage *message = [[EMMessage alloc]init];
        EMMessageBody *body = [EMMessageBody new];
        body.type = EMMessageBodyTypeText;
        message.body = body;
        NSDictionary *content = [self dictionaryWithJsonString:msg[@"content"]];
        message.text = content[@"msg"];
        message.from = content[@"nickName"];
        message.avatar = [NSString stringWithFormat:@"%@%@",ImageURL,content[@"userLogo"]];
        message.direction = [senderId isEqualToString:account.userId]?EMMessageDirectionSend:EMMessageDirectionReceive;
        message.timestamp = [[NSString stringWithFormat:@"%@",msg[@"time"]] longLongValue];
//        [self.privateVC.chatVC addMessageToDataSource:message progress:nil];
//        [self.privateVC addPrivateMsg:msg formUser:senderId];
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
- (void)showGiftWithDic:(NSDictionary *)dic{
    
    [self showAudienceSendGiftViewWithAudiencePhoto:dic[@"fromUserLogo"] nickName:dic[@"fromNickName"] giftName:dic[@"giftName"] giftPic:dic[@"giftImage"] giftWealth:[dic[@"price"] intValue] giftCount:[dic[@"giftNum"] intValue]];
    
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.giftView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.backgroundButton).offset(self.giftView.height);
        }];

    }completion:^(BOOL finished) {
        [self.backgroundButton removeFromSuperview];
        [self.giftVC.view removeFromSuperview];
        self.giftVC = nil;
    }];
    
    
}

//-(void)fbSocketDidOpen:(FabricSocket *)fbSocket{
//    
//}
//-(void)fbSocket:(FabricSocket *)fbSocket didFailWithError:(NSError *)error{
//    
//}
//-(void)fbSocket:(FabricSocket *)fbSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
//    
//}


- (UIView *)livingPreView
{
    if (!_livingPreView) {
        UIView *livingPreView = [[UIView alloc] initWithFrame:self.view.bounds];
        livingPreView.backgroundColor = [UIColor clearColor];
        livingPreView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view insertSubview:livingPreView atIndex:0];
        _livingPreView = livingPreView;
    }
    return _livingPreView;
}
- (LFLiveSession*)session{
    if(!_session){
        /***   默认分辨率368 ＊ 640  音频：44.1 iphone6以上48  双声道  方向竖屏 ***/
        _session = [[LFLiveSession alloc] initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfiguration] videoConfiguration:[LFLiveVideoConfiguration defaultConfigurationForQuality:LFLiveVideoQuality_Medium2] liveType:LFLiveRTMP];
        
//        AVCaptureDevicePosition devicePositon = self.session.captureDevicePosition;
        //_session = [[LFLiveSession alloc] initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfiguration] videoConfiguration:[LFLiveVideoConfiguration defaultConfigurationForQuality:LFLiveVideoQuality_Medium2]];
    
        /**    自己定制高质量音频128K 分辨率设置为720*1280 方向竖屏 */
        /*
         LFLiveAudioConfiguration *audioConfiguration = [LFLiveAudioConfiguration new];
         audioConfiguration.numberOfChannels = 2;
         audioConfiguration.audioBitrate = LFLiveAudioBitRate_128Kbps;
         audioConfiguration.audioSampleRate = LFLiveAudioSampleRate_44100Hz;
         
         LFLiveVideoConfiguration *videoConfiguration = [LFLiveVideoConfiguration new];
         videoConfiguration.videoSize = CGSizeMake(720, 1280);
         videoConfiguration.videoBitRate = 800*1024;
         videoConfiguration.videoMaxBitRate = 1000*1024;
         videoConfiguration.videoMinBitRate = 500*1024;
         videoConfiguration.videoFrameRate = 15;
         videoConfiguration.videoMaxKeyframeInterval = 30;
         videoConfiguration.orientation = UIInterfaceOrientationPortrait;
         videoConfiguration.sessionPreset = LFCaptureSessionPreset720x1280;
         
         _session = [[LFLiveSession alloc] initWithAudioConfiguration:audioConfiguration videoConfiguration:videoConfiguration liveType:LFLiveRTMP];
         */
        
        // 设置代理
        _session.delegate = self;
        _session.running = YES;
        _session.preView = self.livingPreView;
    }
    return _session;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIScreen mainScreen] setBrightness:0.5];
    //设置屏幕常亮
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [self setup];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didReceiveMessage:) name:@"FSDidReceiveMessage" object:nil];
    
    
    
}
- (BOOL)isLogin{
    
    BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
    if ([user.userId isEqualToString:@"0"]) {
        
        return NO;
    }
    return YES;
}

- (void)showLogin{
    
    BRLoginViewController *vc = [BRLoginViewController new];
//    [vc setBlock:^(void){
//        
//        [self setUpSocket];
//    }];
    BRLoginNavigationController *nav = [[BRLoginNavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)setLive:(LiveUserModel *)live{
    
    _live = live;
    self.toolView.hidden =NO;
    [self getMallInfo:_live.roomId];
    self.anchorView.live = live;
    self.msgList = [NSMutableArray array];
    [self.msgVC setList:self.msgList];
    
//    [self setUpSocket];
    
    LFLiveStreamInfo *stream = [LFLiveStreamInfo new];
    stream.url =live.pushStream;
    self.rtmpUrl = stream.url;
    [self.session startLive:stream];
    
    [self addChildViewController:self.sliderVC];
    [self.view addSubview:self.sliderVC.view];
    
    [self addChildViewController:self.privateVC];
//    self.privateVC.socket = self.socket;
    [self.view addSubview:self.privateVC.view];
    [self SendEnterRoomCMD];
    self.switchCamera.backgroundColor = [UIColor clearColor];

   
}
- (void)SendEnterRoomCMD{
    
    [[FabricSocket shareInstances]enterRoom:self.live.roomId];
}

- (void)SendleaveRoomCMD{
    
    [[FabricSocket shareInstances]leaveRoom:self.live.roomId];
}




- (void)setup{

    
//    // 默认开启后置摄像头, 怕我的面容吓到你们了...
//    self.session.captureDevicePosition = AVCaptureDevicePositionFront;
    
    [self.publicChatBtn setTitle:@"一起聊天吧~" forState:UIControlStateNormal];
    
    
    
}
// 关闭直播
- (IBAction)close {
    
    
    BAIRUITECH_BRAccount *  account = [BAIRUITECH_BRAccoutTool account];
    
    [BAIRUITECH_NetWorkManager FinanceLiveShow_leaveLiveActivity:@{@"userId":account.userId} withSuccessBlock:^(NSDictionary *object) {
        
        
        if([object[@"ret"] intValue] == 0){
            
            if (self.session.state == LFLivePending || self.session.state == LFLiveStart){
                [self.session stopLive];
            }
            
            [self SendleaveRoomCMD];
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            
            [BAIRUITECH_BRTipView showTipTitle:object[@"msg"] delay:1];
        }
        
    } withFailureBlock:^(NSError *error) {
        
        YJLog(@"%@",error);
        
    }];
    
    
}

// 开启/关闭美颜相机
- (IBAction)beautiful:(UIButton *)sender {
    sender.selected = !sender.selected;
    // 默认是开启了美颜功能的
    self.session.beautyFace = !self.session.beautyFace;
}


// 切换前置/后置摄像头
- (IBAction)switchCamare:(UIButton *)sender {
    AVCaptureDevicePosition devicePositon = self.session.captureDevicePosition;
    self.session.captureDevicePosition = (devicePositon == AVCaptureDevicePositionBack) ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
    NSLog(@"切换前置/后置摄像头");
}


#pragma mark -- LFStreamingSessionDelegate
/** live status changed will callback */
- (void)liveSession:(nullable LFLiveSession *)session liveStateDidChange:(LFLiveState)state{
    NSString *tempStatus;
    switch (state) {
        case LFLiveReady:
            tempStatus = @"准备中";
            break;
        case LFLivePending:
            tempStatus = @"连接中";
            break;
        case LFLiveStart:
            tempStatus = @"已连接";
            break;
        case LFLiveStop:
            tempStatus = @"已断开";
            break;
        case LFLiveError:
            tempStatus = @"连接出错";
            break;
        default:
            break;
    }
    NSLog(@"状态: %@\nRTMP:%@",tempStatus,self.rtmpUrl);
//    self.statusLabel.text = [NSString stringWithFormat:@"状态: %@\nRTMP: %@", tempStatus, self.rtmpUrl];
}

/** live debug info callback */
- (void)liveSession:(nullable LFLiveSession *)session debugInfo:(nullable LFLiveDebug*)debugInfo{
    
}

/** callback socket errorcode */
- (void)liveSession:(nullable LFLiveSession*)session errorCode:(LFLiveSocketErrorCode)errorCode{
    
}

@end

