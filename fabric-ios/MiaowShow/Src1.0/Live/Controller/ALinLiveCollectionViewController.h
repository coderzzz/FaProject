//
//  ALinLiveCollectionViewController.h
//  MiaowShow
//
//  Created by ALin on 16/6/23.
//  Copyright © 2016年 ALin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveUserModel.h"
@class ALinLive;
@interface ALinLiveCollectionViewController : UIViewController
/** 直播 */
@property (nonatomic, strong) NSArray *lives;
/** 当前的index */
@property (nonatomic, assign) NSUInteger currentIndex;

@property (nonatomic, strong) LiveUserModel *live;

@property (nonatomic, copy) void(^helpBack)();

@end
