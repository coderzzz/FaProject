//
//  PayTool.m
//  Farbic
//
//  Created by bairuitech on 2017/12/6.
//  Copyright © 2017年 ALin. All rights reserved.
//

#import "PayTool.h"
//wxa8cb2553d7add76f

@implementation PayTool

+ (void)setUp{
    
     [WXApi registerApp:@"wx5fa6e859bfba1ff3"];
}

+ (void)aliPayOrder:(NSString *)orderStr
           callback:(void(^)(NSDictionary *resultDic))blcok{
    
    [[AlipaySDK defaultService] payOrder:orderStr fromScheme:@"farbic" callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
        if (blcok) {
            blcok(resultDic);
        }
    }];
}

+ (void)sendWeChatPay:(NSDictionary *)dict{
    
    NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
    
    //调起微信支付
    PayReq* req             = [[PayReq alloc] init];
    req.partnerId           = [dict objectForKey:@"partnerid"];
    req.prepayId            = [dict objectForKey:@"prepayid"];
    req.nonceStr            = [dict objectForKey:@"noncestr"];
    req.timeStamp           = stamp.intValue;
    req.package             = [dict objectForKey:@"package"];
    req.sign                = [dict objectForKey:@"sign"];
    [WXApi sendReq:req];
}
@end
