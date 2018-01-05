//
//  AppDelegate.m
//  MiaowShow
//
//  Created by ALin on 16/6/14.
//  Copyright © 2016年 ALin. All rights reserved.
//

#import "AppDelegate.h"
#import "PayTool.h"


#import "BRLoginViewController.h"
#import "BRRegistViewController.h"
#import "MainViewController.h"
#import "ALinLiveCollectionViewController.h"
#import "TabbarViewController.h"
@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    //self.window.rootViewController = [[LoginViewController alloc] init];
    
    [self.window makeKeyAndVisible];
    
//    [self checkNetworkStates];
    
    
//    // 检测是否第一次使用这个版本
//    id key = (id)kCFBundleVersionKey;
//    // Info.plist
//    NSDictionary *info = [NSBundle mainBundle].infoDictionary;
//    // 获取当前软件的版本号
//    NSString *currentVersion = [info objectForKey:key];
//    
//    // 从沙盒中取出版本号
//    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
//    NSString *saveVersion = [defaults objectForKey:key];
    
//    // 不是第一次使用这个版本
//    if ([currentVersion isEqualToString:saveVersion])
//    {
//
    [self showTabViewController];
    
    BAIRUITECH_BRAccount *userInfo = [BAIRUITECH_BRAccoutTool account];

    if(userInfo.userId.length>2)
    {
       
        [self setUpSocket];

    }

//    [PayTool aliPayOrder:@"app_id=2016011201086258&biz_content=%7B%22out_trade_no%22%3A%2220171206232832275000%22%2C%22total_amount%22%3A%221%22%2C%22subject%22%3A%22%E6%B5%8B%E8%AF%95%E6%95%B0%E6%8D%AE%E5%93%A6%22%2C%22timeout_express%22%3A%2230m%22%2C%22product_code%22%3A%22QUICK_MSECURITY_PAY%22%7D&charset=utf-8&format=json&method=alipay.trade.app.pay&notify_url=http%253A%252F%252Fmobile.fabric.cn%252Fpay%252FmobileAlipayNotify&sign=fAz1sVc2AzgQTg9BbKwC8Zcd4TQwGLoEi98GaXTFQYmWefmNQBQw32VexqlbXAwEKqV6tJ42PCLDdTFxzHsi1EwPicty8CwYejJbs6uOIjNej%2FyWvRVqfpOJWPwxZgt9WmIHGKU8VY200cAggYSDX%2FyNPhOpVaMhmff2qlWw%2BqE%3D&sign_type=RSA&timestamp=2017-12-12+20%3A43%3A08&version=1.0&sign=fAz1sVc2AzgQTg9BbKwC8Zcd4TQwGLoEi98GaXTFQYmWefmNQBQw32VexqlbXAwEKqV6tJ42PCLDdTFxzHsi1EwPicty8CwYejJbs6uOIjNej%2FyWvRVqfpOJWPwxZgt9WmIHGKU8VY200cAggYSDX%2FyNPhOpVaMhmff2qlWw%2BqE%3D" callback:^(NSDictionary *resultDic) {
//        NSLog(@"%@",resultDic);
//    }];

//    }
//    else
//    {
//        // 第一次使用这个版本
//        // 更新沙盒中的版本号
//        [self showIntro];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            [defaults setObject:currentVersion forKey:key];
//            // 同步到沙盒中
//            [defaults synchronize];
//        });
//    }
//
    
    /* 设置友盟appkey */
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"599bf1ce82b63512ed00036d"];
    
    [self configUSharePlatforms];
    
    //    [self confitUShareSettings];
   [PayTool setUp];
    
    [[IQKeyboardManager sharedManager]disableDistanceHandlingInViewControllerClass:NSClassFromString(@"ALinLiveCollectionViewController")];
    [[IQKeyboardManager sharedManager]disableToolbarInViewControllerClass:NSClassFromString(@"ALinLiveCollectionViewController")];
    
    [[IQKeyboardManager sharedManager]disableDistanceHandlingInViewControllerClass:NSClassFromString(@"ShowTimeViewController")];
    [[IQKeyboardManager sharedManager]disableToolbarInViewControllerClass:NSClassFromString(@"ShowTimeViewController")];
    
    
    [[IQKeyboardManager sharedManager]disableDistanceHandlingInViewControllerClass:NSClassFromString(@"EaseMessageViewController")];
    [[IQKeyboardManager sharedManager]disableToolbarInViewControllerClass:NSClassFromString(@"EaseMessageViewController")];
    
    
    [[IQKeyboardManager sharedManager]disableDistanceHandlingInViewControllerClass:NSClassFromString(@"RoomSettingController")];
    [[IQKeyboardManager sharedManager]disableToolbarInViewControllerClass:NSClassFromString(@"RoomSettingController")];
    
    return YES;
}

