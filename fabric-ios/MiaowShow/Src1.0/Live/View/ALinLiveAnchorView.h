//
//  ALinLiveAnchorView.h
//  MiaowShow
//
//  Created by ALin on 16/6/16.
//  Copyright © 2016年 ALin. All rights reserved.
//  直播间主播相关的视图

#import <UIKit/UIKit.h>
#import "LiveUserModel.h"

@class ALinUser;

@interface ALinLiveAnchorView : UIView
+ (instancetype)liveAnchorView;
/** 主播 */
@property(nonatomic, strong) ALinUser *user;
/** 直播 */
@property(nonatomic, strong) LiveUserModel *live;
/** 点击开关  */
@property(nonatomic, copy)void (^clickDeviceShow)(UIButton *btn);

@property(nonatomic, copy)void (^clickBack)(void);
@property(nonatomic, copy)void (^clickShop)(void);

@property (weak, nonatomic) IBOutlet UIButton *careBtn;
@property (weak, nonatomic) IBOutlet UILabel *peopleLabel;
- (IBAction)backAction:(id)sender;

@end
