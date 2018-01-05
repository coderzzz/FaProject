//
//  AppMacro.h
//  AnyChatInterview
//
//  Created by bairuitech on 2017/3/23.
//  Copyright © 2017年 anychat. All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h

#define k_sysVersion (float)[[[UIDevice currentDevice] systemVersion] floatValue]


//根据当前屏幕宽度得到宽度
#define pixw(p) ( ((SCREEN_WIDTH/414.0)*p) < ((SCREEN_HEIGHT/414.0)*p) ? ((SCREEN_WIDTH/414.0)*p) : ((SCREEN_HEIGHT/414.0)*p))

//根据当前屏幕高度得到高度
//#define pixh(p)  SCREEN_HEIGHT/568.0*p
#define pixh(p)  SCREEN_HEIGHT/1104.0*p
#define RGBA_COLOR(R, G, B, A) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:A]
#define RGB_COLOR(R, G, B) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:1.0f]


#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))


// 处于调试状态
#ifdef DEBUG
#define YJLog(...) NSLog(__VA_ARGS__)

// 发布状态
#else
#define YJLog(...)
#endif


#pragma mark - GCD Synthesize Singleton Mode

#define kGCD_SINGLETON_FOR_HEADER(classname) \
\
+ (instancetype)shared##classname;

#define kGCD_SINGLETON_FOR_CLASS(classname) \
\
static classname *shared##classname = nil; \
\
+(id)allocWithZone:(struct _NSZone *)zone   \
{   \
static dispatch_once_t onceToken;   \
dispatch_once(&onceToken, ^{    \
shared##classname = [super allocWithZone:zone]; \
});     \
return shared##classname;   \
}   \
\
+(instancetype)shared##classname   \
{   \
static dispatch_once_t onceToken;   \
dispatch_once(&onceToken, ^{    \
shared##classname = [[classname alloc] init];   \
});     \
return shared##classname;   \
}   \
\
-(id)copyWithZone:(NSZone *)zone    \
{   \
return shared##classname;   \
}


#endif /* AppMacro_h */
