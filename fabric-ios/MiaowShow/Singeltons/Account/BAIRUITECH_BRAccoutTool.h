//
//  BAIRUITECH_BRAccoutTool.h
//  SuperIntercom
//
//  Created by Mac on 16/4/25.
//  Copyright © 2016年 AnyChat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BAIRUITECH_BRAccount.h"
@interface BAIRUITECH_BRAccoutTool : NSObject

//单例
+ (instancetype)shareInstance;

/**
 *  存储账号信息
 *
 *  @param account 需要存储的账号
 */
+ (void)saveAccount:(BAIRUITECH_BRAccount * )account;

//返回存储的账号信息
+ (BAIRUITECH_BRAccount * )account;

//删除用户
+ (BOOL)removeAccount;




@end
