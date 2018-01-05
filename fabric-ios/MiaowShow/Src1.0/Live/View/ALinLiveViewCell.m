//
//  ALinLiveViewCell.m
//  MiaowShow
//
//  Created by ALin on 16/6/23.
//  Copyright © 2016年 ALin. All rights reserved.
//

#import "ALinLiveViewCell.h"
#import "ALinBottomToolView.h"
#import "ALinLiveAnchorView.h"
#import "ALinCatEarView.h"
#import "ALinLive.h"
//#import "ALinUser.h"
//#import "UIImage+ALinExtension.h"
#import "ALinLiveEndView.h"

#import <SDWebImageDownloader.h>
#import <BarrageRenderer.h>
#import "BAIRUITECH_GiftViewController.h"
#import "BAIRUITECH_AudienceSendGiftView.h"
#import "BRLoginViewController.h"
#import "MsgViewController.h"
#import "BAIRUITECH_GrowingInputView.h"
#import "FabricSocket.h"
#import "BRLoginNavigationController.h"
#import "FeedBackViewController.h"

#import "SliderViewController.h"
#import "MallDeatilViewController.h"

#import "FabricWebViewController.h"
#import "HelpViewController.h"
#import "EaseMessageViewController.h"
#import "ALinLiveCollectionViewController.h"
#import "ShareView.h"
@interface ALinLiveViewCell()<BAIRUITECH_giftViewControllerDelegate,BAIRUITECH_GrowingInputViewDelegate>
{
    BarrageRenderer *_renderer;
    NSTimer * _timer;
}
/** 直播播放器 */
@property (nonatomic, strong) IJKFFMoviePlayerController *moviePlayer;
/** 底部的工具栏 */
@property(nonatomic, weak) ALinBottomToolView *toolView;
/** 顶部主播相关视图 */
@property(nonatomic, weak) ALinLiveAnchorView *anchorView;

/** 同一个工会的主播/相关主播 */
@property(nonatomic, weak) UIImageView *otherView;
/** 直播开始前的占位图片 */
@property(nonatomic, weak) UIImageView *placeHolderView;
/** 粒子动画 */
@property(nonatomic, weak) CAEmitterLayer *emitterLayer;
/** 直播结束的界面 */
@property (nonatomic, weak) ALinLiveEndView *endView;

@property (weak, nonatomic) BAIRUITECH_GrowingInputView *growingInputView;//输入框
@property (nonatomic, strong) UIButton *publicChatBtn;


@property(nonatomic, strong) BAIRUITECH_GiftViewController *giftVC;
@property(nonatomic, strong) UIButton *backgroundButton;
@property (nonatomic, strong) UIView *giftView;

@property (nonatomic, strong) MsgViewController *msgVC;
@property (nonatomic, weak) UITableView *msgTable;
@property (nonatomic, strong) NSMutableArray *msgList;


//@property (nonatomic, strong) FabricSocket *socket;


@property (nonatomic, strong) SliderViewController *sliderVC;
@property (nonatomic, strong) MallDeatilViewController *mallInfoVC;
@property (nonatomic, strong) HelpViewController *helpVC;


@property (nonatomic, strong) EaseMessageViewController *chatVC;


@property (nonatomic, strong) ShareView *shareView;

@property (nonatomic ,copy) NSDictionary *mallInfo;
@end

@implementation ALinLiveViewCell
- (ShareView *)shareView{
    
    if (!_shareView) {
        
        _shareView = [[ShareView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
    }
    return _shareView;
}
- (void)showChat:(BOOL)show{
    
    CGFloat y = show?300:SCREEN_HEIGHT;
    [UIView animateWithDuration:0.5 animations:^{
        
        _chatVC.view.frame = CGRectMake(0, y, SCREEN_WIDTH, SCREEN_HEIGHT-300);
        [_chatVC.view endEditing:YES];
        
    } completion:^(BOOL finished) {
        
    }];
    
    if (show) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideChat:)];
        [self addGestureRecognizer:tap];
    }
    
}
- (EaseMessageViewController *)chatVC{
    
    if (!_chatVC) {
        
        _chatVC = [[EaseMessageViewController alloc]initWithConversationChatter:@"11"];
        _chatVC.view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT -300);
        _chatVC.roomId = [NSString stringWithFormat:@"%lu",(unsigned long)self.live.roomId];
        _chatVC.toUserId = self.live.userId;
        _chatVC.showRefreshHeader = YES;
        
    }
    return _chatVC;
}

