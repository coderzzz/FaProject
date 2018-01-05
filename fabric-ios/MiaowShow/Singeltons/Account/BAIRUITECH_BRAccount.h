//
//  BRAccount.h
//  SuperIntercom
//
//  Created by Mac on 16/4/21.
//  Copyright © 2016年 AnyChat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BAIRUITECH_BRAccount : NSObject


@property (nonatomic,copy) NSString *userLogo;
//id
@property (nonatomic,copy) NSString *userId;
//昵称
@property (nonatomic,copy) NSString *nickName;
//token
@property (nonatomic,copy) NSString *token;
@property (nonatomic,copy) NSString *chatAddress;

@property (nonatomic,copy) NSString *sex;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *roomId;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *loginName;

@property (nonatomic,copy) NSString *isIdValid;
/*
 通过手机账号登陆将字典存到本地
 */
- (instancetype )initWithDictionary:(NSDictionary *)dict;

+ (instancetype )accountWithDictionary:(NSDictionary *)dict;



@end
