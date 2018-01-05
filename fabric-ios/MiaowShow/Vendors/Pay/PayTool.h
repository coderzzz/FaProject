//
//  PayTool.h
//  Farbic
//
//  Created by bairuitech on 2017/12/6.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>


@interface PayTool : NSObject

+ (void)setUp;

+ (void)aliPayOrder:(NSString *)orderStr
           callback:(void(^)(NSDictionary *resultDic))blcok;

+ (void)sendWeChatPay:(NSDictionary *)dict;
@end