- (void)hideChat:(UITapGestureRecognizer *)ges{
    [self removeGestureRecognizer:ges];
    [self showChat:NO];
    
}

- (void)enterRoom:(NSDictionary *)dic{
    
    BAIRUITECH_BRAccount *account = [BAIRUITECH_BRAccoutTool account];
    
    [BAIRUITECH_NetWorkManager FinanceLiveShow_enterRoom:@{@"roomId":dic[@"roomId"],@"userId":account.userId} withSuccessBlock:^(NSDictionary *object) {
        
        
        if([object[@"ret"] intValue] == 0){
            
            if ([object[@"data"][@"star"][@"status"] intValue] == 1) {
                
                ALinLiveCollectionViewController *vc = [ALinLiveCollectionViewController new];
                
                vc.live = [LiveUserModel mj_objectWithKeyValues:object[@"data"][@"star"]];
                
                vc.live.chatAddress =object[@"data"][@"chat"][@"chatAddress"];
                vc.live.chatKey = object[@"data"][@"chat"][@"chatKey"];
                vc.live.isFollow =[object[@"data"][@"isFollow"] boolValue];
                
                if(!(vc.live.chatAddress.length >0))
                {
                    [BAIRUITECH_BRTipView showTipTitle:@"服务端返回json格式错误" delay:1];
                    return ;
                }
                [vc setHelpBack:^{
                   
                    [self setLive:self.live];
                    
                }];
                
                [self.parentVc.navigationController pushViewController:vc animated:YES];
            }
            else{
                
                [self showMall];
            }
            
        }else{
            
            [BAIRUITECH_BRTipView showTipTitle:object[@"msg"] delay:1];
        }
        
    } withFailureBlock:^(NSError *error) {
        
        YJLog(@"%@",error);
        
    }];
}

- (void)getHelpList{
    
    [self.parentVc showHudInView:self];
    [BAIRUITECH_NetWorkManager FinanceLiveShow_help:nil withSuccessBlock:^(NSDictionary *object) {
        
        [self.parentVc hideHud];
        
        if([object[@"ret"] intValue] == 0){
            
            
            _helpVC.list = object[@"data"];
            [self showHelp:YES];
            
            
            
            
        }else{
            
            //            [BAIRUITECH_BRTipView showTipTitle:object[@"msg"] delay:1];
        }
        
    } withFailureBlock:^(NSError *error) {
        [self.parentVc hideHud];

        YJLog(@"%@",error);
        
    }];
}

