//
//  ALinLive.h
//  MiaowShow
//
//  Created by ALin on 16/6/14.
//  Copyright © 2016年 ALin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALinLive : NSObject
/** 主播名 */
@property (nonatomic, copy) NSString *nickName;
/** 直播流地址 */
@property (nonatomic, copy) NSString   *playStream;
/** 主播头像 */
@property (nonatomic, copy) NSString   *userLogo;
/** 直播房间号码 */
@property (nonatomic, assign) NSUInteger roomId;
/** 房间名称 */
@property (nonatomic, copy) NSString   *roomName;







/** 直播图 */
@property (nonatomic, copy  ) NSString   *bigpic;


/** 所在城市 */
@property (nonatomic, copy  ) NSString   *gps;

/** 个性签名 */
@property (nonatomic, copy  ) NSString   *signatures;
/** 用户ID */
@property (nonatomic, copy  ) NSString   *userId;
/** 星级 */
@property (nonatomic, assign) NSUInteger starlevel;
/** 朝阳群众数目 */
@property (nonatomic, assign) NSUInteger allnum;
/** 这玩意未知 */
@property (nonatomic, assign) NSUInteger lrCurrent;

/** 所处服务器 */
@property (nonatomic, assign) NSUInteger serverid;
/** 用户ID */
@property (nonatomic, assign) NSString   *useridx;
/** 排名 */
@property (nonatomic, assign) NSUInteger pos;
/** starImage */
@property (nonatomic, strong) UIImage    *starImage;




@end
