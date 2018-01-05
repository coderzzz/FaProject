//
//  AppDelegate.h
//  MiaowShow
//
//  Created by ALin on 16/6/14.
//  Copyright © 2016年 ALin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (copy,nonatomic) NSString *clientId;


//导航页
-(void)showIntro;

-(void)showRegister;

-(void)showLogin;

-(void)showTabViewController;



@end