- (void)showHelp:(BOOL)show{
    
    CGFloat y = show?0:SCREEN_HEIGHT;
    [UIView animateWithDuration:0.5 animations:^{
        
        _helpVC.view.frame = CGRectMake(0, y, SCREEN_WIDTH, SCREEN_HEIGHT);
        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (HelpViewController *)helpVC{
    
    if (!_helpVC) {
        
        _helpVC = [[HelpViewController alloc]init];
        _helpVC.view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
        __weak typeof(self) weak = self;
        [_helpVC setNext:^(NSDictionary *dic){
           
            
            
            if (_moviePlayer) {
                [self.moviePlayer shutdown];
                [[NSNotificationCenter defaultCenter] removeObserver:self];
            }
            //    [self.socket disConnect];
            
            if ([self isLogin]) {
                
                [self SendleaveRoomCMD];
            }
            
            [weak showHelp:NO];
            [weak enterRoom:dic];
                        
            
        }];
        [_helpVC setHideBlock:^{
            
            [weak showHelp:NO];
        }];
    }
    return _helpVC;
}

- (void)showMallInfo:(BOOL)show{
    
    CGFloat y = show?0:SCREEN_HEIGHT;
    [UIView animateWithDuration:0.5 animations:^{
        
        _mallInfoVC.textView.text = [NSString stringWithFormat:@"%@",_mallInfo[@"companyInfo"]];
        _mallInfoVC.view.frame = CGRectMake(0, y, SCREEN_WIDTH, SCREEN_HEIGHT);
        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (MallDeatilViewController *)mallInfoVC{
    
    if (!_mallInfoVC) {
        
        _mallInfoVC = [[MallDeatilViewController alloc]init];
        _mallInfoVC.view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
         __weak typeof(self) weak = self;
        [_mallInfoVC setHideBlock:^{
          
            [weak showMallInfo:NO];
        }];
    }
    return _mallInfoVC;
}

-(SliderViewController *)sliderVC{
    
    if (!_sliderVC) {
        
        _sliderVC = [[SliderViewController alloc]init];
        _sliderVC.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        _sliderVC.data = @[@"公司介绍-(1)&公司介绍",@"商城&商城",@"电话-(1)&电话连接",@"意见-拷贝&意见反馈"];
    
        __weak typeof(self) weak = self;
        [_sliderVC setDidSelect:^(NSInteger index){
           
            [weak showSlider:NO];
            if (index == 1) {
                [weak showMall];
            }else if (index == 3){
                
                [weak showFeedBack];
            }else if (index == 2){
                
                [weak showPhoneCall];
            }else{
                
                [weak showMallInfo:YES];
            }
            
        }];
        [_sliderVC setHideBlock:^{
           
            [weak showSlider:NO];
        }];
        
    }
    return _sliderVC;
}


- (void)showFeedBack{
    
    FeedBackViewController *vc = [[FeedBackViewController alloc]init];
    [self.parentVc.navigationController setNavigationBarHidden:NO];
    [self.parentVc.navigationController pushViewController:vc animated:YES];
    
}
- (void)showPhoneCall{
    
    NSString *phone = [NSString stringWithFormat:@"tel://%@",_mallInfo[@"companyTele"]];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:phone]];
//    
//    UIWebView * callWebview = [[UIWebView alloc]init];
//    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"tel:10010"]]];
//    [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
//    
    
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"呼叫" message:@"0571-5555555" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *acton){
//        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tel://0571-5555555"]];
//    }];
//    [alertController addAction:cancelAction];
//    [alertController addAction:okAction];
//    [self.parentVc presentViewController:alertController animated:YES completion:nil];
}


- (void)showSlider:(BOOL)show{
    
    CGFloat x = show?0:SCREEN_WIDTH;
    [UIView animateWithDuration:0.5 animations:^{
        
        _sliderVC.view.frame = CGRectMake(x, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
    } completion:^(BOOL finished) {
        
    }];
}


- (UIButton *)publicChatBtn{
    
    if (!_publicChatBtn) {
        
        self.publicChatBtn = [[UIButton alloc]init];
        [self.publicChatBtn setTintColor:[UIColor whiteColor]];
        self.publicChatBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        
        [self.publicChatBtn setBackgroundImage:[UIImage imageNamed:@"公聊-背景"] forState:UIControlStateNormal];
        [self addSubview:self.publicChatBtn];
        [self.publicChatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.bottom.equalTo(self).offset(-20);
            
            make.size.mas_equalTo(CGSizeMake(97, 28));
        }];
        @weakify(self)
        [self.publicChatBtn bk_addEventHandler:^(UIButton *sender) {
            @strongify(self)
            if ([self isLogin]) {
                
                [self showInputView];
            }
            else{
                
                [self showLogin];
            }
//            [UIView animateWithDuration:0.5 animations:^{
//                [self.giftView mas_updateConstraints:^(MASConstraintMaker *make) {
//                    make.bottom.equalTo(self.backgroundButton).offset(self.giftView.height);
//                }];
//                [self layoutIfNeeded];
//            }completion:^(BOOL finished) {
//                [sender removeFromSuperview];
//                [self.giftView removeFromSuperview];
//                self.giftVC = nil;
//            }];
        } forControlEvents:UIControlEventTouchUpInside];
        
        
        [self layoutIfNeeded];
    }
    return _publicChatBtn;
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
    [vc setBlock:^(void){
       
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self SendEnterRoomCMD];
        });
        
        
    }];

    BRLoginNavigationController *nav = [[BRLoginNavigationController alloc]initWithRootViewController:vc];

    [self.parentVc presentViewController:nav animated:YES completion:nil];
}
//展示输入框
- (void)showInputView {
    if (self.growingInputView == nil) {//输入框懒加载
        BAIRUITECH_GrowingInputView *growingInputView = [[BAIRUITECH_GrowingInputView alloc] initWithFrame:CGRectZero];
        self.growingInputView  = growingInputView;
        self.growingInputView.frame = CGRectMake(0, self.height - [BAIRUITECH_GrowingInputView defaultHeight], self.width, [BAIRUITECH_GrowingInputView defaultHeight]);
        self.growingInputView.placeholder = @"我来说点什么吧~";
        self.growingInputView.delegate = self;
        self.growingInputView.parentView = self;
        
        [self addSubview:self.growingInputView];
    }
    self.growingInputView.hidden = NO;
    //在键盘下面插入一个退键盘的button,点击背景button退键盘
    UIButton *backgroundButton = [[UIButton alloc] init];
    [self insertSubview:backgroundButton belowSubview:self.growingInputView];
    [backgroundButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.equalTo(self);
    }];
    @weakify(self)
    [backgroundButton bk_addEventHandler:^(id sender) {
        @strongify(self)
        //退键盘,隐藏输入框
        [self endEditing:YES];
        [self.growingInputView removeFromSuperview];
//        self.growingInputView.hidden = YES;
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
    [[FabricSocket shareInstances]sendTextMsg:text targetUserId:nil roomId:[NSString stringWithFormat:@"%lu",(unsigned long)self.live.roomId]];
    self.growingInputView.text=@"";
    return YES;
    
}

- (MsgViewController *)msgVC{
    
    if (!_msgVC) {
        
        self.msgVC = [MsgViewController new];
        [self.parentVc addChildViewController:self.msgVC];
        [self addSubview:self.msgVC.view];
        self.msgTable = self.msgVC.tableView;
        [self.msgVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(@10);
            make.top.equalTo(@150);
            make.height.offset(SCREEN_HEIGHT - 100 - 100);
            make.width.offset(SCREEN_WIDTH/2);
        }];
    }
    return _msgVC;
}

- (UIImageView *)placeHolderView
{
    if (!_placeHolderView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = self.contentView.bounds;
//        imageView.image = [UIImage imageNamed:@"profile_user_414x414"];
         imageView.image = [UIImage imageNamed:@"112"];
        [self.contentView addSubview:imageView];
        _placeHolderView = imageView;
        [self.parentVc showGifLoding:nil inView:self.placeHolderView];
        // 强制布局
        [_placeHolderView layoutIfNeeded];
    }
    return _placeHolderView;
}

bool _isSelected = NO;
- (ALinBottomToolView *)toolView
{
    if (!_toolView) {
        ALinBottomToolView *toolView = [[ALinBottomToolView alloc] init];
        [toolView setClickToolBlock:^(LiveToolType type) {
            
            if ([self isLogin]) {
                
                switch (type) {
                        
                    case LiveToolTypePrivateTalk:
                        [self showChat:YES];
                        break;
                    case LiveToolTypeShare:
                        [self.shareView showInView:self];
                        break;
                    case LiveToolTypeMall:
                        
                        [self getHelpList];
                        
                        break;
                    case LiveToolTypeGift:
                        
                        [self setUpGiftView];
                        break;
                    case LiveToolTypeMore:
                        [self showSlider];
                        break;
                    default:
                        break;
                }
            }
            else{
                
                [self showLogin];
            }
        }];
        [self.contentView insertSubview:toolView aboveSubview:self.placeHolderView];
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
    
    
    
    BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
    
    FabricWebViewController *vc = [[FabricWebViewController alloc]init];
    vc.strUrl = [NSString stringWithFormat:@"http://wap.fabric.cn/wap/shop.html?id=%@&userId=%@&token=%@",self.live.userId,user.userId,user.token];
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self.parentVc presentViewController:nav animated:YES completion:nil];
    
}
- (void)showSlider{
    
    [self showSlider:YES];
}

//- (UIImageView *)otherView
//{
//    if (!_otherView) {
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"private_icon_70x70"]];
//        imageView.userInteractionEnabled = YES;
//        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOther)]];
//        [self.moviePlayer.view addSubview:imageView];
//        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.catEarView);
//            make.bottom.equalTo(self.catEarView.mas_top).offset(-40);
//        }];
//        _otherView = imageView;
//    }
//    return _otherView;
//}

