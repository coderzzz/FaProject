//
//  MainViewController.m
//  MiaowShow
//
//  Created by ALin on 16/6/14.
//  Copyright © 2016年 ALin. All rights reserved.
//

#import "MainViewController.h"
#import "HomeViewController.h"
//#import "ProfileController.h"
#import "ShowTimeViewController.h"
#import "ALinNavigationController.h"
//#import "UIDevice+SLExtension.h"
#import <AVFoundation/AVFoundation.h>
#import "BRLoginViewController.h"
#import "BRLoginNavigationController.h"
#import "FabricHomeViewController.h"
#import "FabricVideoViewController.h"
#import "HomeViewController.h"

#import "FabricMineViewController.h"
#import "RealNameViewController.h"
@interface MainViewController ()<UITabBarControllerDelegate>
{
    UITextView *log;
}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    [[UITabBar appearance] setBarTintColor:[BAIRUITECH_Utils colorWithHexString:@"#ffffff"]];
    
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    
    //点击时候的字体颜色
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:MainColor} forState:UIControlStateSelected];
    
    [[UITabBar appearance] setTintColor:MainColor];

    self.delegate = self;
    [self setup];
}

- (void)setup
{

    [self addChildViewController:[[FabricHomeViewController alloc] init] imageNamed:@"toolbar_home" titleNamed:@"首页"];
    [self addChildViewController:[[FabricVideoViewController alloc]init] imageNamed:@"toolbar_video" titleNamed:@"商家"];
    [self addChildViewController:[[UIViewController alloc] init] imageNamed:@"toolbar_live" titleNamed:@""];
    [self addChildViewController:[[HomeViewController alloc] init] imageNamed:@"toolbar_msg" titleNamed:@"消息"];
    [self addChildViewController:[[FabricMineViewController alloc] init] imageNamed:@"toolbar_me" titleNamed:@"我的"];

    
}

- (void)addChildViewController:(UIViewController *)childController imageNamed:(NSString *)imageName titleNamed:(NSString*)titleName
{
    ALinNavigationController *nav = [[ALinNavigationController alloc] initWithRootViewController:childController];
    childController.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childController.tabBarItem.selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_sel", imageName]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 设置图片居中, 这儿需要注意top和bottom必须绝对值一样大
    childController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    childController.tabBarItem.title = titleName;
    
    // 设置导航栏为透明的
//    if ([childController isKindOfClass:[ProfileController class]]) {
//        [nav.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//        nav.navigationBar.shadowImage = [[UIImage alloc] init];
//        nav.navigationBar.translucent = YES;
//    }
    [self addChildViewController:nav];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([tabBarController.childViewControllers indexOfObject:viewController] == tabBarController.childViewControllers.count-3) {
        
        if (![self isLogin]) {
            
            [self showLogin];
            return NO;
        }
        
        // 判断是否是模拟器
//        if ([[UIDevice deviceVersion] isEqualToString:@"iPhone Simulator"]) {
//            [self showInfo:@"请用真机进行测试, 此模块不支持模拟器测试"];
//            return NO;
//        }
        
        // 判断是否有摄像头
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
//            [self showInfo:@"您的设备没有摄像头或者相关的驱动, 不能进行直播"];
            return NO;
        }
        
        // 判断是否有摄像头权限
        AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied) {
//            [self showInfo:@"app需要访问您的摄像头。\n请启用摄像头-设置/隐私/摄像头"];
            return NO;
        }
        
        // 开启麦克风权限
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    return YES;
                }
                else {
//                    [self showInfo:@"app需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风"];
                    return NO;
                }
            }];
        }
//        log = [[UITextView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT-50)];
//        log.backgroundColor = [UIColor clearColor];
//        log.font = [UIFont systemFontOfSize:15];
//        log.textColor = [UIColor redColor];
//        [self.view addSubview:log];
        [self show];
        return NO;
    }
    return YES;
}



- (void)show{
    
    
//    [self showInfo:@"show"];
//    [self showHint:@"show"];
//    log.text = @"show";
    BAIRUITECH_BRAccount *account = [BAIRUITECH_BRAccoutTool account];
    if (![account.isIdValid isEqualToString:@"Y"]) {
        
        RealNameViewController *vc = [[RealNameViewController alloc]init];
        ALinNavigationController *nav = [[ALinNavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    
//    [self showInfo:@"enter"];
//    log.text = [NSString stringWithFormat:@"%@\n enter ",log.text];
    [BAIRUITECH_NetWorkManager FinanceLiveShow_enterLiveActivity:@{@"userId":account.userId} withSuccessBlock:^(NSDictionary *object) {
        
        
        if([object[@"ret"] intValue] == 0){
            
//            [self showHint:@"ShowTime"];
//            log.text = [NSString stringWithFormat:@"%@\n ShowTime ",log.text];
            ShowTimeViewController *vc = [UIStoryboard storyboardWithName:NSStringFromClass([ShowTimeViewController class]) bundle:nil].instantiateInitialViewController;
            LiveUserModel *live =[LiveUserModel new];
            live = [LiveUserModel mj_objectWithKeyValues:object[@"data"][@"star"]];
            live.chatAddress =object[@"data"][@"chat"][@"chatAddress"];
            live.chatKey = object[@"data"][@"chat"][@"chatKey"];
            vc.live = live;
            
//            log.text = [NSString stringWithFormat:@"%@\n present ",log.text];
            [self presentViewController:vc animated:YES completion:nil];
            
        }else{

            
            [BAIRUITECH_BRTipView showTipTitle:object[@"msg"] delay:2];
        }
        
    } withFailureBlock:^(NSError *error) {
        
        YJLog(@"%@",error);
        
    }];
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
//            [self SendEnterRoomCMD];
        });
        
        
    }];
    
    BRLoginNavigationController *nav = [[BRLoginNavigationController alloc]initWithRootViewController:vc];
    
    [self presentViewController:nav animated:YES completion:nil];
}

@end