- (void)setUpSocket{
    
    NSLog(@"setUpSocket");
    
    BAIRUITECH_BRAccount *userInfo = [BAIRUITECH_BRAccoutTool account];
    FabricSocket *socket = [FabricSocket shareInstances];
    socket.userId = userInfo.userId;
    socket.token = userInfo.token;
    socket.host = userInfo.chatAddress;
    [socket connect];
}

//// 支持所有iOS系统
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
//    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
//    if (!result) {
//        // 其他如支付等SDK的回调
//    }
//    return result;
//}
- (void)configUSharePlatforms
{
    /*
     设置微信的appKey和appSecret
     [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxd2adeee83b0f9771" appSecret:@"aa8a862d105dadc32a524b17b8d30a5f" redirectURL:nil];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     100424468.no permission of union id
     [QQ/QZone平台集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_3
     */
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105821097"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    //
    //    /*
    //     设置新浪的appKey和appSecret
    //     [新浪微博集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_2
    //     */
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3921700954"  appSecret:@"04b48b094faeb16683c32669824ebdad" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    
    
}



-(void)showRegister
{
    NSLog(@"showRegister");
    BRLoginViewController* vc1=[[BRLoginViewController alloc] init];
    self.window.rootViewController=vc1;
    
    BRRegistViewController* vc2=[[BRRegistViewController alloc] init];
    [vc1 presentViewController:vc2 animated:YES completion:^{
        ;
    }];
}

-(void)showLogin
{
    NSLog(@"showLogin");
    BRLoginViewController* vc=[[BRLoginViewController alloc] init];
//    ALinLiveCollectionViewController *vc =[ALinLiveCollectionViewController new];
    self.window.rootViewController=vc;
}


-(void)showIntro
{
//    IntroViewControllerNew *vc = [[IntroViewControllerNew alloc] init];
//    self.window.rootViewController=vc;
}

-(void)showTabViewController
{
//    MainViewController* main = [[MainViewController alloc] init];
    TabbarViewController* main = [[TabbarViewController alloc] init];
    self.window.rootViewController = main;
}


#pragma mark --Pay

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:self];
}
#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PaySucceed" object:nil userInfo:nil];
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }

    }
    
}

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
//}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    [WXApi handleOpenURL:url delegate:self];
    
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            [self handleAliPay:resultDic];

        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            [self handleAliPay:resultDic];

            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    [WXApi handleOpenURL:url delegate:self];
    
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            [self handleAliPay:resultDic];

        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            [self handleAliPay:resultDic];
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return YES;
}


- (void)handleAliPay:(NSDictionary *)resultDic{
    
    
    NSInteger orderState=[resultDic[@"resultStatus"] integerValue];
    
    if (orderState==9000) {
 
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PaySucceed" object:nil userInfo:resultDic];
        
    }else{
        NSString *returnStr;
        switch (orderState) {
            case 8000:
                returnStr=@"订单正在处理中";
                break;
            case 4000:
                returnStr=@"订单支付失败";
                break;
            case 6001:
                returnStr=@"订单取消";
                break;
            case 6002:
                returnStr=@"网络连接出错";
                break;
                
            default:
                break;
        }
        
    }
    
}

#pragma mark - 应用开始聚焦

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    // 给状态栏添加一个按钮可以进行点击, 可以让屏幕上的scrollView滚到最顶部
//    [SLTopWindow show];
}
@end