- (ALinLiveAnchorView *)anchorView
{
    if (!_anchorView) {
        ALinLiveAnchorView *anchorView = [ALinLiveAnchorView liveAnchorView];
        [anchorView setClickDeviceShow:^(UIButton *btn) {
//            if (_moviePlayer) {
//                _moviePlayer.shouldShowHudView = !isSelected;
//            }
            if ([self isLogin]) {
                
                [self careWithBtn:btn];
            }else{
                [self showLogin];
            }
            
        }];
        [anchorView setClickShop:^{
           
            [self showMall];
        }];
        [anchorView setClickBack:^{
           
            [self quit];
        }];
        [self.contentView insertSubview:anchorView aboveSubview:self.placeHolderView];
        [anchorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.height.equalTo(@85);
            make.top.equalTo(@0);
        }];
        _anchorView = anchorView;
    }
    return _anchorView;
}

- (void)careWithBtn:(UIButton *)btn{

    
    BAIRUITECH_BRAccount *  account = [BAIRUITECH_BRAccoutTool account];
    
    NSDictionary *dic = @{@"userId":account.userId,@"followUserId":self.live.userId};
    
    if (btn.selected) {
        [BAIRUITECH_NetWorkManager FinanceLiveShow_delAttention:dic withSuccessBlock:^(NSDictionary *object) {
            
            
            if([object[@"ret"] intValue] == 0){
                
                btn.selected = !btn.selected;
            }else{
                
                [BAIRUITECH_BRTipView showTipTitle:object[@"msg"] delay:1];
            }
            
        } withFailureBlock:^(NSError *error) {
            
            YJLog(@"%@",error);
            
        }];
        
    }else{
        
        [BAIRUITECH_NetWorkManager FinanceLiveShow_addAttention:dic withSuccessBlock:^(NSDictionary *object) {
            
            
            if([object[@"ret"] intValue] == 0){
                 btn.selected = !btn.selected;
                
            }else{
                
                [BAIRUITECH_BRTipView showTipTitle:object[@"msg"] delay:1];
            }
            
        } withFailureBlock:^(NSError *error) {
            
            YJLog(@"%@",error);
            
        }];
        
    }
    
}


