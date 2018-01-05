//
//  MainViewController.m
//  MiaowShow
//
//  Created by ALin on 16/6/14.
//  Copyright © 2016年 ALin. All rights reserved.
//

#import "TabbarViewController.h"
#import "ALinNavigationController.h"
#import "FabricMineViewController.h"
#import "HomeViewController.h"
#import "HOMEController.h"
#import "GetOrderCenterController.h"
#import "DISViewController.h"
#import "MESSAGEViewController.h"
#import "MINEViewController.h"
#import "FindObjController.h"
@interface TabbarViewController ()<UITabBarControllerDelegate>

@end

@implementation TabbarViewController
{
    UIButton *button;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    
    //点击时候的字体颜色
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:Color} forState:UIControlStateSelected];
    
    [[UITabBar appearance] setTintColor:Color];

    self.delegate = self;
    [self setup];
    [self.view bringSubviewToFront:button];
}

- (void)viewWillAppear:(BOOL)animated{
    
    button.hidden = NO;
    [self.view bringSubviewToFront:button];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    button.hidden = YES;
}

#pragma mark - addCenterButton
// Create a custom UIButton and add it to the center of our tab bar
-(void) addCenterButtonWithImage:(UIImage*)buttonImage selectedImage:(UIImage*)selectedImage
{
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    
    [button addTarget:self action:@selector(pressChange:) forControlEvents:UIControlEventTouchUpInside];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    
    //  设定button大小为适应图片
    button.frame = CGRectMake(SCREEN_WIDTH/2 - 25, -17, 50, 60);
//    [button setTitle:@"发布" forState:UIControlStateNormal];
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button setImage:selectedImage forState:UIControlStateSelected];
    button.userInteractionEnabled = NO;
    //  这个比较恶心  去掉选中button时候的阴影
    button.adjustsImageWhenHighlighted=NO;

    [self.tabBar addSubview:button];
}

-(void)pressChange:(id)sender
{
    self.selectedIndex = 2;
//    self.selectedIndex=2;
//    button.selected=YES;
}

#pragma mark- TabBar Delegate





- (void)setup
{

    [self addChildViewController:[[HOMEController alloc] init] imageNamed:@"home" titleNamed:@"首页"];
    [self addChildViewController:[[GetOrderCenterController alloc]init] imageNamed:@"search_list" titleNamed:@"订单"];
    [self addChildViewController:[[FindObjController alloc] init] imageNamed:@"round_add" titleNamed:@"发布"];
    [self addChildViewController:[[HomeViewController alloc] init] imageNamed:@"mark" titleNamed:@"消息"];
    [self addChildViewController:[[MINEViewController alloc] init] imageNamed:@"my" titleNamed:@"我的"];

}

- (void)addChildViewController:(UIViewController *)childController imageNamed:(NSString *)imageName titleNamed:(NSString*)titleName
{
    ALinNavigationController *nav = [[ALinNavigationController alloc] initWithRootViewController:childController];
    nav.navigationItem.leftBarButtonItem = nil;
    // 设置图片居中, 这儿需要注意top和bottom必须绝对值一样大
    // {top, left, bottom, right};
    if ([titleName isEqualToString:@"发布"]) {
        childController.navigationItem.title = @"委托找样";
        FindObjController *vc = (FindObjController *)childController;
        vc.type = @"1";
        childController.tabBarItem.image = [[UIImage imageNamed:@"wq"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self addCenterButtonWithImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:[NSString stringWithFormat:@"%@_fill", imageName]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        
    }else{
        childController.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        childController.tabBarItem.selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@_fill", imageName]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        childController.tabBarItem. = UIEdgeInsetsMake(0, 0, 0, 0);
    }
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
        
//        [self show];
        return YES;
    }
    return YES;
}



- (void)show{
    
//    
////    [self showInfo:@"show"];
////    [self showHint:@"show"];
////    log.text = @"show";
//    BAIRUITECH_BRAccount *account = [BAIRUITECH_BRAccoutTool account];
//    if (![account.isIdValid isEqualToString:@"Y"]) {
//        
//        RealNameViewController *vc = [[RealNameViewController alloc]init];
//        ALinNavigationController *nav = [[ALinNavigationController alloc]initWithRootViewController:vc];
//        [self presentViewController:nav animated:YES completion:nil];
//        return;
//    }
//    
////    [self showInfo:@"enter"];
////    log.text = [NSString stringWithFormat:@"%@\n enter ",log.text];
//    [BAIRUITECH_NetWorkManager FinanceLiveShow_enterLiveActivity:@{@"userId":account.userId} withSuccessBlock:^(NSDictionary *object) {
//        
//        
//        if([object[@"ret"] intValue] == 0){
//            
////            [self showHint:@"ShowTime"];
////            log.text = [NSString stringWithFormat:@"%@\n ShowTime ",log.text];
//            ShowTimeViewController *vc = [UIStoryboard storyboardWithName:NSStringFromClass([ShowTimeViewController class]) bundle:nil].instantiateInitialViewController;
//            LiveUserModel *live =[LiveUserModel new];
//            live = [LiveUserModel mj_objectWithKeyValues:object[@"data"][@"star"]];
//            live.chatAddress =object[@"data"][@"chat"][@"chatAddress"];
//            live.chatKey = object[@"data"][@"chat"][@"chatKey"];
//            vc.live = live;
//            
////            log.text = [NSString stringWithFormat:@"%@\n present ",log.text];
//            [self presentViewController:vc animated:YES completion:nil];
//            
//        }else{
//
//            
//            [BAIRUITECH_BRTipView showTipTitle:object[@"msg"] delay:2];
//        }
//        
//    } withFailureBlock:^(NSError *error) {
//        
//        YJLog(@"%@",error);
//        
//    }];
}

- (BOOL)isLogin{
    
    BAIRUITECH_BRAccount *user = [BAIRUITECH_BRAccoutTool account];
    if ([user.userId isEqualToString:@"0"]) {
        
        return NO;
    }
    return YES;
}



@end
