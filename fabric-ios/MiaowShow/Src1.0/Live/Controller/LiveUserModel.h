//
//  LiveUserModel.h
//  MiaowShow
//
//  Created by bairuitech on 2017/8/29.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiveUserModel : NSObject

/** 主播名 */
@property (nonatomic, copy) NSString *nickName;
/** 直播流地址 */
@property (nonatomic, copy) NSString   *pushStream;
/** 直播流地址 */
@property (nonatomic, copy) NSString   *playStream;
/** 主播头像 */
@property (nonatomic, copy) NSString   *userLogo;
/** 直播房间号码 */
@property (nonatomic, assign) NSUInteger roomId;
/** 房间名称 */
@property (nonatomic, copy) NSString   *roomName;

@property (nonatomic, copy) NSString   *userId;

@property (nonatomic, assign) BOOL isFollow;

//////
@property (nonatomic, copy) NSString *chatAddress;
@property (nonatomic, copy) NSString *chatKey;


@end