- (CAEmitterLayer *)emitterLayer
{
    if (!_emitterLayer) {
        CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
        // 发射器在xy平面的中心位置
        emitterLayer.emitterPosition = CGPointMake(self.moviePlayer.view.frame.size.width-50,self.moviePlayer.view.frame.size.height-50);
        // 发射器的尺寸大小
        emitterLayer.emitterSize = CGSizeMake(20, 20);
        // 渲染模式
        emitterLayer.renderMode = kCAEmitterLayerUnordered;
        // 开启三维效果
        //    _emitterLayer.preservesDepth = YES;
        NSMutableArray *array = [NSMutableArray array];
        // 创建粒子
        for (int i = 0; i<10; i++) {
            // 发射单元
            CAEmitterCell *stepCell = [CAEmitterCell emitterCell];
            // 粒子的创建速率，默认为1/s
            stepCell.birthRate = 1;
            // 粒子存活时间
            stepCell.lifetime = arc4random_uniform(4) + 1;
            // 粒子的生存时间容差
            stepCell.lifetimeRange = 1.5;
            // 颜色
            // fire.color=[[UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:0.1]CGColor];
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"good%d_30x30", i]];
            // 粒子显示的内容
            stepCell.contents = (id)[image CGImage];
            // 粒子的名字
            //            [fire setName:@"step%d", i];
            // 粒子的运动速度
            stepCell.velocity = arc4random_uniform(100) + 100;
            // 粒子速度的容差
            stepCell.velocityRange = 80;
            // 粒子在xy平面的发射角度
            stepCell.emissionLongitude = M_PI+M_PI_2;;
            // 粒子发射角度的容差
            stepCell.emissionRange = M_PI_2/6;
            // 缩放比例
            stepCell.scale = 0.3;
            [array addObject:stepCell];
        }
        
        emitterLayer.emitterCells = array;
//        [self.moviePlayer.view.layer insertSublayer:emitterLayer below:self.contentView];
        _emitterLayer = emitterLayer;
    }
    return _emitterLayer;
}

- (ALinLiveEndView *)endView
{
    if (!_endView) {
        ALinLiveEndView *endView = [ALinLiveEndView liveEndView];
        [self.parentVc.view addSubview:endView];
        [endView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
        [endView setQuitBlock:^{
            [self quit];
        }];
        [endView setLookOtherBlock:^{
            [self clickCatEar];
        }];
        _endView = endView;
    }
    return _endView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.toolView.hidden = NO;
       
    
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didReceiveMessage:) name:@"FSDidReceiveMessage" object:nil];
        
//        _renderer = [[BarrageRenderer alloc] init];
//        _renderer.canvasMargin = UIEdgeInsetsMake(ALinScreenHeight * 0.3, 10, 10, 10);
//        [self.contentView addSubview:_renderer.view];
        
//        NSSafeObject * safeObj = [[NSSafeObject alloc]initWithObject:self withSelector:@selector(autoSendBarrage)];
//        _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:safeObj selector:@selector(excute) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)setLive:(LiveUserModel *)live
{
    _live = live;
    
    [self getMallInfo:_live.roomId];
    [self.publicChatBtn setTitle:@"一起聊天吧~" forState:UIControlStateNormal];
    self.anchorView.live = live;
    [self plarFLV:live.playStream placeHolderUrl:[NSString stringWithFormat:@"%@%@",BaseURL,live.userLogo]];
    
    self.msgList = [NSMutableArray array];
    [self.msgVC setList:self.msgList];
    
    
    if ([self isLogin]) {
        
        [self SendEnterRoomCMD];
    }
    

    [self.parentVc addChildViewController:self.chatVC];
    [self addSubview:self.chatVC.view];
    
    [self.parentVc addChildViewController:self.sliderVC];
    [self addSubview:self.sliderVC.view];
    
    [self.parentVc addChildViewController:self.mallInfoVC];
    [self addSubview:self.mallInfoVC.view];
    
    [self.parentVc addChildViewController:self.helpVC];
    [self addSubview:self.helpVC.view];
    
//    [[UIScreen mainScreen] setBrightness:0.5];
    //设置屏幕常亮
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
}

- (void)SendEnterRoomCMD{
    
    [[FabricSocket shareInstances]enterRoom:self.live.roomId];
}

- (void)SendleaveRoomCMD{
    
    [[FabricSocket shareInstances]leaveRoom:self.live.roomId];
}




- (void)setRelateLive:(ALinLive *)relateLive
{
    _relateLive = relateLive;
//    // 设置相关主播
//    if (relateLive) {
//        self.catEarView.live = relateLive;
//    }else{
//        self.catEarView.hidden = YES;
//    }
}


#pragma mark - private method


- (void)showGift{
    
//    self.backgroundButton = [[UIButton alloc]init];
//    [self addSubview:self.backgroundButton];
//    [self.backgroundButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self);
//        make.size.equalTo(self);
//    }];
//    @weakify(self)
//    [self.backgroundButton bk_addEventHandler:^(UIButton *sender) {
//        @strongify(self)
//
//        [UIView animateWithDuration:0.5 animations:^{
//            [self.giftView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.bottom.equalTo(self.backgroundButton).offset(self.giftView.height);
//            }];
//            [self layoutIfNeeded];
//        }completion:^(BOOL finished) {
//            [sender removeFromSuperview];
//            [self.giftView removeFromSuperview];
//            self.giftVC = nil;
//        }];
//    } forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    
//    //加载子控制器
//    self.giftVC = [[BAIRUITECH_GiftViewController alloc] init];
//    //        [self addChildViewController:self.giftVC];
//    self.giftVC.delegate = self;
//    self.giftView = self.giftVC.view;
//    [self.backgroundButton addSubview:self.giftVC.view];
//    CGFloat height = 0;
////    if (self.landscape) {//如果是横屏
////        height = SCREEN_HEIGHT / 2 + 30;
////    }else {
//        height = SCREEN_WIDTH / 3 * 2 + 70;
////    }
//    [self.giftView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.backgroundButton);
//        make.right.equalTo(self.backgroundButton);
//        make.bottom.equalTo(self.backgroundButton).offset(height);
//        make.height.mas_equalTo(height);
//    }];
    
    self.backgroundButton = [[UIButton alloc]init];
    [self addSubview:self.backgroundButton];
    [self.backgroundButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.equalTo(self);
    }];
    @weakify(self)
    [self.backgroundButton bk_addEventHandler:^(UIButton *sender) {
        @strongify(self)
        
        [UIView animateWithDuration:0.5 animations:^{
            [self.giftView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.backgroundButton).offset(self.giftView.height);
            }];
            [self layoutIfNeeded];
        }completion:^(BOOL finished) {
            [sender removeFromSuperview];
            [self.giftView removeFromSuperview];
            self.giftVC = nil;
        }];
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.giftView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.backgroundButton);
        }];
        [self layoutIfNeeded];
    }];
//    
////    //请求网络数据
//    [self getGifts];

}
- (void)plarFLV:(NSString *)flv placeHolderUrl:(NSString *)placeHolderUrl
{
    if (_moviePlayer) {
        if (_moviePlayer) {
            [self.contentView insertSubview:self.placeHolderView aboveSubview:_moviePlayer.view];
        }
//        if (_catEarView) {
//            [_catEarView removeFromSuperview];
//            _catEarView = nil;
//        }
        [_moviePlayer shutdown];
        [_moviePlayer.view removeFromSuperview];
        _moviePlayer = nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    
    // 如果切换主播, 取消之前的动画
    if (_emitterLayer) {
        [_emitterLayer removeFromSuperlayer];
        _emitterLayer = nil;
    }
    
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:placeHolderUrl] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (image) {
                
                [self.parentVc showGifLoding:nil inView:self.placeHolderView];
//                self.placeHolderView.image = [UIImage blurImage:image blur:0.8];
            }
            
        });
    }];
    
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    [options setPlayerOptionIntValue:1  forKey:@"videotoolbox"];
    
    // 帧速率(fps) （可以改，确认非标准桢率会导致音画不同步，所以只能设定为15或者29.97）
    [options setPlayerOptionIntValue:29.97 forKey:@"r"];
    // -vol——设置音量大小，256为标准音量。（要设置成两倍音量时则输入512，依此类推
    [options setPlayerOptionIntValue:512 forKey:@"vol"];
    IJKFFMoviePlayerController *moviePlayer = [[IJKFFMoviePlayerController alloc] initWithContentURLString:flv withOptions:options];
    moviePlayer.view.frame = self.contentView.bounds;
    // 填充fill
    moviePlayer.scalingMode = IJKMPMovieScalingModeAspectFill;
    // 设置自动播放(必须设置为NO, 防止自动播放, 才能更好的控制直播的状态)
    moviePlayer.shouldAutoplay = NO;
    // 默认不显示
    moviePlayer.shouldShowHudView = NO;
    
    [self.contentView insertSubview:moviePlayer.view atIndex:0];
    
    [moviePlayer prepareToPlay];
    
    self.moviePlayer = moviePlayer;
    
    // 设置监听
    [self initObserver];
    
    // 显示工会其他主播和类似主播
    [moviePlayer.view bringSubviewToFront:self.otherView];
    
    // 开始来访动画
    [self.emitterLayer setHidden:NO];
}


- (void)initObserver
{
    // 监听视频是否播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinish) name:IJKMPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stateDidChange) name:IJKMPMoviePlayerLoadStateDidChangeNotification object:self.moviePlayer];
}

- (void)clickOther
{
    NSLog(@"相关的主播");
}

- (void)clickCatEar
{
    if (self.clickRelatedLive) {
        self.clickRelatedLive();
    }
}
#pragma mark  BAIRUITECH_giftViewControllerDelegate
- (void)setUpGiftView{

    
    self.backgroundButton = [[UIButton alloc]init];
    [self addSubview:self.backgroundButton];
    [self.backgroundButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.equalTo(self);
    }];
    @weakify(self)
    [self.backgroundButton bk_addEventHandler:^(UIButton *sender) {
        @strongify(self)
        
        [UIView animateWithDuration:0.5 animations:^{
            [self.giftView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.backgroundButton).offset(self.giftView.height);
            }];
            [self layoutIfNeeded];
        }completion:^(BOOL finished) {
            [sender removeFromSuperview];
            [self.giftView removeFromSuperview];
            self.giftVC = nil;
        }];
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    [self layoutIfNeeded];
    

    
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
    [self layoutIfNeeded];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.giftView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.backgroundButton);
        }];
        [self layoutIfNeeded];
    }];
    
    [self getGifts];
    
}

- (void)getMallInfo:(NSUInteger)roomId{

    [BAIRUITECH_NetWorkManager FinanceLiveShow_mallInfo:@{@"roomId":@(roomId)} withSuccessBlock:^(NSDictionary *object) {
        
        
        if([object[@"ret"] intValue] == 0){
            
            
            _mallInfo = object[@"data"];
            
            self.anchorView.peopleLabel.text =[NSString stringWithFormat:@"TEL %@",_mallInfo[@"companyTele"]];
            
        
            
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
        [self layoutIfNeeded];
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
    
    
    BAIRUITECH_BRAccount *account = [BAIRUITECH_BRAccoutTool account];

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
    [self addSubview:audienceSendGiftView];
//    [self.allInfoView insertSubview:audienceSendGiftView aboveSubview:self.msgTableView];
    [audienceSendGiftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.height * 0.5 - 30);
        make.left.equalTo(self).offset(5);
        make.size.mas_equalTo(CGSizeMake(246, 70));
    }];
    [self layoutIfNeeded];
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

#pragma mark - notify method

- (void)stateDidChange
{
    if ((self.moviePlayer.loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        if (!self.moviePlayer.isPlaying) {
            [self.moviePlayer play];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (_placeHolderView) {
                    [_placeHolderView removeFromSuperview];
                    _placeHolderView = nil;
                    [self.moviePlayer.view addSubview:_renderer.view];
                }
                [self.parentVc hideGufLoding];
            });
        }else{
            // 如果是网络状态不好, 断开后恢复, 也需要去掉加载
            if (self.parentVc.gifView.isAnimating) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.parentVc hideGufLoding];
                });
                
            }
        }
    }else if (self.moviePlayer.loadState & IJKMPMovieLoadStateStalled){ // 网速不佳, 自动暂停状态
        [self.parentVc showGifLoding:nil inView:self.moviePlayer.view];
    }
}

- (void)didFinish
{
    NSLog(@"加载状态...%ld %ld %s", self.moviePlayer.loadState, self.moviePlayer.playbackState, __func__);
    // 因为网速或者其他原因导致直播stop了, 也要显示GIF
    if (self.moviePlayer.loadState & IJKMPMovieLoadStateStalled && !self.parentVc.gifView) {
        [self.parentVc showGifLoding:nil inView:self.moviePlayer.view];
        return;
    }
//    方法：
//      1、重新获取直播地址，服务端控制是否有地址返回。
//      2、用户http请求该地址，若请求成功表示直播未结束，否则结束
    __weak typeof(self)weakSelf = self;
    [weakSelf.moviePlayer shutdown];
    [weakSelf.moviePlayer.view removeFromSuperview];
    weakSelf.moviePlayer = nil;
    weakSelf.endView.hidden = NO;
    [weakSelf.contentView bringSubviewToFront:weakSelf.endView];
    
    
    
//    [[ALinNetworkTool shareTool] GET:self.live.playStream parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        
//        NSLog(@"请求成功%@, 等待继续播放", responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"请求失败, 加载失败界面, 关闭播放器%@", error);
//        [weakSelf.moviePlayer shutdown];
//        [weakSelf.moviePlayer.view removeFromSuperview];
//        weakSelf.moviePlayer = nil;
//        weakSelf.endView.hidden = NO;
//        [weakSelf.contentView bringSubviewToFront:weakSelf.endView];
//    }];
}

- (void)quit
{
//    if (_catEarView) {
//        [_catEarView removeFromSuperview];
//        _catEarView = nil;
//    }
    
    if (_moviePlayer) {
        [self.moviePlayer shutdown];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
//    [self.socket disConnect];
    
    if ([self isLogin]) {
        
       [self SendleaveRoomCMD];
    }
    
    if (self.clickRelatedLive) {
        self.clickRelatedLive();
    }
    
//    [_renderer stop];
//    [_renderer.view removeFromSuperview];
//    _renderer = nil;
    [self.parentVc.navigationController popViewControllerAnimated:YES];
}

- (void)autoSendBarrage
{
    NSInteger spriteNumber = [_renderer spritesNumberWithName:nil];
    if (spriteNumber <= 50) { // 限制屏幕上的弹幕量
        [_renderer receive:[self walkTextSpriteDescriptorWithDirection:BarrageWalkDirectionR2L]];
    }
}
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
//        [_chatVC addMessageToDataSource:message progress:nil];
        
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
//        [self.giftView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.backgroundButton).offset(self.giftView.height);
//        }];
//        [self layoutIfNeeded];
    }completion:^(BOOL finished) {
        [self.backgroundButton removeFromSuperview];
        [self.giftVC.view removeFromSuperview];
        self.giftVC = nil;
    }];
    
    
}

-(void)fbSocketDidOpen:(FabricSocket *)fbSocket{
    
}
-(void)fbSocket:(FabricSocket *)fbSocket didFailWithError:(NSError *)error{
    
}
-(void)fbSocket:(FabricSocket *)fbSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    
}
#pragma mark - 弹幕描述符生产方法

long _index = 0;
/// 生成精灵描述 - 过场文字弹幕
- (BarrageDescriptor *)walkTextSpriteDescriptorWithDirection:(NSInteger)direction
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
    descriptor.params[@"text"] = self.danMuText[arc4random_uniform((uint32_t)self.danMuText.count)];
//    descriptor.params[@"textColor"] = Color(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256));
    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50);
    descriptor.params[@"direction"] = @(direction);
    descriptor.params[@"clickAction"] = ^{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"弹幕被点击" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alertView show];
    };
    return descriptor;
}

- (NSArray *)danMuText
{
    return [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"danmu.plist" ofType:nil]];
}
@end
